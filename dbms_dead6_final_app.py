from datetime import date
import re
import tkinter as tk
import tkinter.messagebox as mb
from tkinter import ttk
import threading
import mysql.connector
from numpy import size

connection = mysql.connector.connect(user='root', password='1234', host='localhost', database='cartbharo')
cursor = connection.cursor()

orderID_entry = None
productID_entry = None
cart_size_entry = None
userID_entry = None

def execute_query(query, values=None):
    cursor.execute(query, values)
    return cursor.fetchall()

def admin_interface():
    admin_window = tk.Toplevel()
    admin_window.title("Admin Interface")

    def validate_admin_login():
        email = email_entry.get()
        password = password_entry.get()

        # Query the admin table to check if the entered credentials are valid
        query = "SELECT * FROM admin WHERE emailID = %s AND passwd = %s"
        values = (email, password)
        cursor.execute(query, values)
        admin_data = cursor.fetchone()

        # If a record is found, proceed with the admin interface
        if admin_data:
            admin_login_frame.pack_forget()
            execute_admin_query()
            execute_button.pack()  # Show the "Execute" button after successful login
        else:
            tk.messagebox.showerror("Login Failed", "Invalid email ID or password.")

    # Login frame containing email ID and password entry fields
    admin_login_frame = tk.Frame(admin_window)
    tk.Label(admin_login_frame, text="Email ID:").pack()
    email_entry = tk.Entry(admin_login_frame)
    email_entry.pack()
    tk.Label(admin_login_frame, text="Password:").pack()
    password_entry = tk.Entry(admin_login_frame, show="*")
    password_entry.pack()
    tk.Button(admin_login_frame, text="Login", command=validate_admin_login).pack()
    admin_login_frame.pack()

    offer_frame=tk.Frame(admin_window)
    tk.Label(offer_frame, text="OfferID").pack()
    offer_entry = tk.Entry(offer_frame)
    offer_entry.pack()
    tk.Label(offer_frame, text="userID").pack()
    user_entry = tk.Entry(offer_frame)
    user_entry.pack()
    tk.Label(offer_frame, text="Discount").pack()
    discount_entry = tk.Entry(offer_frame)
    discount_entry.pack()
    tk.Label(offer_frame, text="last_login_date").pack()
    last_log_entry = tk.Entry(offer_frame)
    last_log_entry.pack()

    def update_interface():
        query_index = admin_query_var.get()
        if query_index == 1:
            offer_frame.pack_forget()
        elif query_index == 2:
            offer_frame.pack_forget()
        elif query_index == 3:
            offer_frame.pack()

    # Function to execute admin queries after successful login
    def execute_admin_query():
        query_index = admin_query_var.get()
        if query_index == 1:
            query = "SELECT COUNT(distinct orderID) FROM orders"
            results = execute_query(query)
            result_text.config(state=tk.NORMAL)
            result_text.delete("1.0", tk.END)
            for row in results:
                result_text.insert(tk.END, str(row) + "\n")
            result_text.config(state=tk.DISABLED)
        elif query_index == 2:
            query = "SELECT * FROM product"
            results = execute_query(query)
            result_text.config(state=tk.NORMAL)
            result_text.delete("1.0", tk.END)
            for row in results:
                result_text.insert(tk.END, str(row) + "\n")
            result_text.config(state=tk.DISABLED)
        elif query_index==3:
            offerID=offer_entry.get()
            userID=user_entry.get()
            discount=discount_entry.get()
            last_login_date=last_log_entry.get()
            query="insert into offers(offerID, userID, discount, last_login_date,today_date) value(%s,%s,%s,%s,%s)"
            values=(offerID, userID, discount, last_login_date,date.today())
            cursor.execute(query,values)
            connection.commit()
            query2="select * from offers"
            results = execute_query(query2)
            result_text.config(state=tk.NORMAL)
            result_text.delete("1.0", tk.END)
            for row in results:
                result_text.insert(tk.END, str(row) + "\n")
            result_text.config(state=tk.DISABLED)
        else:
            return

        

    admin_query_var = tk.IntVar()
    tk.Label(admin_window, text="Select Query:").pack()
    ttk.Radiobutton(admin_window, text="Print number of orders.", variable=admin_query_var, value=1,command=update_interface).pack(anchor=tk.W)
    ttk.Radiobutton(admin_window, text="List all Products", variable=admin_query_var, value=2,command=update_interface).pack(anchor=tk.W)
    ttk.Radiobutton(admin_window, text="Add Offers", variable=admin_query_var, value=3,command=update_interface).pack(anchor=tk.W)

    global result_text
    result_text = tk.Text(admin_window, height=10, width=50, state=tk.DISABLED)
    result_text.pack()

    # Create the "Execute" button but don't pack it yet
    global execute_button
    execute_button = ttk.Button(admin_window, text="Execute", command=execute_admin_query)

