DROP DATABASE IF EXISTS CARTBHARO;

CREATE DATABASE IF NOT EXISTS CARTBHARO;
USE CARTBHARO;

CREATE TABLE IF NOT EXISTS phone_number (
    phoneID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    num CHAR(10) NOT NULL
);
INSERT INTO phone_number (num) VALUES
('1112223333'),
('4445556666'),
('7778889999'),
('1231231234'),
('4564564567'),
('7897897890'),
('9876543210'),
('0123456789'),
('3216549870'),
('9998887777'),
('0123222289'),
('3216547013'),
('3261637777'),
('0121224459'),
('9625088161'),
('3261112277'),
('6343124459'),
('2221088161'),
('3256786277'),
('1112223333'),
('4445556666'),
('7778889999'),
('1231231234'),
('4564564567'),
('7897897890'),
('9876543210'),
('0123456789'),
('3216549870'),
('9998887777'),
('0123222289'),
('3216547013'),
('3261637777'),
('0121224459'),
('9625088161'),
('3261112277'),
('6343124459'),
('2221088161'),
('3256786277'),
('1111111111'),
('2222222222'),
('3333333333'),
('4444444444'),
('5555555555'),
('6666666666'),
('7777777777'),
('8888888888');

CREATE TABLE IF NOT EXISTS email (
    emailID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    emailnum VARCHAR(50) NOT NULL
);
INSERT INTO email (emailnum) VALUES
('email1@example.com'),
('email2@example.com'),
('email3@example.com'),
('email4@example.com'),
('email5@example.com'),
('email6@example.com'),
('email7@example.com'),
('email8@example.com'),
('email9@example.com'),
('email10@example.com'),
('email11@example.com'),
('email12@example.com'),
('email13@example.com'),
('email14@example.com'),
('email15@example.com'),
('email16@example.com'),
('email17@example.com'),
('email18@example.com'),
('email19@example.com'),
('email20@example.com'),
('email21@example.com'),
('email22@example.com'),
('email23@example.com'),
('email24@example.com'),
('email25@example.com'),
('email26@example.com'),
('email27@example.com'),
('email28@example.com');

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
INSERT INTO admin (first_name, middle_name, last_name, phoneID, emailID, passwd) VALUES
('Garvit', NULL, 'Kochar', 26,26,'garvit@1234');

SELECT * from admin;

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

INSERT INTO supplier (supplierID,first_name, middle_name, last_name, phoneID, emailID) VALUES
(1,'Supplier1', NULL, 'LastName1', 1, 1),
(2,'Supplier2', NULL, 'LastName1', 2, 2),
(3,'Supplier3', NULL, 'LastName2', 3, 3),
(4,'Supplier4', NULL, 'LastName3', 4, 4),
(5,'Supplier5', NULL, 'LastName4', 5, 5),
(5,'Supplier5', NULL, 'LastName4', 6, 6),
(6,'Supplier6', NULL, 'LastName6', 7, 7),
(6,'Supplier6', NULL, 'LastName6', 8, 8);

SELECT 
    supplier.supplierID,
    supplier.first_name,
    supplier.middle_name,
    supplier.last_name,
    phone_number.num AS phone_number,
    email.emailnum AS email
FROM 
    supplier
JOIN 
    phone_number ON supplier.phoneID = phone_number.phoneID
JOIN 
    email ON supplier.emailID = email.emailID;


CREATE TABLE IF NOT EXISTS vendor (
    vendorID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    middle_name VARCHAR(30),
    last_name VARCHAR(30),
    supplierID INT NOT NULL,
    phoneID INT NOT NULL,
    emailID INT NOT NULL,
    FOREIGN KEY (phoneID) REFERENCES phone_number(phoneID),
    FOREIGN KEY (emailID) REFERENCES email(emailID),
    FOREIGN KEY (supplierID) REFERENCES supplier(supplierID)
);

