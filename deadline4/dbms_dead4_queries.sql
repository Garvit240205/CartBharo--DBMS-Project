#1.list all agents along with orderID and rating delivering order with rating>=3 in increasing order of rating.
SELECT  agentID,order_feedback.orderID,order_feedback.rating from agent_feedback,order_feedback where agent_feedback.orderID=order_feedback.orderID and order_feedback.rating>=3 order by order_feedback.rating ASC;

#2.list all suppliers who dont supplies any product
select supplierID,first_name from supplier where supplierID not in(select supplierID from product);

#3.listing all orders whose amount is greater than avg order value of all orders.
select orderID from payment where amount > all(select avg(amount) from payment);

#4.query to increase quantity of product
update product set quantity_remaining=quantity_remaining + 10 where productID=4;

#5.delete a product from cart
delete from cart where cartID=1 and productID=2;

#6.insert a product into cart
insert into cart(cartID,productID,cart_size,userID) values (1,2,3,1);

#7.listing all users with their orderID who gave feedback having word Fast in it
select first_name,orderID from order_feedback,user where order_feedback.userID=user.userID and feedback_text like "Fast%";

#8.listing all suppliers whose product is sold with their revenues
SELECT s.first_name, 
       SUM(o.quantity * p.product_price) AS revenue 
FROM orders o
JOIN product p ON o.productID = p.productID
JOIN supplier s ON p.supplierID = s.supplierID
GROUP BY s.supplierID, s.first_name;

#9.updating address of a user
update user set city='Delhi',state='delhi',zip=1100034,country='India' where userID=1;

#10.listing all orders with their total amounts
select orderID,sum(orders.quantity*product.product_price) as amount from orders,product where orders.productID=product.productID group by orderID;