userID=None
def customer_interface():
    global userID
    def show_signup_interface():
        login_frame.pack_forget()
        signup_frame.pack()
        signup_execute_button.pack()
        # item_add_frame.pack()

    def show_login_interface():
        signup_frame.pack_forget()
        login_frame.pack()
        log_execute_button.pack()
        execute_button.pack_forget()  # Hide execute button when showing login interface
        email_label.pack()
        email_entry.pack()
        password_label.pack()
        password_entry.pack()
        # item_add_frame.pack()
    
    # def show_item_add_interface():


    def customer_signup():
        # Retrieve user input from entry fields
        f_name = f_name_entry.get()
        m_name = m_name_entry.get()
        l_name = l_name_entry.get()
        city = city_entry.get()
        state = state_entry.get()
        zip_code = zip_entry.get()
        country = country_entry.get()
        age = age_entry.get()
        phonenum = phonenum_entry.get()
        email = email_entry_signup.get()
        passwd = password_entry_signup.get()

        # Check if user already exists
        query = "SELECT * FROM user WHERE email = %s or passwd=%s"
        values = (email,passwd)
        cursor.execute(query, values)
        existing_user = cursor.fetchone()
        
        if existing_user:
            mb.showerror("Error", "User with this email already exists.")
        else:
            # Insert user data into the database
            query = "INSERT INTO user (first_name, middle_name, last_name, city, state, zip, country, age, phonenum, email, passwd) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            values = (f_name, m_name, l_name, city, state, zip_code, country, age, phonenum, email, passwd)
            cursor.execute(query, values)
            connection.commit()
            mb.showinfo("Signup Successful", "You have successfully signed up!")
            show_login_interface()  # Switch to the login interface after signup

    def customer_login():
        global userID
        email = email_entry.get()
        password = password_entry.get()

        # Query the user table to check if the entered credentials are valid
        query = "SELECT * FROM user WHERE email = %s AND passwd = %s"
        values = (email, password)
        cursor.execute(query, values)
        user_data = cursor.fetchone()
        

        if user_data:
            mb.showinfo("Login Successful", "You have successfully logged in!")
            execute_button.pack()  # Show execute button after successful login
            userID=(user_data[0])
            # print(userID)
            execute_customer_query()
        else:
            mb.showerror("Login Failed", "Invalid email or password.")
        
    def update_interface():
        query_index = admin_query_var.get()
        if query_index == 1:
            item_add_frame.pack_forget()
            item_remove_frame.pack_forget()
        elif query_index == 2:
            item_add_frame.pack()
            item_remove_frame.pack_forget()
            email_entry.pack_forget()
            password_entry.pack_forget()
        elif query_index == 3:
            item_remove_frame.pack()
            item_add_frame.pack_forget()
        elif query_index == 4:
            item_remove_frame.pack_forget()
            item_add_frame.pack_forget()

    def execute_customer_query():
        query_index = admin_query_var.get()
        if query_index == 1:
            item_add_frame.pack_forget()
            query = "SELECT * FROM product"
            results = execute_query(query)
            result_text.config(state=tk.NORMAL)
            result_text.delete("1.0", tk.END)
            for row in results:
                result_text.insert(tk.END, str(row)+ "\n")
            result_text.config(state=tk.DISABLED)
        elif query_index == 2:
            # item_add_frame.pack()
            email_entry.pack_forget()
            password_entry.pack_forget()
            cartID=cart_entry.get()
            productID=productID_entry.get()
            cart_size=size_entry.get()
            
            query = "insert into cart(cartID, productID, cart_size, userID) values(%s,%s,%s,%s)"
            values=(cartID,productID,cart_size,userID)
            query2 = "select * from cart"
            
            cursor.execute(query,values)
            connection.commit()
            results = execute_query(query2)
            result_text.config(state=tk.NORMAL)
            result_text.delete("1.0", tk.END)
            for row in results:
                result_text.insert(tk.END, str(row) + "\n")
            result_text.config(state=tk.DISABLED)
        elif query_index == 3:
            # item_remove_frame.pack()
            cartID=cart_rem.get()
            productID=product_rem.get()

            query = "delete from cart where cartID=%s and productID=%s and userID=%s"
            values=(cartID,productID,userID)
            cursor.execute(query,values)
            connection.commit()
            query2="select * from cart"
            results = execute_query(query2)
            result_text.config(state=tk.NORMAL)
            result_text.delete("1.0", tk.END)
            for row in results:
                result_text.insert(tk.END, str(row) + "\n")
            result_text.config(state=tk.DISABLED)
        elif query_index == 4:
            query = "select * from cart where userID=%s" 
            values=(userID,)
            results = execute_query(query,values)
            result_text.config(state=tk.NORMAL)
            result_text.delete("1.0", tk.END)
            for row in results:
                result_text.insert(tk.END, str(row) + "\n")
            result_text.config(state=tk.DISABLED) 
        else:
            return

        

    customer_window = tk.Toplevel()
    customer_window.title("Customer Interface")

    login_frame = tk.Frame(customer_window)
    signup_button = tk.Button(login_frame, text="Sign Up", command=show_signup_interface)
    signup_button.pack()
    login_button = tk.Button(login_frame, text="Login", command=show_login_interface)
    login_button.pack()
    log_execute_button=tk.Button(login_frame, text="Execute_LogIn", command=customer_login)
    log_execute_button.pack_forget()
    
    signup_frame = tk.Frame(customer_window)
    signup_execute_button=tk.Button(signup_frame, text="Execute_SignUp", command=customer_signup)
    signup_execute_button.pack_forget()

    item_remove_frame=tk.Frame(customer_window)

    tk.Label(item_remove_frame,text="CartID").pack()
    cart_rem=tk.Entry(item_remove_frame)
    cart_rem.pack()
    tk.Label(item_remove_frame,text="ProductID").pack()
    product_rem=tk.Entry(item_remove_frame)
    product_rem.pack()
    item_add_frame=tk.Frame(customer_window)

    tk.Label(item_add_frame, text="CartID").pack()
    cart_entry = tk.Entry(item_add_frame)
    cart_entry.pack()
    tk.Label(item_add_frame, text="productID").pack()
    productID_entry = tk.Entry(item_add_frame)
    productID_entry.pack()
    tk.Label(item_add_frame, text="Cart_size").pack()
    size_entry = tk.Entry(item_add_frame)
    size_entry.pack()   
    # tk.Label(item_add_frame, text="UserID").pack()
    # userID_entry = tk.Entry(item_add_frame)
    # userID_entry.pack()

    tk.Label(signup_frame, text="First Name:").pack()
    f_name_entry = tk.Entry(signup_frame)
    f_name_entry.pack()
    tk.Label(signup_frame, text="Middle Name:").pack()
    m_name_entry = tk.Entry(signup_frame)
    m_name_entry.pack()
    tk.Label(signup_frame, text="Last Name:").pack()
    l_name_entry = tk.Entry(signup_frame)
    l_name_entry.pack()
    tk.Label(signup_frame, text="City:").pack()
    city_entry = tk.Entry(signup_frame)
    city_entry.pack()
    tk.Label(signup_frame, text="State:").pack()
    state_entry = tk.Entry(signup_frame)
    state_entry.pack()
    tk.Label(signup_frame, text="Zip Code:").pack()
    zip_entry = tk.Entry(signup_frame)
    zip_entry.pack()
    tk.Label(signup_frame, text="Country:").pack()
    country_entry = tk.Entry(signup_frame)
    country_entry.pack()
    tk.Label(signup_frame, text="Age:").pack()
    age_entry = tk.Entry(signup_frame)
    age_entry.pack()
    tk.Label(signup_frame, text="Phone Number:").pack()
    phonenum_entry = tk.Entry(signup_frame)
    phonenum_entry.pack()
    tk.Label(signup_frame, text="Email ID:").pack()
    email_entry_signup = tk.Entry(signup_frame)
    email_entry_signup.pack()
    tk.Label(signup_frame, text="Password:").pack()
    password_entry_signup = tk.Entry(signup_frame)
    password_entry_signup.pack()
    signup_button = tk.Button(signup_frame, text="Sign Up", command=customer_signup)

    login_frame.pack()  # Show login interface by default

    # Entry fields for email and password
    email_label = tk.Label(customer_window, text="Email ID:")
    email_entry = tk.Entry(customer_window)
    password_label = tk.Label(customer_window, text="Password:")
    password_entry = tk.Entry(customer_window, show="*")

    # Frame to display admin queries and results
    admin_queries_frame = tk.Frame(customer_window)
    admin_query_var = tk.IntVar()
    tk.Label(admin_queries_frame, text="Select Query:").pack()
    ttk.Radiobutton(admin_queries_frame, text="List All Products", variable=admin_query_var, value=1,command=update_interface).pack(anchor=tk.W)
    ttk.Radiobutton(admin_queries_frame, text="Add item to Cart", variable=admin_query_var, value=2,command=update_interface).pack(anchor=tk.W)
    ttk.Radiobutton(admin_queries_frame, text="Remove item from Cart", variable=admin_query_var, value=3,command=update_interface).pack(anchor=tk.W)
    ttk.Radiobutton(admin_queries_frame, text="View Cart", variable=admin_query_var, value=4,command=update_interface).pack(anchor=tk.W)
    admin_queries_frame.pack()

    # Frame to display query results
    result_text = tk.Text(customer_window, height=10, width=50, state=tk.DISABLED)
    result_text.pack()

    # Button to execute selected query
    execute_button = ttk.Button(customer_window, text="Execute", command=execute_customer_query)