INSERT INTO vendor (first_name, middle_name, last_name, supplierID, phoneID, emailID) VALUES
('Vendor1', NULL, 'LastName1', 1, 7, 7),
('Vendor1', NULL, 'LastName1', 1, 12, 12),
('Vendor2', NULL, 'LastName2', 2, 8, 8),
('Vendor3', NULL, 'LastName3', 3, 9, 9),
('Vendor4', NULL, 'LastName4', 4, 10, 10),
('Vendor6', NULL, 'LastName6', 6, 11, 11);

SELECT 
    vendorID,
    first_name,
    middle_name,
    last_name,
    (SELECT emailnum FROM email WHERE email.emailID = vendor.emailID) AS email,
    (SELECT num FROM phone_number WHERE phone_number.phoneID = vendor.phoneID) AS phone_number,
    supplierID
FROM 
    vendor;


CREATE TABLE IF NOT EXISTS store (
    storeID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(30) NOT NULL,
    city VARCHAR(40) NOT NULL,
    state VARCHAR(40) NOT NULL,
    zip INT NOT NULL,
    country VARCHAR(40) NOT NULL,
    vendorID INT NOT NULL,
    supplierID INT NOT NULL,
    phoneID INT NOT NULL,
    emailID INT NOT NULL,
    FOREIGN KEY (phoneID) REFERENCES phone_number(phoneID),
    FOREIGN KEY (emailID) REFERENCES email(emailID),
    FOREIGN KEY (vendorID) REFERENCES vendor(vendorID),
    FOREIGN KEY (supplierID) REFERENCES supplier(supplierID)
);

INSERT INTO store (store_name, city, state, zip, country, vendorID, supplierID, phoneID, emailID) VALUES
('Store1', 'City1', 'State1', 12345, 'Country1', 1, 1, 12, 12),
('Store2', 'City2', 'State2', 23456, 'Country2', 2, 2, 13, 13),
('Store3', 'City3', 'State3', 34567, 'Country3', 3, 3, 13, 13),
('Store3', 'City3', 'State3', 34567, 'Country3', 3, 3, 16, 16),
('Store4', 'City4', 'State4', 45678, 'Country4', 4, 4, 14, 14),
('Store6', 'City6', 'State6', 67890, 'Country6', 6, 6, 15, 15);

SELECT 
    storeID,
    store_name,
    city,
    state,
    zip,
    country,
    vendorID,
    supplierID,
    (SELECT emailnum FROM email WHERE email.emailID = store.emailID) AS email,
    (SELECT num FROM phone_number WHERE phone_number.phoneID = store.phoneID) AS phone_number
FROM 
    store;

CREATE TABLE IF NOT EXISTS product(
    productID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    supplierID INT NOT NULL,
    product_price DOUBLE NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    quantity_remaining INT NOT NULL,
    CHECK (product_price  > 0.00),
    CHECK (quantity_remaining >= 0),
    FOREIGN KEY (supplierID) REFERENCES supplier(supplierID)
);

INSERT INTO product (supplierID, product_price, product_name, quantity_remaining) VALUES
(1, 100.00, 'Product1', 50),
(1, 200.00, 'Product11', 230),
(1, 10.00, 'Product12', 120),
(2, 200.00, 'Product2', 1),
(2, 220.00, 'Product21', 10),
(2, 240.00, 'Product22', 36),
(3, 150.00, 'Product3', 75),
(4, 175.00, 'Product4', 80),
(5, 120.00, 'Product5', 60),
(6, 90.00, 'Product6', 70);

SELECT 
    productID,
    supplierID,
    product_price,
    product_name,
    quantity_remaining
FROM 
    product;


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

