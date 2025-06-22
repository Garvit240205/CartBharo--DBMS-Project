from flask import Flask, render_template, request, redirect, url_for, session, flash
import mysql.connector
from datetime import date, datetime 

app = Flask(__name__)
app.secret_key = 'a_very_secret_and_complex_key_12345'

# --- Database Configuration ---
def get_db_connection():
    try:
        connection = mysql.connector.connect(
            user='root',
            password='1234',  # IMPORTANT: Change this to your MySQL root password
            host='localhost',
            database='CARTBHARO'
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Database Connection Error: {err}")
        return None

@app.route('/checkout')
def checkout():
    if 'logged_in' not in session or session.get('role') != 'customer':
        flash("You must be logged in to proceed to checkout.", "warning")
        return redirect(url_for('login'))

    userID = session['userID']
    
    # Get all items from the user's cart
    cart_items_query = """
        SELECT c.productID, p.product_name, p.product_price, c.cart_size 
        FROM cart c JOIN product p ON c.productID = p.productID 
        WHERE c.userID = %s
    """
    cart_items = execute_query(cart_items_query, (userID,), fetch='all')

    if not cart_items:
        flash("Your cart is empty. Add items before checking out.", "info")
        return redirect(url_for('customer_dashboard'))

    # Calculate the total price
    total_price = sum(item['cart_size'] * item['product_price'] for item in cart_items)
    
    return render_template('checkout.html', cart_items=cart_items, total_price=total_price)

# NEW and IMPROVED place_order function
@app.route('/place_order', methods=['POST'])
def place_order():
    if 'logged_in' not in session or session.get('role') != 'customer':
        return redirect(url_for('login'))

    userID = session['userID']

    # Get cart items with product stock information
    cart_check_query = """
        SELECT c.productID, c.cart_size, p.quantity_remaining, p.product_name
        FROM cart c JOIN product p ON c.productID = p.productID
        WHERE c.userID = %s
    """
    cart_items = execute_query(cart_check_query, (userID,), fetch='all')

    if not cart_items:
        flash("Your cart is empty.", "warning")
        return redirect(url_for('customer_dashboard'))

    # --- 1. Check if there is enough stock for every item in the cart ---
    for item in cart_items:
        if item['cart_size'] > item['quantity_remaining']:
            flash(f"Not enough stock for {item['product_name']}. Only {item['quantity_remaining']} left.", "danger")
            return redirect(url_for('checkout')) # Redirect back to the checkout page to show the error

    # If we get here, all stock is sufficient. Proceed with the order.
    try:
        # 2. Get a new, unique orderID
        max_order_id_result = execute_query("SELECT MAX(orderID) as max_id FROM orders", fetch='one')
        new_order_id = (max_order_id_result['max_id'] or 0) + 1

        # 3. Insert into 'orders' and UPDATE product stock for each item
        order_insert_query = "INSERT INTO orders (orderID, userID, productID, quantity, order_date) VALUES (%s, %s, %s, %s, %s)"
        stock_update_query = "UPDATE product SET quantity_remaining = quantity_remaining - %s WHERE productID = %s"
        today = datetime.now().date()
        
        total_price = 0

        for item in cart_items:
            # Insert into orders table
            order_values = (new_order_id, userID, item['productID'], item['cart_size'], today)
            execute_query(order_insert_query, order_values)

            # Update the product stock
            stock_values = (item['cart_size'], item['productID'])
            execute_query(stock_update_query, stock_values)
            
            # We can calculate total price here instead of another query
            product_price_res = execute_query("SELECT product_price FROM product WHERE productID = %s", (item['productID'],), fetch='one')
            total_price += item['cart_size'] * product_price_res['product_price']

        # 4. Create a payment record
        payment_query = "INSERT INTO payment (userID, orderID, amount) VALUES (%s, %s, %s)"
        execute_query(payment_query, (userID, new_order_id, total_price))

        # 5. Clear the user's cart
        clear_cart_query = "DELETE FROM cart WHERE userID = %s"
        execute_query(clear_cart_query, (userID,))

        flash(f"Order #{new_order_id} placed successfully!", 'success')
        return redirect(url_for('customer_dashboard'))

    except Exception as e:
        # In a real app, you would implement a transaction rollback here to undo partial changes
        flash(f"An error occurred while placing your order: {e}", "danger")
        return redirect(url_for('checkout'))
    
    
# --- Helper Function to Execute Queries ---
def execute_query(query, values=None, fetch=None):
    conn = get_db_connection()
    if not conn:
        flash("Database connection could not be established.", "danger")
        return None
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(query, values or ())
        if fetch == 'all':
            results = cursor.fetchall()
        elif fetch == 'one':
            results = cursor.fetchone()
        else:
            conn.commit()
            results = cursor.lastrowid or cursor.rowcount
        return results
    except mysql.connector.Error as err:
        flash(f"A database error occurred: {err}", "danger")
        print(f"Error: {err}") # For debugging
        return None
    finally:
        cursor.close()
        conn.close()

# --- Main & Auth Routes ---
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('You have been successfully logged out.', 'info')
    return redirect(url_for('index'))

# --- Admin Section ---
@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        query = """
            SELECT a.*, e.emailnum 
            FROM admin a 
            JOIN email e ON a.emailID = e.emailID 
            WHERE e.emailnum = %s AND a.passwd = %s
        """
        admin_data = execute_query(query, (email, password), fetch='one')
        
        if admin_data:
            session['logged_in'] = True
            session['role'] = 'admin'
            session['name'] = admin_data['first_name']
            session['adminID'] = admin_data['adminID']
            flash(f"Welcome, {session['name']}!", 'success')
            return redirect(url_for('admin'))
        else:
            flash('Invalid admin email or password.', 'danger')

    if 'logged_in' in session and session['role'] == 'admin':
        return render_template('admin.html')
    
    return render_template('admin.html', show_login=True)

@app.route('/admin/query', methods=['POST'])
def admin_query():
    if 'logged_in' not in session or session['role'] != 'admin':
        return redirect(url_for('admin'))

    query_option = request.form.get('query_option')
    results, title, headers = None, "", []

    if query_option == 'count_orders':
        title = "Total Number of Distinct Orders"
        headers = ["Total Orders"]
        results = execute_query("SELECT COUNT(distinct orderID) as total_orders FROM orders", fetch='all')
    elif query_option == 'list_products':
        title = "All Products"
        headers = ["ID", "Supplier ID", "Price", "Name", "Stock"]
        results = execute_query("SELECT * FROM product", fetch='all')
    elif query_option == 'add_offer':
        try:
            offerID = request.form['offerID']
            userID = request.form['userID']
            discount = request.form['discount']
            last_login = request.form['last_login_date']
            
            query = "INSERT INTO offers(offerID, userID, discount, last_login_date, today_date) VALUES (%s, %s, %s, %s, %s)"
            execute_query(query, (offerID, userID, discount, last_login, date.today()))
            flash('Offer added successfully!', 'success')
            title = "All Offers"
            headers = ["Offer ID", "User ID", "Discount", "Last Login", "Date Added"]
            results = execute_query("SELECT * FROM offers", fetch='all')
        except Exception as e:
            flash(f"Error adding offer: {e}", 'danger')

    return render_template('admin.html', results=results, title=title, headers=headers)

# --- Customer Section ---
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user_data = execute_query("SELECT * FROM user WHERE email = %s AND passwd = %s", (email, password), fetch='one')
        if user_data:
            session['logged_in'] = True
            session['role'] = 'customer'
            session['userID'] = user_data['userID']
            session['name'] = user_data['first_name']
            return redirect(url_for('customer_dashboard'))
        else:
            flash('Invalid email or password.', 'danger')
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        if execute_query("SELECT userID FROM user WHERE email = %s", (request.form['email'],), fetch='one'):
            flash('An account with this email already exists.', 'warning')
            return redirect(url_for('signup'))
            
        query = """INSERT INTO user (first_name, last_name, city, state, zip, country, age, phonenum, email, passwd) 
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        values = (
            request.form['f_name'], request.form['l_name'], request.form['city'], request.form['state'],
            request.form['zip'], request.form['country'], request.form['age'],
            request.form['phonenum'], request.form['email'], request.form['passwd']
        )
        execute_query(query, values)
        flash('Signup successful! Please log in.', 'success')
        return redirect(url_for('login'))
    return render_template('signup.html')


@app.route('/dashboard')
def customer_dashboard():
    if 'logged_in' not in session or session.get('role') != 'customer':
        return redirect(url_for('login'))
    
    # Pre-fetch data for the dashboard
    products = execute_query("SELECT * FROM product WHERE quantity_remaining > 0", fetch='all')
    cart_items_query = """
        SELECT c.productID, p.product_name, p.product_price, c.cart_size 
        FROM cart c JOIN product p ON c.productID = p.productID 
        WHERE c.userID = %s
    """
    cart_items = execute_query(cart_items_query, (session['userID'],), fetch='all')
    
    return render_template('customer_dashboard.html', products=products, cart_items=cart_items)


@app.route('/add_to_cart', methods=['POST'])
def add_to_cart():
    if 'logged_in' not in session or session.get('role') != 'customer':
        return redirect(url_for('login'))
    
    productID = request.form['productID']
    quantity = int(request.form.get('quantity', 1))
    userID = session['userID']

    # Your schema has CHECK (cartID = userID)
    cartID = userID

    # Check if item is already in cart, if so, update quantity
    existing_item = execute_query("SELECT * FROM cart WHERE cartID=%s AND productID=%s", (cartID, productID), fetch='one')
    if existing_item:
        new_quantity = existing_item['cart_size'] + quantity
        query = "UPDATE cart SET cart_size = %s WHERE cartID = %s AND productID = %s"
        values = (new_quantity, cartID, productID)
    else:
        query = "INSERT INTO cart (cartID, productID, cart_size, userID) VALUES (%s, %s, %s, %s)"
        values = (cartID, productID, quantity, userID)
    
    execute_query(query, values)
    flash('Item added to cart!', 'success')
    return redirect(url_for('customer_dashboard'))

@app.route('/remove_from_cart', methods=['POST'])
def remove_from_cart():
    if 'logged_in' not in session or session.get('role') != 'customer':
        return redirect(url_for('login'))
    
    productID = request.form['productID']
    cartID = session['userID'] # cartID is userID
    execute_query("DELETE FROM cart WHERE cartID=%s AND productID=%s", (cartID, productID))
    flash('Item removed from cart.', 'info')
    return redirect(url_for('customer_dashboard'))


# --- Embedded SQL & Triggers ---
@app.route('/embedded', methods=['GET', 'POST'])
def embedded_sql():
    results, title, headers = None, "", []
    if request.method == 'POST':
        query_option = request.form.get('query_option')
        if query_option == 'top_customers':
            title = "Top 3 Paying Customers"
            headers = ["User ID", "First Name", "Total Paid"]
            query = """
                SELECT u.userID, u.first_name, SUM(p.amount) as total_paid 
                FROM user u JOIN payment p ON u.userID = p.userID 
                GROUP BY u.userID, u.first_name 
                ORDER BY total_paid DESC LIMIT 3
            """
            results = execute_query(query, fetch='all')
        elif query_option == 'top_delivery':
            title = "Top 3 Rated Delivery Partners"
            headers = ["Agent ID", "First Name", "Average Rating"]
            query = """
                SELECT da.agentID, da.first_name, AVG(af.rating) as avg_rating 
                FROM delivery_agent da JOIN agent_feedback af ON da.agentID = af.agentID AND da.orderID = af.orderID
                GROUP BY da.agentID, da.first_name 
                ORDER BY avg_rating DESC LIMIT 3
            """
            results = execute_query(query, fetch='all')
        elif query_option == 'fast_feedback':
            title = "Users who gave 'Fast' Feedback"
            headers = ["User ID", "First Name", "Order ID", "Feedback"]
            query = """
                SELECT u.userID, u.first_name, o.orderID, o.feedback_text 
                FROM user u JOIN order_feedback o ON u.userID = o.userID 
                WHERE o.feedback_text LIKE 'Fast%%'
            """
            results = execute_query(query, fetch='all')

    return render_template('embedded.html', results=results, title=title, headers=headers)


@app.route('/triggers', methods=['GET', 'POST'])
def triggers():
    results, title, headers = None, "", []
    if request.method == 'POST':
        trigger_option = request.form.get('trigger_option')
        try:
            if trigger_option == 'invalid_rating':
                title = "Order Feedback Table After Insert"
                headers = ["ID", "User", "Order", "Feedback", "Rating"]
                values = (request.form['userID'], request.form['orderID'], request.form['feedback_text'], request.form['rating'])
                execute_query("INSERT INTO order_feedback (userID, orderID, feedback_text, rating) VALUES (%s, %s, %s, %s)", values)
                flash("Feedback submitted. The trigger has been activated.", "info")
                results = execute_query("SELECT * FROM order_feedback", fetch='all')
            
            elif trigger_option == 'low_payment':
                title = "Payment Table After Insert"
                headers = ["ID", "User", "Order", "Amount"]
                values = (request.form['userID'], request.form['orderID'], request.form['amount'])
                execute_query("INSERT INTO payment (userID, orderID, amount) VALUES (%s, %s, %s)", values)
                flash("Payment submitted. The trigger has been activated.", "info")
                results = execute_query("SELECT * FROM payment", fetch='all')

            # NEW CODE in app.py
            # NEW, MORE ROBUST CODE BLOCK
            elif trigger_option == 'low_price':
                title = "Product Table After Insert"
                headers = ["ID", "Supplier", "Price", "Name", "Stock"]
                
                # --- START OF ROBUST VALIDATION ---
                try:
                    # Attempt to get and convert values to their correct types.
                    # This will fail if the input is empty or not a valid number.
                    supplier_id = int(request.form.get('supplierID'))
                    product_price = float(request.form.get('product_price'))
                    quantity = int(request.form.get('quantity_remaining'))
                    
                    # Product name just needs to exist.
                    product_name = request.form.get('product_name')
                    if not product_name:
                        # This raises a ValueError to be caught by the 'except' block
                        raise ValueError("Product Name is required.")

                except (ValueError, TypeError):
                    # This 'except' block catches:
                    # - ValueError: if int() or float() fails (e.g., int('abc') or int(''))
                    # - ValueError: if we raise it ourselves for the product name.
                    # - TypeError: if .get() returns None (field is missing) and int(None) is attempted.
                    flash("Invalid input. Please ensure all fields are filled correctly. IDs and numbers must be valid numbers.", "danger")
                    return render_template('triggers.html')
                # --- END OF ROBUST VALIDATION ---

                values = (supplier_id, product_price, product_name, quantity)
                execute_query("INSERT INTO product (supplierID, product_price, product_name, quantity_remaining) VALUES (%s, %s, %s, %s)", values)
                flash("Product added. The trigger has been activated.", "info")
                results = execute_query("SELECT * FROM product", fetch='all')
        except Exception as e:
            flash(f"Error executing operation: {e}", "danger")
            
    return render_template('triggers.html', results=results, title=title, headers=headers)


if __name__ == '__main__':
    app.run(debug=True, port=5001)