def display_results(results):
        result_text.config(state=tk.NORMAL)
        result_text.delete("1.0", tk.END)
        result_text.insert(tk.END, "Operation executed successfully.\n")
        for row in results:
            result_text.insert(tk.END, str(row) + "\n")
        result_text.config(state=tk.DISABLED)

def embedded_sql_interface():
    embedded_sql_window = tk.Toplevel()
    embedded_sql_window.title("Embedded SQL Interface")

    def execute_embedded_sql_query():
        query_index = embedded_sql_query_var.get()
        if query_index == 1: #customer analysis
            query = "Select payment_ID,user.userID,first_name from user,payment where payment.userID=user.userID order by payment.amount DESC LIMIT 3"
        elif query_index == 2: #inventory analysis
            execute_query("INSERT INTO cart (cartID, productID, cart_size, userID) VALUES (4, 2, 3, 4)")
            execute_query("UPDATE cart SET cart_size = 3 WHERE cartID = 4")
            query = "SELECT * FROM cart"
        elif query_index == 3: 
            query = "select delivery_agent.agentID,delivery_agent.first_name from delivery_agent,agent_feedback where delivery_agent.agentID=agent_feedback.agentID and delivery_agent.orderID=agent_feedback.orderID order by rating DESC LIMIT 3"
        elif query_index==4: #customer analysis
            query="select first_name,orderID from order_feedback,user where order_feedback.userID=user.userID and feedback_text like 'Fast%'"
        elif query_index == 5: # order product
            orderID = int(orderID_entry.get())
            productID = int(productID_entry.get())
            quantity = int(cart_size_entry.get())
            userID = int(userID_entry.get())

            query = "INSERT INTO orders (orderID, userID, productID, quantity, order_date) VALUES (%s, %s, %s, %s, NOW())"
            values = (orderID, userID, productID, quantity)
            cursor.execute(query, values)
            connection.commit()
            print("Order placed successfully.")

            query = "SELECT * FROM orders"
            cursor.execute(query)
            updated_data = cursor.fetchall()
            display_results(updated_data)
            return  # Stop further execution if "Order Product" is selected
        else:
            return

        results = execute_query(query)
        result_text.config(state=tk.NORMAL)
        result_text.delete("1.0", tk.END)
        for row in results:
            result_text.insert(tk.END, str(row) + "\n")
        result_text.config(state=tk.DISABLED)

    embedded_sql_query_var = tk.IntVar()
    tk.Label(embedded_sql_window, text="Select Query:").pack()
    ttk.Radiobutton(embedded_sql_window, text="List Top 3 Paying Customers", variable=embedded_sql_query_var, value=1).pack(anchor=tk.W)
    ttk.Radiobutton(embedded_sql_window, text="Add Product to Cart", variable=embedded_sql_query_var, value=2).pack(anchor=tk.W)
    ttk.Radiobutton(embedded_sql_window, text="List Top 3 Delivery Partners", variable=embedded_sql_query_var, value=3).pack(anchor=tk.W)
    ttk.Radiobutton(embedded_sql_window, text="Listing all users with their orderID who gave feedback having word Fast in it", variable=embedded_sql_query_var, value=4).pack(anchor=tk.W)
    ttk.Radiobutton(embedded_sql_window, text="Order Product", variable=embedded_sql_query_var, value=5).pack(anchor=tk.W)

    global orderID_entry, productID_entry, cart_size_entry, userID_entry

    execute_button = ttk.Button(embedded_sql_window, text="Execute", command=execute_embedded_sql_query)
    execute_button.pack()

    global result_text
    result_text = tk.Text(embedded_sql_window, height=10, width=50, state=tk.DISABLED)
    result_text.pack()

    # Entry fields and labels for orderID, productID, cart_size, and userID
    orderID_label = tk.Label(embedded_sql_window, text="Order ID:")
    orderID_entry = tk.Entry(embedded_sql_window)
    productID_label = tk.Label(embedded_sql_window, text="Product ID:")
    productID_entry = tk.Entry(embedded_sql_window)
    cart_size_label = tk.Label(embedded_sql_window, text="Quantity:")
    cart_size_entry = tk.Entry(embedded_sql_window)
    userID_label = tk.Label(embedded_sql_window, text="User ID:")
    userID_entry = tk.Entry(embedded_sql_window)

    def hide_order_product_entries():
        orderID_label.pack_forget()
        orderID_entry.pack_forget()
        productID_label.pack_forget()
        productID_entry.pack_forget()
        cart_size_label.pack_forget()
        cart_size_entry.pack_forget()
        userID_label.pack_forget()
        userID_entry.pack_forget()

    def show_order_product_entries():
        orderID_label.pack()
        orderID_entry.pack()
        productID_label.pack()
        productID_entry.pack()
        cart_size_label.pack()
        cart_size_entry.pack()
        userID_label.pack()
        userID_entry.pack()

    def update_entries():
        query_index = embedded_sql_query_var.get()
        if query_index == 5:  # Order Product
            show_order_product_entries()
        else:
            hide_order_product_entries()

    embedded_sql_query_var.trace("w", lambda *args: update_entries())

    hide_order_product_entries()  # Initially hide order product entries