INSERT INTO user (first_name, middle_name, last_name, city, state, zip, country, age, phonenum, email, passwd) VALUES
('User1', NULL, 'LastName1', 'City1', 'State1', 12345, 'Country1', 25, 1234567890, 'user1@example.com', 'password11'),
('User2', NULL, 'LastName2', 'City2', 'State2', 23456, 'Country1', 30, 2345678901, 'user2@example.com', 'password22'),
('User3', NULL, 'LastName3', 'City3', 'State3', 34567, 'Country3', 35, 3456789012, 'user3@example.com', 'password33'),
('User4', 'middle4', 'LastName4', 'City4', 'State4', 45678, 'Country6', 40, 4567890123, 'user4@example.com', 'password44'),
('User5', NULL, 'LastName5', 'City5', 'State5', 56789, 'Country5', 45, 5678901234, 'user5@example.com', 'password55'),
('User6', NULL, 'LastName6', 'City6', 'State6', 67890, 'Country6', 50, 6789012345, 'user6@example.com', 'password66'),
('User7', NULL, 'LastName7', 'City7', 'State7', 78901, 'Country7', 55, 7890123456, 'user7@example.com', 'password77'),
('User8', NULL, 'LastName8', 'City8', 'State8', 89012, 'Country1', 60, 8901234567, 'user8@example.com', 'password88'),
('User9', NULL, 'LastName9', 'City9', 'State9', 90123, 'Country9', 65, 9012345678, 'user9@example.com', 'password99'),
('User10', NULL, 'LastName10', 'City10', 'State10', 12345, 'Country10', 70, 123232890, 'user10@example.com', 'password100');

SELECT 
    userID,
    first_name,
    middle_name,
    last_name,
    city,
    state,
    zip,
    country,
    age,
    phonenum,
    email,
    passwd
FROM 
    user;

CREATE TABLE IF NOT EXISTS cart(
    cartID INT NOT NULL,
    productID INT,
    cart_size BIGINT(200),
    userID INT NOT NULL,
    CHECK (cartID = userID),
    FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (productID) REFERENCES product(productID)
);
INSERT INTO cart (cartID, productID, cart_size, userID) VALUES
(1, 1, 3, 1),
(1, 2, 3, 1),
(1, 5, 3, 1),
(2, NULL,0, 2),
(3, 3, 1, 3),
(4, 6, 2, 4),
(4, 1, 2, 4);

SELECT 
    cartID,
    productID,
    cart_size,
    userID
FROM 
    cart;

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
(1,1, 1, 20, '2024-02-11'),
(1,1, 2,30, '2024-02-11'),
(1,1, 5,1, '2024-02-11'),
(2,2, 2,10, '2024-02-11'),
(3,3, 4,1, '2024-02-11'),
(4,4, 5,2, '2024-02-11'),
(5,5, 6,6, '2024-02-11'),
(6,6, 2,10, '2024-02-11'),
(6,6, 3,10, '2024-02-11'),
(7,7, 3,10, '2024-02-11'),
(8,8, 4,1, '2024-02-11'),
(9,9, 5,2, '2024-02-11'),
(10,10, 6,10, '2024-02-11');

SELECT * FROM orders;

CREATE TABLE IF NOT EXISTS payment(
	payment_id INT  NOT NULL PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    orderID INT NOT NULL,
	amount float check(amount>=1),
    FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);

INSERT INTO payment (userID, orderID, amount) VALUES
(1, 1, 8220),
(2, 2, 2000.00),
(3, 3, 200.00),
(4, 4, 440.00),
(5, 5, 1440.00),
(6, 6, 2100.00),
(7, 7, 100),
(8, 8, 200.00),
(9, 9, 440.00),
(10, 10, 2400.00);

SELECT * from payment;

