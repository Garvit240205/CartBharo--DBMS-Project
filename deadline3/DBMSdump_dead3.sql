-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: cartbharo
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `cartbharo`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cartbharo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cartbharo`;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `adminID` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(30) NOT NULL,
  `middle_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `phoneID` int NOT NULL,
  `emailID` int NOT NULL,
  `passwd` varchar(255) NOT NULL,
  PRIMARY KEY (`adminID`),
  KEY `phoneID` (`phoneID`),
  KEY `emailID` (`emailID`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`phoneID`) REFERENCES `phone_number` (`phoneID`),
  CONSTRAINT `admin_ibfk_2` FOREIGN KEY (`emailID`) REFERENCES `email` (`emailID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'Garvit',NULL,'Kochar',26,26,'garvit@1234');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_feedback`
--

DROP TABLE IF EXISTS `agent_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_feedback` (
  `userID` int NOT NULL,
  `agentID` int NOT NULL,
  `feedback_text` text,
  `rating` int DEFAULT NULL,
  PRIMARY KEY (`userID`,`agentID`),
  KEY `agentID` (`agentID`),
  CONSTRAINT `agent_feedback_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `agent_feedback_ibfk_2` FOREIGN KEY (`agentID`) REFERENCES `delivery_agent` (`agentID`),
  CONSTRAINT `agent_feedback_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_feedback`
--

LOCK TABLES `agent_feedback` WRITE;
/*!40000 ALTER TABLE `agent_feedback` DISABLE KEYS */;
INSERT INTO `agent_feedback` VALUES (1,1,'Polite and helpful',5),(2,2,'Could improve communication',3),(3,3,'Very professional',4),(4,4,'Friendly agent, but late delivery',3),(5,5,'Professional and polite',5),(6,6,'Helpful and efficient',4),(7,7,'Delivery delayed without notice',2),(8,1,'Agent did not follow delivery instructions',3),(9,3,NULL,5),(10,5,NULL,NULL);
/*!40000 ALTER TABLE `agent_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cartID` int NOT NULL,
  `productID` int NOT NULL,
  `cart_size` int NOT NULL,
  `userID` int NOT NULL,
  `product_quantity` int NOT NULL,
  PRIMARY KEY (`cartID`,`productID`),
  KEY `userID` (`userID`),
  KEY `orderID` (`productID`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `cart_chk_1` CHECK ((`cartID` = `userID`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,1,10,1,10),(1,5,430,1,420),(2,2,123,2,123),(3,3,69420,3,69420),(4,2,20,4,20),(5,2,84,5,30),(5,3,30,5,30),(5,4,54,5,24),(6,1,7,6,12),(6,3,2,6,1);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_agent`
--

DROP TABLE IF EXISTS `delivery_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_agent` (
  `agentID` int NOT NULL,
  `orderID` int NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `middle_name` varchar(10) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `phoneID` int NOT NULL,
  `emailID` int NOT NULL,
  `passwd` varchar(255) NOT NULL,
  PRIMARY KEY (`agentID`,`orderID`),
  KEY `phoneID` (`phoneID`),
  KEY `emailID` (`emailID`),
  KEY `idx_agentID` (`agentID`),
  KEY `delivery_agent_ibfk_3_idx` (`orderID`),
  CONSTRAINT `delivery_agent_ibfk_1` FOREIGN KEY (`phoneID`) REFERENCES `phone_number` (`phoneID`),
  CONSTRAINT `delivery_agent_ibfk_2` FOREIGN KEY (`emailID`) REFERENCES `email` (`emailID`),
  CONSTRAINT `delivery_agent_ibfk_3` FOREIGN KEY (`orderID`) REFERENCES `orders` (`orderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_agent`
--

LOCK TABLES `delivery_agent` WRITE;
/*!40000 ALTER TABLE `delivery_agent` DISABLE KEYS */;
INSERT INTO `delivery_agent` VALUES (1,1,'John','D','Doe',16,16,'passwordagent1'),(1,8,'John','D','Doe',16,16,'passwordagent1'),(2,2,'Alice','M','Smith',17,17,'passwordagent2'),(3,3,'Bob','J','Johnson',18,18,'passwordagent3'),(3,9,'Bob','J','Johnson',18,18,'passwordagent3'),(4,4,'Sarah','E','Williams',19,19,'passwordagent4'),(5,5,'Michael','R','Brown',20,20,'passwordagent5'),(5,10,'Michael','R','Brown',20,20,'passwordagent5'),(6,6,'Jessica','K','Martinez',21,21,'passwordagent6'),(7,7,'David','L','Garcia',22,22,'passwordagent7');
/*!40000 ALTER TABLE `delivery_agent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email` (
  `emailID` int NOT NULL AUTO_INCREMENT,
  `emailnum` varchar(50) NOT NULL,
  PRIMARY KEY (`emailID`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email`
--

LOCK TABLES `email` WRITE;
/*!40000 ALTER TABLE `email` DISABLE KEYS */;
INSERT INTO `email` VALUES (1,'email1@example.com'),(2,'email2@example.com'),(3,'email3@example.com'),(4,'email4@example.com'),(5,'email5@example.com'),(6,'email6@example.com'),(7,'email7@example.com'),(8,'email8@example.com'),(9,'email9@example.com'),(10,'email10@example.com'),(11,'email11@example.com'),(12,'email12@example.com'),(13,'email13@example.com'),(14,'email14@example.com'),(15,'email15@example.com'),(16,'email16@example.com'),(17,'email17@example.com'),(18,'email18@example.com'),(19,'email19@example.com'),(20,'email20@example.com'),(21,'email21@example.com'),(22,'email22@example.com'),(23,'email23@example.com'),(24,'email24@example.com'),(25,'email25@example.com'),(26,'email26@example.com'),(27,'email27@example.com'),(28,'email28@example.com');
/*!40000 ALTER TABLE `email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offers`
--

DROP TABLE IF EXISTS `offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offers` (
  `offerID` int NOT NULL,
  `userID` int NOT NULL,
  `discount` decimal(5,2) NOT NULL,
  `last_login_date` date DEFAULT NULL,
  `today_date` date NOT NULL,
  KEY `userID` (`userID`),
  CONSTRAINT `offers_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offers`
--

LOCK TABLES `offers` WRITE;
/*!40000 ALTER TABLE `offers` DISABLE KEYS */;
INSERT INTO `offers` VALUES (1,1,0.10,'2024-02-10','2024-02-10'),(2,2,0.15,'2024-01-01','2024-02-10'),(3,3,0.20,'2022-02-08','2024-02-10'),(1,4,0.10,'2024-01-10','2024-02-10'),(1,5,0.10,'2024-01-10','2024-02-10'),(1,6,0.10,'2024-01-10','2024-02-10'),(4,7,0.30,NULL,'2024-02-10'),(2,8,0.20,'2023-02-10','2024-02-10'),(1,9,0.10,'2024-01-20','2024-02-10'),(1,10,0.10,'2024-01-13','2024-02-10');
/*!40000 ALTER TABLE `offers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_feedback`
--

DROP TABLE IF EXISTS `order_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_feedback` (
  `userID` int NOT NULL,
  `orderID` int NOT NULL,
  `feedback_text` text,
  `rating` int DEFAULT NULL,
  PRIMARY KEY (`orderID`),
  KEY `userID` (`userID`),
  CONSTRAINT `order_feedback_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `order_feedback_ibfk_2` FOREIGN KEY (`orderID`) REFERENCES `orders` (`orderID`),
  CONSTRAINT `order_feedback_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_feedback`
--

LOCK TABLES `order_feedback` WRITE;
/*!40000 ALTER TABLE `order_feedback` DISABLE KEYS */;
INSERT INTO `order_feedback` VALUES (1,1,'Fast delivery, good service',5),(2,2,'Late delivery',2),(3,3,'Everything was perfect',5),(4,4,'Product arrived damaged',2),(5,5,'Excellent packaging',5),(6,6,'Fast shipping, good packaging',4),(7,7,'Product was not as described',1),(8,8,'Excellent customer service',5),(9,9,NULL,NULL),(10,10,NULL,NULL);
/*!40000 ALTER TABLE `order_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `orderID` int NOT NULL,
  `productID` int NOT NULL,
  `userID` int NOT NULL,
  `order_date` date NOT NULL,
  `product_quantity` varchar(45) NOT NULL,
  PRIMARY KEY (`orderID`,`productID`),
  KEY `userID` (`userID`),
  KEY `productID` (`productID`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,1,'2024-02-11','10'),(1,2,1,'2024-02-11','20'),(2,2,1,'2024-02-11','30'),(3,5,1,'2024-02-11','12'),(4,2,2,'2024-02-11','213'),(5,4,3,'2024-02-11','11'),(6,5,4,'2024-02-11','12'),(7,6,5,'2024-02-11','213'),(8,2,6,'2024-02-11','44'),(9,2,6,'2024-02-11','33'),(10,3,7,'2024-02-11','43'),(11,4,8,'2024-02-11','43'),(12,5,9,'2024-02-11','2'),(13,6,10,'2024-02-11','1');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL,
  `orderID` int NOT NULL,
  `amount` float NOT NULL,
  PRIMARY KEY (`payment_id`,`orderID`),
  UNIQUE KEY `orderID_UNIQUE` (`orderID`),
  KEY `userID` (`userID`),
  KEY `payment_ibfk_2_idx` (`orderID`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`orderID`) REFERENCES `orders` (`orderID`),
  CONSTRAINT `payment_chk_1` CHECK ((`amount` >= 1))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,1,100),(2,2,2,200),(3,3,3,300),(4,4,4,400),(5,5,5,500),(6,6,6,600),(7,7,7,700),(8,8,8,800),(9,9,9,900),(10,10,10,1000),(11,10,11,12);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_number`
--

DROP TABLE IF EXISTS `phone_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_number` (
  `phoneID` int NOT NULL AUTO_INCREMENT,
  `num` char(10) NOT NULL,
  PRIMARY KEY (`phoneID`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_number`
--

LOCK TABLES `phone_number` WRITE;
/*!40000 ALTER TABLE `phone_number` DISABLE KEYS */;
INSERT INTO `phone_number` VALUES (1,'1112223333'),(2,'4445556666'),(3,'7778889999'),(4,'1231231234'),(5,'4564564567'),(6,'7897897890'),(7,'9876543210'),(8,'0123456789'),(9,'3216549870'),(10,'9998887777'),(11,'0123222289'),(12,'3216547013'),(13,'3261637777'),(14,'0121224459'),(15,'9625088161'),(16,'3261112277'),(17,'6343124459'),(18,'2221088161'),(19,'3256786277'),(20,'1112223333'),(21,'4445556666'),(22,'7778889999'),(23,'1231231234'),(24,'4564564567'),(25,'7897897890'),(26,'9876543210'),(27,'0123456789'),(28,'3216549870'),(29,'9998887777'),(30,'0123222289'),(31,'3216547013'),(32,'3261637777'),(33,'0121224459'),(34,'9625088161'),(35,'3261112277'),(36,'6343124459'),(37,'2221088161'),(38,'3256786277'),(39,'1111111111'),(40,'2222222222'),(41,'3333333333'),(42,'4444444444'),(43,'5555555555'),(44,'6666666666'),(45,'7777777777'),(46,'8888888888');
/*!40000 ALTER TABLE `phone_number` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `productID` int NOT NULL AUTO_INCREMENT,
  `supplierID` int NOT NULL,
  `product_price` double NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `quantity_remaining` int NOT NULL,
  PRIMARY KEY (`productID`,`supplierID`),
  KEY `supplierID` (`supplierID`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`supplierID`) REFERENCES `supplier` (`supplierID`),
  CONSTRAINT `product_chk_1` CHECK ((`product_price` > 0.00)),
  CONSTRAINT `product_chk_2` CHECK ((`quantity_remaining` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,1,100,'Product1',50),(2,1,200,'Product11',230),(3,1,10,'Product12',120),(4,2,200,'Product2',1),(5,2,220,'Product21',10),(6,2,240,'Product22',36),(7,3,150,'Product3',75),(8,4,175,'Product4',80),(9,5,120,'Product5',60),(10,6,90,'Product6',70);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store` (
  `storeID` int NOT NULL AUTO_INCREMENT,
  `store_name` varchar(30) NOT NULL,
  `city` varchar(40) NOT NULL,
  `state` varchar(40) NOT NULL,
  `zip` int NOT NULL,
  `country` varchar(40) NOT NULL,
  `vendorID` int NOT NULL,
  `supplierID` int NOT NULL,
  `phoneID` int NOT NULL,
  `emailID` int NOT NULL,
  PRIMARY KEY (`storeID`,`vendorID`,`supplierID`),
  KEY `phoneID` (`phoneID`),
  KEY `emailID` (`emailID`),
  KEY `vendorID` (`vendorID`),
  KEY `supplierID` (`supplierID`),
  CONSTRAINT `store_ibfk_1` FOREIGN KEY (`phoneID`) REFERENCES `phone_number` (`phoneID`),
  CONSTRAINT `store_ibfk_2` FOREIGN KEY (`emailID`) REFERENCES `email` (`emailID`),
  CONSTRAINT `store_ibfk_3` FOREIGN KEY (`vendorID`) REFERENCES `vendor` (`vendorID`),
  CONSTRAINT `store_ibfk_4` FOREIGN KEY (`supplierID`) REFERENCES `supplier` (`supplierID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES (1,'Store1','City1','State1',12345,'Country1',1,1,12,12),(2,'Store2','City2','State2',23456,'Country2',2,2,13,13),(3,'Store3','City3','State3',34567,'Country3',3,3,13,13),(4,'Store3','City3','State3',34567,'Country3',3,3,16,16),(5,'Store4','City4','State4',45678,'Country4',4,4,14,14),(6,'Store6','City6','State6',67890,'Country6',6,6,15,15);
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `supplierID` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(30) NOT NULL,
  `middle_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `phoneID` int NOT NULL,
  `emailID` int NOT NULL,
  PRIMARY KEY (`supplierID`),
  KEY `phoneID` (`phoneID`),
  KEY `emailID` (`emailID`),
  CONSTRAINT `supplier_ibfk_1` FOREIGN KEY (`phoneID`) REFERENCES `phone_number` (`phoneID`),
  CONSTRAINT `supplier_ibfk_2` FOREIGN KEY (`emailID`) REFERENCES `email` (`emailID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'Supplier1',NULL,'LastName1',1,1),(2,'Supplier1',NULL,'LastName1',2,2),(3,'Supplier2',NULL,'LastName2',3,3),(4,'Supplier3',NULL,'LastName3',4,4),(5,'Supplier4',NULL,'LastName4',5,5),(6,'Supplier4',NULL,'LastName4',5,5),(7,'Supplier6',NULL,'LastName6',6,6),(8,'Supplier6',NULL,'LastName6',6,6);
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `middle_name` varchar(10) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `city` varchar(40) NOT NULL,
  `state` varchar(40) NOT NULL,
  `zip` int NOT NULL,
  `country` varchar(40) NOT NULL,
  `age` int NOT NULL,
  `phonenum` bigint NOT NULL,
  `email` varchar(255) NOT NULL,
  `passwd` varchar(255) NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `phonenum` (`phonenum`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `user_chk_1` CHECK (((`age` >= 18) and (`age` <= 105)))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'User1',NULL,'LastName1','City1','State1',12345,'Country1',25,1234567890,'user1@example.com','password11'),(2,'User2',NULL,'LastName2','City2','State2',23456,'Country1',30,2345678901,'user2@example.com','password22'),(3,'User3',NULL,'LastName3','City3','State3',34567,'Country3',35,3456789012,'user3@example.com','password33'),(4,'User4','middle4','LastName4','City4','State4',45678,'Country6',40,4567890123,'user4@example.com','password44'),(5,'User5',NULL,'LastName5','City5','State5',56789,'Country5',45,5678901234,'user5@example.com','password55'),(6,'User6',NULL,'LastName6','City6','State6',67890,'Country6',50,6789012345,'user6@example.com','password66'),(7,'User7',NULL,'LastName7','City7','State7',78901,'Country7',55,7890123456,'user7@example.com','password77'),(8,'User8',NULL,'LastName8','City8','State8',89012,'Country1',60,8901234567,'user8@example.com','password88'),(9,'User9',NULL,'LastName9','City9','State9',90123,'Country9',65,9012345678,'user9@example.com','password99'),(10,'User10',NULL,'LastName10','City10','State10',12345,'Country10',70,123232890,'user10@example.com','password100');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendor`
--

DROP TABLE IF EXISTS `vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendor` (
  `vendorID` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(30) NOT NULL,
  `middle_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `supplierID` int NOT NULL,
  `phoneID` int NOT NULL,
  `emailID` int NOT NULL,
  PRIMARY KEY (`vendorID`),
  KEY `phoneID` (`phoneID`),
  KEY `emailID` (`emailID`),
  KEY `supplierID` (`supplierID`),
  CONSTRAINT `vendor_ibfk_1` FOREIGN KEY (`phoneID`) REFERENCES `phone_number` (`phoneID`),
  CONSTRAINT `vendor_ibfk_2` FOREIGN KEY (`emailID`) REFERENCES `email` (`emailID`),
  CONSTRAINT `vendor_ibfk_3` FOREIGN KEY (`supplierID`) REFERENCES `supplier` (`supplierID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendor`
--

LOCK TABLES `vendor` WRITE;
/*!40000 ALTER TABLE `vendor` DISABLE KEYS */;
INSERT INTO `vendor` VALUES (1,'Vendor1',NULL,'LastName1',1,7,7),(2,'Vendor1',NULL,'LastName1',1,12,12),(3,'Vendor2',NULL,'LastName2',2,8,8),(4,'Vendor3',NULL,'LastName3',3,9,9),(5,'Vendor4',NULL,'LastName4',4,10,10),(6,'Vendor6',NULL,'LastName6',6,11,11),(7,'gar',NULL,'vit',2,3,10);
/*!40000 ALTER TABLE `vendor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-12 21:30:04
