### User Guide for Cartbharo Application

#### Introduction
Cartbharo is an application designed to manage an e-commerce platform. It provides interfaces for both administrators and customers to perform various tasks related to product management, user management, and more.

#### Installation
To use Cartbharo, ensure you have Python installed on your system. Additionally, you'll need to install the required dependencies, such as `tkinter`, `mysql.connector`, and `numpy`. You can install these dependencies using `pip`.

```bash
pip install mysql-connector-python numpy
```

#### Running the Application
After installing the dependencies, you can run the application by executing the Python script `cartbharo.py`.

```bash
python cartbharo.py
```

#### Main Interface
Upon launching the application, you'll see the main interface with several options:

- **Admin:** Opens the Admin Interface for administrative tasks.
- **Customer:** Opens the Customer Interface for customer-related actions.
- **Embedded SQL:** Opens the Embedded SQL Interface for executing predefined SQL queries.
- **Triggers:** Opens the Triggers Interface for managing database triggers.
- **Exit:** Closes the application.

#### Admin Interface
The Admin Interface allows administrators to perform various tasks such as:

- Logging in with valid credentials.
- Viewing the number of orders or listing all products.
- Adding offers to products.
- Logging out.

#### Customer Interface
The Customer Interface provides functionality for customers to:

- Sign up for a new account or log in with existing credentials.
- View and interact with their cart, such as adding or removing items.
- Perform various actions like ordering products, viewing available products, etc.

#### Embedded SQL Interface
The Embedded SQL Interface lets users execute predefined SQL queries related to:

- Customer analysis.
- Inventory analysis.
- Listing top delivery partners.
- Ordering products.

#### Triggers Interface
The Triggers Interface allows users to manage database triggers for:

- Updating feedback and rating.
- Modifying payment amounts.
- Adjusting product prices.

#### Conclusion
Cartbharo provides a comprehensive platform for managing e-commerce operations, catering to both administrators and customers. With its intuitive interfaces and powerful functionalities, it simplifies the management of online stores.