def triggers_interface():
    def update_entries():
      orderID_label.pack_forget()
      orderID_entry.pack_forget()
      userID_label.pack_forget()
      userID_entry.pack_forget()
      feedback_text_label.pack_forget()
      feedback_text_entry.pack_forget()
      rating_label.pack_forget()
      rating_entry.pack_forget()
      amount_label.pack_forget()
      amount_entry.pack_forget()
      supplierID_label.pack_forget()
      supplierID_entry.pack_forget()
      product_name_label.pack_forget()
      product_name_entry.pack_forget()
      quantity_remaining_label.pack_forget()
      quantity_remaining_entry.pack_forget()
      product_price_label.pack_forget()
      product_price_entry.pack_forget()

      query_index = triggers_query_var.get()

      if query_index == 1:
          orderID_label.pack()
          orderID_entry.pack()
          userID_label.pack()
          userID_entry.pack()
          feedback_text_label.pack()
          feedback_text_entry.pack()
          rating_label.pack()
          rating_entry.pack()
      elif query_index == 2:
          orderID_label.pack()
          orderID_entry.pack()
          userID_label.pack()
          userID_entry.pack()
          amount_label.pack()
          amount_entry.pack()
      elif query_index == 3:
          supplierID_label.pack()
          supplierID_entry.pack()
          product_name_label.pack()
          product_name_entry.pack()
          quantity_remaining_label.pack()
          quantity_remaining_entry.pack()
          product_price_label.pack()
          product_price_entry.pack()


    def execute_trigger_query():
      query_index = triggers_query_var.get()
      if query_index == 1:
          orderID = int(orderID_entry.get())
          userID = int(userID_entry.get())
          feedback_text = feedback_text_entry.get()
          rating = int(rating_entry.get())

          query = "INSERT INTO order_feedback (userID, orderID, feedback_text, rating) VALUES (%s, %s, %s, %s)"
          values = (userID, orderID, feedback_text, rating)
          cursor.execute(query, values)
          connection.commit()
          print("Feedback and rating updated successfully.")

          query = "SELECT * FROM order_feedback"
          cursor.execute(query)
          updated_data = cursor.fetchall()

      elif query_index == 2:
          orderID = int(orderID_entry.get())
          userID = int(userID_entry.get())
          amount = int(amount_entry.get())

          query = "INSERT INTO payment (userID, orderID, amount) VALUES (%s, %s, %s)"
          values = (userID, orderID, amount)
          cursor.execute(query, values)
          connection.commit()
          print("Amount updated successfully.")

          query = "SELECT * FROM payment"
          cursor.execute(query)
          updated_data = cursor.fetchall()

      elif query_index == 3:
          supplierID = int(supplierID_entry.get())
          product_name = product_name_entry.get()
          quantity_remaining = int(quantity_remaining_entry.get())
          product_price = int(product_price_entry.get())

          query = "INSERT INTO product (supplierID, product_price, product_name, quantity_remaining) VALUES (%s, %s, %s, %s)"
          values = (supplierID, product_price, product_name, quantity_remaining)
          cursor.execute(query, values)
          connection.commit()
          print("Product price updated successfully.")

          query = "SELECT * FROM product"
          cursor.execute(query)
          updated_data = cursor.fetchall()
      result_text.config(state=tk.NORMAL)
      result_text.delete("1.0", tk.END)
      result_text.insert(tk.END, "Operation executed successfully.\n")
      for row in updated_data:
          result_text.insert(tk.END, str(row) + "\n")
      result_text.config(state=tk.DISABLED)

      clear_entries()

    def clear_entries():
        orderID_entry.delete(0, tk.END)
        userID_entry.delete(0, tk.END)
        feedback_text_entry.delete(0, tk.END)
        rating_entry.delete(0, tk.END)
        amount_entry.delete(0, tk.END)
        supplierID_entry.delete(0, tk.END)
        product_name_entry.delete(0, tk.END)
        quantity_remaining_entry.delete(0, tk.END)
        product_price_entry.delete(0, tk.END)

    triggers_window = tk.Toplevel()
    triggers_window.title("Triggers Interface")

    triggers_query_var = tk.IntVar()
    tk.Label(triggers_window, text="Select Trigger:").pack()
    ttk.Radiobutton(triggers_window, text="Trigger Feedback and Rating to Rating is invalid! and NULL if rating is <1 or >5.", variable=triggers_query_var, value=1, command=update_entries).pack(anchor=tk.W)
    ttk.Radiobutton(triggers_window, text="Trigger Amount to 5 if less than 5.", variable=triggers_query_var, value=2, command=update_entries).pack(anchor=tk.W)
    ttk.Radiobutton(triggers_window, text="Trigger Product Price to 5 if less than 5.", variable=triggers_query_var, value=3, command=update_entries).pack(anchor=tk.W)

    orderID_label = tk.Label(triggers_window, text="Order ID:")
    orderID_entry = tk.Entry(triggers_window)
    userID_label = tk.Label(triggers_window, text="User ID:")
    userID_entry = tk.Entry(triggers_window)
    feedback_text_label = tk.Label(triggers_window, text="Feedback Text:")
    feedback_text_entry = tk.Entry(triggers_window)
    rating_label = tk.Label(triggers_window, text="Rating:")
    rating_entry = tk.Entry(triggers_window)
    amount_label = tk.Label(triggers_window, text="Amount:")
    amount_entry = tk.Entry(triggers_window)
    supplierID_label = tk.Label(triggers_window, text="Supplier ID:")
    supplierID_entry = tk.Entry(triggers_window)
    product_name_label = tk.Label(triggers_window, text="Product Name:")
    product_name_entry = tk.Entry(triggers_window)
    quantity_remaining_label = tk.Label(triggers_window, text="Quantity Remaining:")
    quantity_remaining_entry = tk.Entry(triggers_window)
    product_price_label = tk.Label(triggers_window, text="Product Price:")
    product_price_entry = tk.Entry(triggers_window)
    execute_button = ttk.Button(triggers_window, text="Execute", command=execute_trigger_query)
    execute_button.pack()

    global result_text
    result_text = tk.Text(triggers_window, height=10, width=50, state=tk.DISABLED)
    result_text.pack()

    update_entries()

