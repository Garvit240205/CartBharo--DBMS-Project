# CartBharo--DBMS-Project

## Overview

CartBharo is a comprehensive e-commerce database system designed to manage various aspects of an online shopping platform. It includes tables and relationships for managing users, products, suppliers, vendors, stores, orders, payments, delivery agents, and feedback. This database schema ensures efficient storage, retrieval, and manipulation of data related to e-commerce operations.

## Database Schema

### Tables and Relationships

1. **phone_number**:
   - Stores phone numbers for users, suppliers, vendors, stores, and delivery agents.

2. **email**:
   - Stores email addresses for users, suppliers, vendors, stores, and delivery agents.

3. **admin**:
   - Stores information about administrators.

4. **supplier**:
   - Stores information about suppliers including their phone numbers and email addresses.

5. **vendor**:
   - Stores information about vendors linked to suppliers, including their phone numbers and email addresses.

6. **store**:
   - Stores information about physical stores including their location, vendors, suppliers, phone numbers, and email addresses.

7. **product**:
   - Stores information about products including their price, quantity, and associated suppliers.

8. **user**:
   - Stores information about users including their personal details, contact information, and credentials.

9. **cart**:
   - Stores information about user carts, linking users to products they are interested in purchasing.

10. **orders**:
    - Stores information about orders placed by users including the order date, products ordered, and quantities.

11. **payment**:
    - Stores information about payments made by users for their orders.

12. **delivery_agent**:
    - Stores information about delivery agents responsible for delivering orders including their phone numbers and email addresses.

13. **offers**:
    - Stores information about offers available to users, including discounts and last login dates.

14. **order_feedback**:
    - Stores feedback provided by users about their orders, including ratings and comments.

15. **agent_feedback**:
    - Stores feedback provided by users about delivery agents, including ratings and comments.

## How to Setup

### Prerequisites

1. **MySQL Server**: Ensure you have MySQL Server installed. You can download it from the official [MySQL website](https://dev.mysql.com/downloads/mysql/).

2. **MySQL Connector**: Install the MySQL Connector for Python to connect your Python application to the MySQL database.

   ```bash
   pip install mysql-connector-python
   ```

### Database Setup

1. **Create Database and Tables**:
   - Use the provided SQL script to create the `CARTBHARO` database and all the required tables. Execute the script using a MySQL client like MySQL Workbench or the command line.

   ```sql
   DROP DATABASE IF EXISTS CARTBHARO;

   CREATE DATABASE IF NOT EXISTS CARTBHARO;
   USE CARTBHARO;

   -- (Include the entire SQL script provided in the previous message)
   ```

2. **Insert Initial Data**:
   - The SQL script also includes `INSERT` statements to populate the tables with initial data.

### Connecting to the Database

- Use the `mysql.connector` library in your Python application to connect to the MySQL database.

   ```python
   import mysql.connector

   db = mysql.connector.connect(
       host="localhost",
       user="yourusername",
       password="yourpassword",
       database="CARTBHARO"
   )

   cursor = db.cursor()
   ```

## Summary of Operations

- **User Management**: Add, update, and retrieve user information.
- **Product Management**: Manage product details, prices, and quantities.
- **Order Processing**: Handle orders placed by users, including payment and delivery.
- **Feedback System**: Collect and manage feedback from users about orders and delivery agents.
- **Offers and Discounts**: Manage and apply offers and discounts for users.
- **Supplier and Vendor Management**: Manage relationships and details of suppliers and vendors.
- **Store Management**: Maintain details of physical stores and their associations with vendors and suppliers.

This project aims to provide a robust backend system for managing an e-commerce platform, ensuring efficient and organized data handling.