CREATE TABLE IF NOT EXISTS delivery_agent (
    agentID INT NOT NULL,
    orderID INT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(10),
    last_name VARCHAR(255),
    phoneID INT NOT NULL,
    emailID INT NOT NULL,
    passwd VARCHAR(255) NOT NULL,
    FOREIGN KEY (phoneID) REFERENCES phone_number(phoneID),
    FOREIGN KEY (emailID) REFERENCES email(emailID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);
CREATE INDEX idx_agentID ON delivery_agent(agentID);

INSERT INTO delivery_agent (agentID, first_name, middle_name, last_name, phoneID, emailID, passwd, orderID) VALUES
(1, 'John', 'D', 'Doe', 16, 16, 'passwordagent1',1),
(2,'Alice', 'M', 'Smith', 17, 17, 'passwordagent2',2),
(3,'Bob', 'J', 'Johnson',  18, 18, 'passwordagent3',3),
(4,'Sarah', 'E', 'Williams',  19, 19, 'passwordagent4', 4),
(5,'Michael', 'R', 'Brown',  20, 20, 'passwordagent5', 5),
(6,'Jessica', 'K', 'Martinez', 21, 21, 'passwordagent6', 6),
(7,'David', 'L', 'Garcia', 22, 22, 'passwordagent7', 7),
(1,'John', 'D', 'Doe', 16, 16, 'passwordagent1', 8),
(3,'Bob', 'J', 'Johnson',  18, 18, 'passwordagent3', 9),
(5,'Michael', 'R', 'Brown',  20, 20, 'passwordagent5', 10);

SELECT 
    agentID,
    orderID,
    first_name,
    middle_name,
    last_name,
    (SELECT num FROM phone_number WHERE phone_number.phoneID = delivery_agent.phoneID) AS phone_number,
    (SELECT emailnum FROM email WHERE email.emailID = delivery_agent.emailID) AS email,
    passwd
FROM 
    delivery_agent;

CREATE TABLE IF NOT EXISTS offers (
    offerID INT NOT NULL,
    userID INT NOT NULL,
    discount DECIMAL(5,2) NOT NULL,
    last_login_date DATE,
    today_date DATE NOT NULL,
    FOREIGN KEY (userID) REFERENCES user(userID)
);
INSERT INTO offers (offerID, userID, discount, last_login_date,today_date) VALUES
(1, 1, 0.10, '2024-02-10','2024-02-10'),
(2, 2, 0.15, '2024-01-01','2024-02-10'),
(3, 3, 0.20, '2022-02-08','2024-02-10'),
(1, 4, 0.10, '2024-01-10','2024-02-10'),
(1, 5, 0.10, '2024-01-10','2024-02-10'),
(1, 6, 0.10, '2024-01-10','2024-02-10'),
(4, 7, 0.30, NULL,'2024-02-10'),
(2, 8, 0.20, '2023-02-10','2024-02-10'),
(1, 9, 0.10, '2024-01-20','2024-02-10'),
(1, 10, 0.10, '2024-01-13','2024-02-10');

SELECT 
    offerID,
    userID,
    discount,
    last_login_date,
    current_date
FROM 
    offers;


CREATE TABLE IF NOT EXISTS order_feedback (
    feedbackID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    userID INT NOT NULL,
    orderID INT NOT NULL,
    feedback_text TEXT,
    rating INT,
    FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);
INSERT INTO order_feedback (userID, orderID, feedback_text, rating)
VALUES
(1, 1, 'Fast delivery, good service', 5),
(2, 2, 'Late delivery', 2),
(3, 3, 'Everything was perfect', 5),
(4, 4, 'Product arrived damaged', 2),
(5, 5, 'Excellent packaging', 5),
(6, 6, 'Fast shipping, good packaging', 4),
(7, 7, 'Product was not as described', 1),
(8, 8, 'Excellent customer service', 5),
(9, 9, NULL, NULL),
(10, 10, NULL, NULL);

SELECT 
    feedbackID,
    userID,
    orderID,
    feedback_text,
    rating
FROM 
    order_feedback;


CREATE TABLE IF NOT EXISTS agent_feedback (
    feedbackID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    userID INT NOT NULL,
    agentID INT NOT NULL,
    orderID INT NOT NULL,
    feedback_text TEXT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (agentID) REFERENCES delivery_agent(agentID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);
INSERT INTO agent_feedback (userID, agentID, orderID, feedback_text, rating) VALUES
(1, 1, 1, 'Polite and helpful', 5),
(2, 2, 2,'Could improve communication', 3),
(3, 3, 3,'Very professional', 4),
(4, 4, 4,'Friendly agent, but late delivery', 3),
(5, 5, 5,'Professional and polite', 5),
(6, 6, 6,'Helpful and efficient', 4),
(7, 7, 7,'Delivery delayed without notice', 2),
(8, 1, 8,'Agent did not follow delivery instructions', 3),
(9, 3, 9,NULL, 5),
(10, 5, 10,NULL, NULL);

SELECT 
    feedbackID,
    userID,
    agentID,
    orderID,
    feedback_text,
    rating
FROM 
    agent_feedback;

SHOW TABLES;