def main_interface():
    root = tk.Tk()
    root.title("Cartbharo")

    def open_admin_interface():
        admin_interface()
    
    def open_customer_interface():
        customer_interface()

    def open_embedded_sql_interface():
        embedded_sql_interface()

    def open_triggers_interface():
        triggers_interface()

    admin_button = ttk.Button(root, text="Admin", command=open_admin_interface)
    admin_button.pack()

    customer_button = ttk.Button(root, text="Customer", command=open_customer_interface)
    customer_button.pack()

    embedded_sql_button = ttk.Button(root, text="Embedded SQL", command=open_embedded_sql_interface)
    embedded_sql_button.pack()

    triggers_button = ttk.Button(root, text="Triggers", command=open_triggers_interface)
    triggers_button.pack()

    exit_button = ttk.Button(root, text="Exit", command=root.quit)
    exit_button.pack()

    root.mainloop()

def transaction1():
    try:
        cursor.execute("START TRANSACTION")
        cursor.execute("UPDATE product SET product_price = product_price - 100 WHERE productID = 2")
        # connection.commit()
    except mysql.connector.errors.DatabaseError as e:
        print("Error in transaction 1:", e)

def transaction2():
    try:
        cursor.execute("START TRANSACTION")
        cursor.execute("UPDATE product SET product_price = product_price + 200 WHERE productID = 2")
        # connection.commit()
    except mysql.connector.errors.DatabaseError as e:
        print("Error in transaction 2:", e)

