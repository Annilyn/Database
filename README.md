# Database
#### This database Design for a delivery serviceis of a restuarant have six tables such as addresses,customers, delivers,dishes, orders, and order_details. This database collects sales to know what is the highest sales of all dishes. Also collects the information of the customers and what thier orders.
#### This is an exercise to practice SQL statements using the thaisonbk57 db. To download the db, visit the repository (link below) and download locally. Then open in db browser and test my statements below.

## https://github.com/thaisonbk57/Project-4-Design-database-for-a-delivery-service
## ERD Image
![Diagram](https://user-images.githubusercontent.com/72851503/102731216-39346580-4372-11eb-9c51-bfe759d083d4.png)



## Table Name and Discription:
#### 1.	The addresses table stores the data of address of the customers. Has 25 rows and 6 columns.
#### 2.	The customers table stores the data of the cuctomers information. Has 23 rows and 4 columns.
#### 3.	The delivers table stores the data of the customers info delivery.  Has 6 rows and 4 columns.
#### 4. The dishes table stores of the data of the dishes info such as a name and price. Has 25 rows and 6 columns.
#### 5. The orders table stores of tha data info such us date of orders and total price and payment methods. Has 25 rows and 11 columns.
#### 6. The order_details table stores of the data info about the quanlity of orders. Has 25 rows and 4 columns.

## 1. Query 
<p> SELECT dish_id, dish_name, dish_price 
FROM dishes
LEFT JOIN customers ON dishes.dish_id = customers.customer_id  
INTERSECT 
SELECT dish_id, dish_name, dish_price 
FROM dishes
RIGHT JOIN customers ON dishes.dish_id = customers.customer_id </p>

 #### 1. This implies the result contains all the rows which are common to both the SELECT statements. It is important to see the selected columns at the same time and not be with others in a table. 
![1](https://user-images.githubusercontent.com/72851503/102737394-422d3300-4382-11eb-9e39-f12e046b2aa8.jpg)

## 2. Query
SELECT dish_name, 
SUM(dish_price) 
FROM dishes
GROUP BY dish_name 
#### 2. This implies the result of total or sum of the SELECT statements. It is important to know what dish the big profit is.
![2](https://user-images.githubusercontent.com/72851503/102738848-4c513080-4386-11eb-8733-d11352ab1f6b.jpg)

## 3. Query
SELECT dish_id, dish_name, dish_name, dish_price FROM dishes
WHERE dish_price = ( SELECT MIN(dish_price) FROM dishes )
#### 3.To find the lowest (minimum) price of dish, you apply the MIN function to the dish_price column of the dishes table.
![5](https://user-images.githubusercontent.com/72851503/103144679-88123e80-4768-11eb-9f7a-61c90abe2fc0.jpg)

## 4. Query
SELECT order_date,
COUNT(*) 
FROM orders GROUP BY order_date
#### 4.To find the number of order per date, you use the COUNT with GROUP BY clause.

![3](https://user-images.githubusercontent.com/72851503/103144227-ce639f80-4760-11eb-914f-a0c3e4f4c406.jpg)
## 5. Query
SELECT dish_id, dish_name, dish_name, dish_price FROM dishes
WHERE dish_price = ( SELECT MAX(dish_price) FROM dishes )

#### 5. To find the maximum price of dish, you apply the MAX function to the dish_price column of the dishes table.
![6](https://user-images.githubusercontent.com/72851503/103144727-5ea5e280-4769-11eb-9ccd-0b70b5f3c18f.jpg)

## 6. Query
#### 6. To get the sum of all price of all orders,apply the SUM function to the dish_price column,To include the dish name in the result set, join the orders table with the dishes table.
![7](https://user-images.githubusercontent.com/72851503/103165431-cbe17280-4852-11eb-90cd-9ce62d6b0d32.jpg)

## 7. Query
#### 7. 








