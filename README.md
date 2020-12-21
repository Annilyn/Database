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

# 1. Query
SELECT dish_id, dish_name, dish_price 
FROM dishes
 
 LEFT JOIN customers ON dishes.dish_id = customers.customer_id 
 
INTERSECT 

SELECT dish_id, dish_name, dish_price 
FROM dishes

 RIGHT JOIN customers ON dishes.dish_id = customers.customer_id
 #### 1. This implies the result contains all the rows which are common to both the SELECT statements. It is important to know which dishes sell big. 
![1](https://user-images.githubusercontent.com/72851503/102737394-422d3300-4382-11eb-9e39-f12e046b2aa8.jpg)


