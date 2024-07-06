USE CARTBHARO;

CREATE TRIGGER check_ratings
BEFORE INSERT ON order_feedback
FOR EACH ROW 
BEGIN 
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SET NEW.feedback_text = 'Rating is invalid! Please provide a rating between 1 and 5.'; 
        SET NEW.rating = NULL;
    END IF; 
END;

CREATE TRIGGER check_transaction_amount
BEFORE INSERT ON payment 
FOR EACH ROW 
BEGIN 
    IF NEW.amount < 5 THEN
        SET NEW.amount = 5;
    END IF; 
END;

CREATE TRIGGER check_product_price
BEFORE INSERT ON product
FOR EACH ROW
BEGIN 
    IF NEW.product_price < 5 THEN
        SET NEW.product_price = 5;
    END IF; 
END;