def conflict_transactions_1():
    thread1 = threading.Thread(target=transaction1)
    thread2 = threading.Thread(target=transaction2)
    thread1.start()
    thread2.start()
    thread1.join()  # Wait for thread1 to finish
    thread2.join()  # Wait for thread2 to finish

    # Display the updated data after both transactions are completed
    query = "SELECT * FROM product"
    results = execute_query(query)
    # result_text.config(state=tk.NORMAL)
    # result_text.delete("1.0", tk.END)
    for row in results:
        print(str(row)+"\n")
    # result_text.config(state=tk.DISABLED)

def transaction3():
    try:
        cursor.execute("START TRANSACTION")
        cursor.execute("UPDATE offers set discount=discount+2 where offerID=2")
        # connection.commit()
    except mysql.connector.errors.DatabaseError as e:
        print("Error in transaction 3:", e)

def transaction4():
    try:
        cursor.execute("START TRANSACTION")
        cursor.execute("UPDATE offers set discount=discount-1 where offerID=2")
        # connection.commit()
    except mysql.connector.errors.DatabaseError as e:
        print("Error in transaction 4:", e)

def conflict_transactions_2():
    thread1 = threading.Thread(target=transaction3)
    thread2 = threading.Thread(target=transaction4)
    thread1.start()
    thread2.start()
    thread1.join()  # Wait for thread1 to finish
    thread2.join()  # Wait for thread2 to finish

    # Display the updated data after both transactions are completed
    query = "SELECT * FROM offers"
    results = execute_query(query)
    # result_text.config(state=tk.NORMAL)
    # result_text.delete("1.0", tk.END)
    for row in results:
        print(str(row)+"\n")

