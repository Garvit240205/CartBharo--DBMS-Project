# CartBharo - Full-Stack E-commerce Web Application

![Python](https://img.shields.io/badge/Python-3.9+-blue?logo=python)
![Flask](https://img.shields.io/badge/Flask-2.x-black?logo=flask)
![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?logo=mysql)
![HTML5](https://img.shields.io/badge/HTML-5-red?logo=html5)
![CSS3](https://img.shields.io/badge/CSS-3-blue?logo=css3)

A comprehensive e-commerce web application built from the ground up to demonstrate core software engineering principles, with a strong focus on backend development and robust database design.

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Technical Showcase](#technical-showcase)
- [Database Schema](#database-schema)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)

## Project Overview

CartBharo is a full-stack web application that simulates a modern online shopping platform. It features distinct user roles (Admin and Customer), each with a dedicated interface and functionalities. The project's primary goal was to design and implement a normalized, relational database and build a secure and efficient backend to interact with it.

The backend is powered by Python and the Flask micro-framework, while the database is managed with MySQL. The frontend is rendered using server-side templates with HTML, CSS, and Bootstrap for a clean and responsive user experience.

## Features

- **Dual Role System:**
  - **Admin Portal:** Secure login for administrators to manage the platform. Admins can view analytics like total orders, list all products, and add promotional offers.
  - **Customer Portal:** Customers can sign up, log in, browse products, add items to their shopping cart, and place orders.

- **Complete E-commerce Flow:**
  - User registration and authentication.
  - Product catalog display.
  - Shopping cart functionality (add, remove, view).
  - A multi-step checkout process that creates orders, generates payments, and updates inventory.

- **Data-Driven Analytics:**
  - An "Analytics" page demonstrating complex, pre-written SQL queries to derive business insights, such as identifying top-paying customers and top-rated delivery agents.

- **Database Integrity:**
  - A "Triggers" page showcasing how database triggers automatically enforce business rules (e.g., minimum product price, valid user ratings) before data is even written to the tables.

## Technical Showcase

- **Database Design:** The MySQL database was designed from scratch, focusing on normalization (up to 3NF) to ensure data integrity and reduce redundancy. The schema includes over 10 tables with primary keys, foreign keys, and complex relationships.
- **Backend Development:** A RESTful-style backend was created with Flask to handle all business logic, including routing, request handling, session management, and user authentication.
- **SQL Proficiency:** Instead of relying solely on an ORM, raw SQL queries were written using the `mysql-connector-python` library.
- **Data Integrity and Business Rules:** Implemented database triggers to enforce rules at the database level, providing a robust layer of data validation.
- **Full-Stack Integration:** Seamlessly connected the Python backend to a dynamic HTML/CSS frontend, creating a complete and functional user experience.

![Screenshot 2025-06-22 160710](https://github.com/user-attachments/assets/66191bc8-4ad6-4b3c-85ef-80cab62c4fef)
![Screenshot 2025-06-22 160727](https://github.com/user-attachments/assets/923212fd-259c-455a-a6fe-da7902c69a73)
![Screenshot 2025-06-22 160740](https://github.com/user-attachments/assets/c55340f3-5576-48b9-b4c9-c7cf6bee64d0)
![Screenshot 2025-06-22 160800](https://github.com/user-attachments/assets/163eeacb-01f0-4dd7-b86e-8149479fa15a)
![Screenshot 2025-06-22 160813](https://github.com/user-attachments/assets/1af6c321-bff1-4257-bb85-81c676d04330)
![Screenshot 2025-06-22 160831](https://github.com/user-attachments/assets/3c94db73-0ee4-439b-8800-14c8fcd5ca70)
![Screenshot 2025-06-22 160843](https://github.com/user-attachments/assets/819e16c4-6764-4482-b5d8-4c3b482ec99c)
![Screenshot 2025-06-22 160906](https://github.com/user-attachments/assets/1f8c7be9-c924-4022-8803-638651b82443)
![Screenshot 2025-06-22 161144](https://github.com/user-attachments/assets/9cf77b08-8000-4036-9084-47a140107a51)

## Database Schema

The database is the heart of this project.

- **Core Entities:** `user`, `admin`, `product`, `supplier`.
- **Transactional Entities:** `cart`, `orders`, `payment`.
- **Feedback & Support:** `order_feedback`, `agent_feedback`, `delivery_agent`.
- **Normalized Data:** `email` and `phone_number` tables to prevent data duplication.

## Setup and Installation

To run this project locally, please follow these steps:

1.  **Prerequisites:**
    - Python 3.9+
    - MySQL Server 8.0+
    - Git

2.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Garvit240205/CartBharo--DBMS-Project.git
    cd CartBharo--DBMS-Project
    ```

3.  **Install Python Dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Setup the Database:**
    - Log in to your MySQL server as the `root` user.
    - Open the `db_setup.sql` file and ensure the credentials match your setup if needed.
    - Run the entire script to create the `CARTBHARO` database, all tables, and insert sample data.
    ```sql
    -- Inside the MySQL client
    SOURCE path/to/your/db_setup.sql;

5.  **Configure the Application:**
    - Open `app.py` and update the MySQL `password` in the `get_db_connection` function to match your root password.

6.  **Run the Flask Application:**
    ```bash
    flask run --port=5001
    ```
    The application will be available at `http://127.0.0.1:5001`.

## Usage

- **Admin Login:**
  - **Email:** `garvit.kochar@example.com`
  - **Password:** `garvit@1234`
- **Customer Login:**
  - You can sign up as a new user or use one of the sample users from `db_setup.sql` (e.g., `alice@example.com` / `password123`).
