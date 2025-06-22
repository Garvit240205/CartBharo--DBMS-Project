-- Drop the database if it exists to ensure a fresh start
DROP DATABASE IF EXISTS CARTBHARO;
CREATE DATABASE CARTBHARO;
USE CARTBHARO;

-- Create tables and insert data (based on your provided script)
CREATE TABLE IF NOT EXISTS phone_number (
    phoneID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    num CHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS email (
    emailID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    emailnum VARCHAR(50) NOT NULL
);

INSERT INTO phone_number (num) VALUES
('1112223333'), ('4445556666'), ('7778889999'), ('1231231234'), ('4564564567'), ('7897897890'), ('9876543210'), ('0123456789'), ('3216549870'), ('9998887777'),
('0123222289'), ('3216547013'), ('3261637777'), ('0121224459'), ('9625088161'), ('3261112277'), ('6343124459'), ('2221088161'), ('3256786277'), ('1111111111'),
('2222222222'), ('3333333333'), ('4444444444'), ('5555555555'), ('6666666666'), ('7777777777'), ('8888888888'), ('9999999999');


INSERT INTO email (emailnum) VALUES
('supplier1@example.com'), ('supplier2@example.com'), ('supplier3@example.com'), -- 1-3
('supplier4@example.com'), ('supplier5@example.com'), ('supplier5.2@example.com'), -- 4-6
('supplier6@example.com'), ('supplier6.2@example.com'), ('vendor2@example.com'), -- 7-9
('vendor3@example.com'), ('vendor4@example.com'), ('vendor1.2@example.com'), -- 10-12
('store2@example.com'), ('store4@example.com'), ('store6@example.com'), -- 13-15
('agent1@example.com'), ('agent2@example.com'), ('agent3@example.com'), -- 16-18
('agent4@example.com'), ('agent5@example.com'), ('agent6@example.com'), -- 19-21
('agent7@example.com'), ('user1@example.com'), ('user2@example.com'), -- 22-24
('user3@example.com'), ('garvit.kochar@example.com'), ('user5@example.com'), -- 25-27. Garvit is now 26th.
('user6@example.com'); -- 28

CREATE TABLE IF NOT EXISTS admin (
    adminID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    middle_name VARCHAR(30),
    last_name VARCHAR(30),
    phoneID INT NOT NULL,
    emailID INT NOT NULL,
    passwd VARCHAR(255) NOT NULL,
    FOREIGN KEY (phoneID) REFERENCES phone_number(phoneID),
    FOREIGN KEY (emailID) REFERENCES email(emailID)
);

-- Note: The emailID 26 corresponds to 'garvit.kochar@example.com'
INSERT INTO admin (first_name, last_name, phoneID, emailID, passwd) VALUES
('Garvit', 'Kochar', 26, 26, 'garvit@1234');

CREATE TABLE IF NOT EXISTS supplier (
    supplierID INT NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    middle_name VARCHAR(30),
    last_name VARCHAR(30),
    phoneID INT NOT NULL,
    emailID INT NOT NULL,
    PRIMARY KEY(supplierID,phoneID),
    FOREIGN KEY (phoneID) REFERENCES phone_number(phoneID),
    FOREIGN KEY (emailID) REFERENCES email(emailID)
);

INSERT INTO supplier (supplierID, first_name, last_name, phoneID, emailID) VALUES
(1, 'Supplier1', 'LastName1', 1, 1),
(2, 'Supplier2', 'LastName1', 2, 2),
(3, 'Supplier3', 'LastName2', 3, 3),
(4, 'Supplier4', 'LastName3', 4, 4),
(5, 'Supplier5', 'LastName4', 5, 5),
(5, 'Supplier5', 'LastName4', 6, 6),
(6, 'Supplier6', 'LastName6', 7, 7),
(6, 'Supplier6', 'LastName6', 8, 8);

CREATE TABLE IF NOT EXISTS product(
    productID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    supplierID INT NOT NULL,
    product_price DOUBLE NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    quantity_remaining INT NOT NULL,
    FOREIGN KEY (supplierID) REFERENCES supplier(supplierID)
);

INSERT INTO product (supplierID, product_price, product_name, quantity_remaining) VALUES
(1, 100.00, 'Laptop Pro', 50),
(1, 200.00, 'Wireless Mouse', 230),
(1, 10.00, 'USB-C Cable', 120),
(2, 200.00, 'Gaming Keyboard', 1),
(2, 220.00, '4K Webcam', 10),
(2, 240.00, 'Studio Microphone', 36),
(3, 150.00, 'Ergonomic Chair', 75),
(4, 175.00, 'Standing Desk', 80),
(5, 120.00, 'Noise Cancelling Headphones', 60),
(6, 90.00, 'Smart Watch', 70);


CREATE TABLE IF NOT EXISTS user (
    userID INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(10),
    last_name VARCHAR(255),
    city VARCHAR(40) NOT NULL,
    state VARCHAR(40) NOT NULL,
    zip INT NOT NULL,
    country VARCHAR(40) NOT NULL,
    age INT NOT NULL,
    phonenum BIGINT(10) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    passwd VARCHAR(255) NOT NULL,
    CHECK (age >= 18 AND age <= 105),
    PRIMARY KEY (userID)
);

INSERT INTO user (userID, first_name, last_name, city, state, zip, country, age, phonenum, email, passwd) VALUES
(1, 'Alice', 'Wonder', 'New York', 'NY', 12345, 'USA', 25, 1234567890, 'alice@example.com', 'password123'),
(2, 'Bob', 'Builder', 'Los Angeles', 'CA', 23456, 'USA', 30, 2345678901, 'bob@example.com', 'password123'),
(3, 'Charlie', 'Chocolate', 'Chicago', 'IL', 34567, 'USA', 35, 3456789012, 'charlie@example.com', 'password123'),
(4, 'Diana', 'Prince', 'Houston', 'TX', 45678, 'USA', 40, 4567890123, 'diana@example.com', 'password123'),
(5, 'Ethan', 'Hunt', 'Phoenix', 'AZ', 56789, 'USA', 45, 5678901234, 'ethan@example.com', 'password123'),
(6, 'Fiona', 'Shrek', 'Philadelphia', 'PA', 67890, 'USA', 50, 6789012345, 'fiona@example.com', 'password123');

CREATE TABLE IF NOT EXISTS cart(
    cartID INT NOT NULL,
    productID INT NOT NULL,
    cart_size INT,
    userID INT NOT NULL,
    PRIMARY KEY (cartID, productID),
    CHECK (cartID = userID),
    FOREIGN KEY (userID) REFERENCES user(userID) ON DELETE CASCADE,
    FOREIGN KEY (productID) REFERENCES product(productID) ON DELETE CASCADE
);

INSERT INTO cart (cartID, productID, cart_size, userID) VALUES
(1, 1, 2, 1),
(1, 3, 5, 1);

CREATE TABLE IF NOT EXISTS orders (
    orderID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    userID INT NOT NULL,
    order_date DATE NOT NULL,
    PRIMARY KEY (orderID,productID),
    FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (productID) REFERENCES product(productID)
);

INSERT INTO orders (orderID, userID, productID, quantity, order_date) VALUES
(1, 1, 1, 1, '2024-02-11'),
(1, 1, 2, 2, '2024-02-11'),
(2, 2, 4, 1, '2024-03-15'),
(3, 3, 7, 3, '2024-04-01');

CREATE TABLE IF NOT EXISTS payment(
	payment_id INT  NOT NULL PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    orderID INT NOT NULL,
	amount float check(amount>=1),
    FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);

INSERT INTO payment (userID, orderID, amount) VALUES
(1, 1, 500.00),
(2, 2, 175.00),
(3, 3, 450.00);

CREATE TABLE IF NOT EXISTS delivery_agent (
    agentID INT NOT NULL,
    orderID INT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    phoneID INT NOT NULL,
    emailID INT NOT NULL,
    PRIMARY KEY (agentID, orderID),
    FOREIGN KEY (phoneID) REFERENCES phone_number(phoneID),
    FOREIGN KEY (emailID) REFERENCES email(emailID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);

INSERT INTO delivery_agent (agentID, orderID, first_name, phoneID, emailID) VALUES
(1, 1, 'John', 16, 16),
(2, 2, 'Alice', 17, 17),
(3, 3, 'Bob', 18, 18);

CREATE TABLE IF NOT EXISTS offers (
    offerID INT NOT NULL,
    userID INT NOT NULL,
    discount DECIMAL(5,2) NOT NULL,
    last_login_date DATE,
    today_date DATE NOT NULL,
    PRIMARY KEY (offerID, userID),
    FOREIGN KEY (userID) REFERENCES user(userID)
);

INSERT INTO offers (offerID, userID, discount, last_login_date, today_date) VALUES
(1, 1, 0.10, '2024-02-10','2024-05-10'),
(2, 2, 0.15, '2024-01-01','2024-05-10');

CREATE TABLE IF NOT EXISTS order_feedback (
    feedbackID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    userID INT NOT NULL,
    orderID INT NOT NULL,
    feedback_text TEXT,
    rating INT,
    FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);

INSERT INTO order_feedback (userID, orderID, feedback_text, rating) VALUES
(1, 1, 'Fast delivery, good service', 5),
(2, 2, 'Late delivery', 2);

CREATE TABLE IF NOT EXISTS agent_feedback (
    feedbackID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    userID INT NOT NULL,
    agentID INT NOT NULL,
    orderID INT NOT NULL,
    feedback_text TEXT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (agentID, orderID) REFERENCES delivery_agent(agentID, orderID)
);

INSERT INTO agent_feedback (userID, agentID, orderID, feedback_text, rating) VALUES
(1, 1, 1, 'Polite and helpful', 5),
(2, 2, 2, 'Could improve communication', 3);

-- TRIGGERS
DELIMITER $$

CREATE TRIGGER check_ratings
BEFORE INSERT ON order_feedback
FOR EACH ROW 
BEGIN 
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SET NEW.feedback_text = 'Rating is invalid! Please provide a rating between 1 and 5.'; 
        SET NEW.rating = NULL;
    END IF; 
END$$

CREATE TRIGGER check_transaction_amount
BEFORE INSERT ON payment 
FOR EACH ROW 
BEGIN 
    IF NEW.amount < 5 THEN
        SET NEW.amount = 5;
    END IF; 
END$$

CREATE TRIGGER check_product_price
BEFORE INSERT ON product
FOR EACH ROW
BEGIN 
    IF NEW.product_price < 5 THEN
        SET NEW.product_price = 5;
    END IF; 
END$$

DELIMITER ;