# Database-delivery-service
*   This database Design for a delivery serviceis of a restuarant and the details of the dish. Have six tables such as addresses,customers, delivers,dishes, orders, and order_details. This database collects sales report. Also collects the information of the customers such as name, address and Phone number, email and what thier orders.
## ERD Image:
![Diagram](https://user-images.githubusercontent.com/72851503/102731216-39346580-4372-11eb-9c51-bfe759d083d4.png)
## Database Dependency Diagram:
![Dependency Diagram](https://user-images.githubusercontent.com/72851503/103187779-c5a9cf80-4900-11eb-85fe-e0cd60e384c6.png)

## Table Name and Discription:
 1.	The customers table stores the data of the cuctomers information. Has 23 rows and 4 columns.
 2.	The addresses table stores the data of address of the customers. Has 25 rows and 6 columns.
 3. The orders table stores of tha data info such us date of orders and total price and payment methods. Has 25 rows and 11 columns.
 4.	The delivers table stores the data of the customers info delivery.  Has 6 rows and 4 columns.
 5. The order_details table stores of the data info about the quanlity of orders. Has 25 rows and 4 columns.
 6. The dishes table stores of the data of the dishes info such as a name and price. Has 25 rows and 6 columns.

* This is an exercise to practice SQL statements using the thaisonbk57 db. To download the db, visit the repository (link below) and download locally. Then open in db browser and test my statements below.
#### https://github.com/thaisonbk57/Project-4-Design-database-for-a-delivery-service

##  1. Query 
#### SELECT dish_name, dish_description, dish_price,
#### CASE 
#### WHEN dish_price < 3 THEN 'Low' 
#### WHEN dish_price >= 3 AND dish_price <= 5 THEN 'Average' 
#### WHEN dish_price > 5 THEN 'High' 
#### END evaluation
#### FROM dishes;
*    If the price is less than 3, “Low”. If the price is between 3 and 5, it returns “average”. When the price is greater than 5, “High”.
*    It is important to determine what dish are low price and high price or average.
#### Output:
![888](https://user-images.githubusercontent.com/72851503/103211936-7d140580-4944-11eb-88bf-ad209bb4d56e.jpg)

##  2. Query 
#### SELECT dish_id, dish_name, dish_description, dish_price 
#### FROM dishes 
#### ORDER BY dish_price DESC 
#### LIMIT 1 OFFSET 1;
*    To get what dish has 2nd  highest price in the restaurant. 
*    It is important to determine the 2nd highest price.
####  Output :
![999](https://user-images.githubusercontent.com/72851503/103211462-4093da00-4943-11eb-994b-454dab719cbf.jpg)

## 3. Query
#### SELECT dish_id, dish_name, dish_price 
#### FROM dishes
#### LEFT JOIN customers ON dishes.dish_id = customers.customer_id 
#### INTERSECT 
#### SELECT dish_id, dish_name, dish_price 
#### FROM dishes
#### RIGHT JOIN customers ON dishes.dish_id = customers.customer_id;
*  This implies the result contains all the rows which are common to both the SELECT statements.
*  It is important to see the selected columns at the same time and not be with others in a table. 
#### Output:
![1](https://user-images.githubusercontent.com/72851503/102737394-422d3300-4382-11eb-9e39-f12e046b2aa8.jpg)

## 4. Query
#### SELECT dish_id,dish_name, dish_price 
#### FROM dishes
#### WHERE dish_price = ( SELECT MIN(dish_price) FROM dishes );
*  To find the lowest (minimum) price of dish, apply the MIN function to the dish_price column of the dishes table.
*  It is important to know what are minimun price of all dish.
#### Output:
![33](https://user-images.githubusercontent.com/72851503/103166430-ee788900-485c-11eb-9e00-f0e822d70d37.jpg)

## 5. Query
#### SELECT order_date, COUNT(*) 
#### FROM orders 
#### GROUP BY order_date;
*  To find the number of order per date.
*  It is important to know what date many orders and busy days.
#### Output:
![3](https://user-images.githubusercontent.com/72851503/103144227-ce639f80-4760-11eb-914f-a0c3e4f4c406.jpg)

## 6. Query
#### SELECT dish_id, dish_name, dish_price 
#### FROM dishes
#### WHERE dish_price = ( SELECT MAX(dish_price) FROM dishes );
*  To find the maximum price of dish.
*  It is important to know what are maximum price of all dish.
#### Output:
![55](https://user-images.githubusercontent.com/72851503/103166394-7a3de580-485c-11eb-9d97-cb921ef03406.jpg)

## 7. Query
#### SELECT dish_id, dish_name, SUM(dish_price) 
#### FROM dishes 
#### INNER JOIN orders ON dish_id = dish_id 
#### GROUP BY dish_id;
*  To get the total price to all orders dishes. To include the dish name in the result set, join the orders table with the dishes table.
*  It is important know how much the total orders per dishes.
#### Output:
![7](https://user-images.githubusercontent.com/72851503/103165431-cbe17280-4852-11eb-90cd-9ce62d6b0d32.jpg)

## 8. Query
#### SELECT dish_name, dish_price 
#### FROM dishes 
#### WHERE dish_price = ANY ( SELECT AVG(dish_price) 
#### FROM dishes 
#### GROUP BY dish_id) 
#### ORDER BY dish_name, dish_price;
 *	 To find all dishes has price are equal to the average price of dishes.
 *	 It is important to determine what is average price.
#### Output:
![666](https://user-images.githubusercontent.com/72851503/103169692-06f69c80-4879-11eb-950b-ae809e2cabe8.jpg)

## 9. Query
#### SELECT order_date,delivery_street, order_status, order_total 
#### FROM orders 
#### WHERE order_total = (SELECT DISTINCT order_total 
#### FROM orders 
#### ORDER BY order_total DESC LIMIT 2 , 2);
*  To get what date has 3rd highest.Combine both queries into a single query.
*  It is impotant to determine what date has 3rd highest. 
#### Output:
![33rd](https://user-images.githubusercontent.com/72851503/103208598-02df8300-493c-11eb-9fa2-efcda6920faa.jpg)

## 10. Query
#### SELECT SUM(dish_price) 
#### FROM dishes;
*	 To find the sum price of all dishes.
*	 It is important to determine total price of all dishes.
#### Output:
![77](https://user-images.githubusercontent.com/72851503/103169935-11b23100-487b-11eb-98d0-37a4bb33bd6e.jpg)

##  11 . Query 
#### SELECT customer_id, customer_name, customer_phone
 #### FROM customers 
#### WHERE EXISTS( SELECT 1 FROM addresses 
#### WHERE addresses.customer_id = customers.customer_id);
*   To finds all customers who have at least one dependent.
*   It is important to determine who are dependent.
####  Output :
![111](https://user-images.githubusercontent.com/72851503/103215376-227fa700-494e-11eb-8b15-2040e3d7b9e2.jpg)

##  12. Quary
#### SELECT order_date, order_status, 
#### ROW_NUMBER() OVER(ORDER BY order_status DESC) RANK 
#### FROM orders;
*    This query shows the date of orders what are the status.
*    This query can help determine what date of orders has canceled or delivered.
####  Output :
![122](https://user-images.githubusercontent.com/72851503/103219144-e4878080-4957-11eb-8ce1-b8657f113494.jpg)