def transaction6():
    try:
        cursor.execute("START TRANSACTION")
        cursor.execute("UPDATE payment SET amount = amount - 100 WHERE payment_id = 1;")
        connection.commit()
    except mysql.connector.errors.DatabaseError as e:
        print("Error in transaction 6:", e)

def non_conflict_transactions_1():
    thread2 = threading.Thread(target=transaction6)
    thread2.start()
    thread2.join()

    # Display the updated data after both transactions are completed
    query = "SELECT * FROM payment"
    results = execute_query(query)
    # result_text.config(state=tk.NORMAL)
    # result_text.delete("1.0", tk.END)
    for row in results:
        print(str(row)+"\n")


def transaction8():
    try:
        cursor.execute("START TRANSACTION")
        cursor.execute("UPDATE payment SET amount = amount + 200 WHERE payment_id = 2")
        connection.commit()
    except mysql.connector.errors.DatabaseError as e:
        print("Error in transaction 8:", e)

def non_conflict_transactions_2():
    thread2 = threading.Thread(target=transaction8)
    thread2.start()
    thread2.join() 
    query = "SELECT * FROM payment"
    results = execute_query(query)
    for row in results:
        print(str(row)+"\n")

def transaction9():
    try:
        cursor.execute("START TRANSACTION")
        # cursor.execute("savepoint before trans_save")
        cursor.execute("update order_feedback set feedback_text='Changednow' where userID=1")
        # cursor.execute("rollback")
        connection.commit()
    except mysql.connector.errors.DatabaseError as e:
        print("Error in transaction 9:", e)


def non_conflict_transactions_3():
    thread1 = threading.Thread(target=transaction9)
    thread1.start()
    thread1.join() 

    query = "SELECT * FROM order_feedback"
    results = execute_query(query)
    for row in results:
        print(str(row)+"\n")

def transaction11():
    try:
        cursor.execute("START TRANSACTION")
        cursor.execute("UPDATE vendor set first_name='ChangedToGarvit' where vendorID=1")
        connection.commit()
    except mysql.connector.errors.DatabaseError as e:
        print("Error in transaction 11:", e)

def non_conflict_transactions_4():
    thread1 = threading.Thread(target=transaction11)
    thread1.start()
    thread1.join() 

    query = "SELECT * FROM vendor"
    results = execute_query(query)
    for row in results:
        print(str(row)+"\n")

if __name__ == "__main__":
    # conflict_transactions_1()
    # conflict_transactions_2()
    non_conflict_transactions_1()
    non_conflict_transactions_2()
    non_conflict_transactions_3()
    non_conflict_transactions_4()
    main_interface()
