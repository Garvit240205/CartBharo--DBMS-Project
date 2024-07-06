import tkinter as tk
from tkinter import ttk
import mysql.connector

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

    def execute_admin_query():
        query_index = admin_query_var.get()
        if query_index == 1:
            query = "SELECT COUNT(distinct orderID) FROM orders"
        elif query_index == 2:
            query = "SELECT * FROM product"
        
        else:
            return

        results = execute_query(query)
        result_text.config(state=tk.NORMAL)
        result_text.delete("1.0", tk.END)
        for row in results:
            result_text.insert(tk.END, str(row) + "\n")
        result_text.config(state=tk.DISABLED)

    admin_query_var = tk.IntVar()
    tk.Label(admin_window, text="Select Query:").pack()
    ttk.Radiobutton(admin_window, text="Print number of orders.", variable=admin_query_var, value=1).pack(anchor=tk.W)
    ttk.Radiobutton(admin_window, text="List all Products", variable=admin_query_var, value=2).pack(anchor=tk.W)

    execute_button = ttk.Button(admin_window, text="Execute", command=execute_admin_query)
    execute_button.pack()

    global result_text
    result_text = tk.Text(admin_window, height=10, width=50, state=tk.DISABLED)
    result_text.pack()

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

    def open_embedded_sql_interface():
        embedded_sql_interface()

    def open_triggers_interface():
        triggers_interface()

    admin_button = ttk.Button(root, text="Admin", command=open_admin_interface)
    admin_button.pack()

    embedded_sql_button = ttk.Button(root, text="Embedded SQL", command=open_embedded_sql_interface)
    embedded_sql_button.pack()

    triggers_button = ttk.Button(root, text="Triggers", command=open_triggers_interface)
    triggers_button.pack()

    exit_button = ttk.Button(root, text="Exit", command=root.quit)
    exit_button.pack()

    root.mainloop()

if __name__ == "__main__":
    main_interface()
