--
-- customers table
--
DROP DATABASE IF EXISTS project_4;
CREATE DATABASE project_4;
USE project_4;


CREATE TABLE customers(
	customer_id INT AUTO_INCREMENT,
    customer_name VARCHAR(30) NOT NULL,
    customer_phone VARCHAR(15) DEFAULT NULL,
    customer_email VARCHAR(100) DEFAULT NULL,
    CONSTRAINT pk_customer_id PRIMARY KEY(customer_id)
) ENGINE=InnoDB;
--
-- shipping address
--
CREATE TABLE addresses(
	address_id INT AUTO_INCREMENT,
    customer_id INT NOT NULL,
    address_street VARCHAR(50) NOT NULL,
    address_house_number INT(5) NOT NULL,
    address_zipcode INT(5) NOT NULL,
    address_city VARCHAR(20) DEFAULT NULL,
	CONSTRAINT pk_address_id PRIMARY KEY(address_id),
    CONSTRAINT fk_customer_id FOREIGN KEY(customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE  ON UPDATE CASCADE -- the FK will be updated if PK is updated.
) ENGINE=InnoDB;
--
-- delivers table
-- 
CREATE TABLE delivers(
	deliver_id INT AUTO_INCREMENT,
    deliver_name VARCHAR(50) NOT NULL,
    deliver_phone VARCHAR(15) DEFAULT NULL,
    active_status TINYINT, -- still working in the company?
    CONSTRAINT pk_deliver_id PRIMARY KEY(deliver_id)
) ENGINE=InnoDB;

--
-- dishes table - menu items table
--
CREATE TABLE dishes(
	dish_id INT AUTO_INCREMENT,
    dish_name VARCHAR(50) NOT NULL,
    dish_description TEXT NOT NULL,
	dish_price FLOAT(3,2) NOT NULL DEFAULT 0,
    course ENUM('main', 'dessert') NOT NULL DEFAULT 'main',
    on_menu TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT pk_dish_id PRIMARY KEY(dish_id)
) ENGINE=InnoDB;

CREATE INDEX index_dish
ON dishes (dish_name);
--
-- orders table
--
CREATE TABLE orders(
	order_id INT AUTO_INCREMENT,
    deliver_id INT, -- will be updated later, after the meals get prepared.
    customer_id INT NOT NULL,
    order_date DATETIME,
    order_status ENUM('pending','processing','delivered','in_transit','canceled') DEFAULT 'pending',
    order_total FLOAT(3,2) DEFAULT 0,
    delivery_street VARCHAR(50) NOT NULL,
    delivery_house_number INT(5) NOT NULL,
    delivery_zipcode INT(5) NOT NULL,
    delivery_city VARCHAR(20) DEFAULT NULL,
    payment_method ENUM('cash','paypal','credit_card') DEFAULT 'cash',
    CONSTRAINT pk_order_id PRIMARY KEY(order_id),
    CONSTRAINT fk_deliver_id FOREIGN KEY(deliver_id) REFERENCES delivers(deliver_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_orders_customer_id FOREIGN KEY(customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

--
-- ordered dishes table
--
CREATE TABLE order_details(
    order_detail_id INT AUTO_INCREMENT,
	order_id INT NOT NULL,
    dish_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT pk_order_detail_id PRIMARY KEY(order_detail_id),
    CONSTRAINT fk_order_id FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_dish_id FOREIGN KEY(dish_id) REFERENCES dishes(dish_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

/*
Create some important views
*/
CREATE VIEW `order_id__ordered_dish__name__price__quantity`
AS SELECT o.order_id AS order_id,
		o.dish_id  AS dish_id,
        d.dish_name AS dish,
		d.dish_price AS price,
		o.quantity AS quantity
FROM order_details AS o
JOIN dishes AS d
ON o.dish_id=d.dish_id
order by o.order_id;


CREATE VIEW `total_cost_for_each_ordered_item`
AS SELECT order_id, dish, (quantity * price) AS total_per_each
   FROM (SELECT o.order_id AS order_id,
				o.dish_id  AS dish_id,
				d.dish_name AS dish,
				o.quantity AS quantity,
				d.dish_price    AS price
		FROM order_details AS o
		JOIN dishes AS d
		ON o.dish_id=d.dish_id) AS T1
        ORDER BY order_id;



CREATE VIEW `total_cost_for_each_order`
AS SELECT order_id, SUM(total_per_each) AS total
   FROM (SELECT order_id, quantity * price AS total_per_each
		FROM (SELECT o.order_id AS order_id,
					o.dish_id  AS dish_id,
					o.quantity AS quantity,
					d.dish_price    AS price
			FROM order_details AS o
			JOIN dishes AS d
			ON o.dish_id=d.dish_id) AS T1) AS T2
   GROUP BY order_id;
   
   
CREATE VIEW `menu_today`
AS SELECT * FROM dishes
WHERE on_menu <> 0;
   
   
   


CREATE VIEW `total_sales`
-- calculate how much money comes from each payment_method.
AS SELECT payment_method, (SUM(order_total)) AS sales
FROM orders
GROUP BY payment_method;




-- create trigger to auto update the orders.order_total, when a new dish is added to order_details
-- 1. A new order is created.
-- 2. Add new record to order_details table
-- 3. Trigger will update the total inside the orders table


DELIMITER //
CREATE TRIGGER update_total AFTER INSERT ON order_details FOR EACH ROW BEGIN
	-- total_cost variable will be assigned to orders.order_total.
	DECLARE total_cost FLOAT;
    
    -- we use 3 sub-query to create 3 virtual tables.
	SELECT total
	FROM `total_cost_for_each_order`
	WHERE order_id=NEW.order_id
    INTO total_cost;
    
	UPDATE orders
    SET order_total = total_cost
    WHERE orders.order_id = NEW.order_id;
    END //


CREATE PROCEDURE off_menu()
-- always call off_menu() first before insert new dishes of the next day.
BEGIN
UPDATE dishes
SET on_menu = 0
WHERE on_menu <> 0;
END //


CREATE PROCEDURE orders_of_customer(in ID INT)
-- select all orders of a customer
-- input: customer_id
BEGIN
	select * from (select o.customer_id as customer_id,c.customer_name as customer_name,o.order_id as order_id, o.order_date as order_date, o.order_total as total
	from orders as o
	join customers as c
	on o.customer_id = c.customer_id
    order by customer_id) as T1
    where customer_id = ID;

END //

DELIMITER ;














-- INSERT DATA INTO THE TABLES --






INSERT INTO customers(customer_name, customer_phone, customer_email) VALUES
('Maria Anders', '015168194534', 'mariaanders@gmail.com'),
('Sakudo Joki', '015345233435', 'sakudojoki@gmail.com'),
('Martin Lee', '015168235234', 'Sakudo@gmail.com'),
('Long Tran Ha', '01516853234', 'Thomas@gmail.com'),
('Ana Trujillo', '0151767544234', 'Berglund@gmail.com'),
('Thomas Hardy', '01523623422', 'Anders@gmail.com'),
('Christina Berglund', '013634594234', 'Laurence@gmail.com'),
('Hanna Moos', '015168196765', 'Hanna@gmail.com'),
('Martin Sommer', '015168194734', 'Martin@gmail.com'),
('Laurence Lebihans', '015168194514', 'Lebihans@gmail.com'),
('Victoria Ashworth', '01516819414', 'Ashworth@gmail.com'),
('Patricio Simpson', '015168190967', 'Simpson@gmail.com'),
('Francisco Chang', '015162376456', 'Francisco@gmail.com'),
('Carine Schmitt', '01516834565', 'Schmitt@gmail.com'),
('Paolo Accorti', '0151681947344', 'Paolo@gmail.com'),
('Lino Rodriguez', '01516819445', 'Rodriguez@gmail.com'),
('Anna Schmitt', '015168194761', 'mariaanders@gmail.com'),
('Helena Fischer', '015168194987', 'Fischer@gmail.com'),
('Uldo Müller', '015168194123', 'Müller@gmail.com'),
('Manuel Neue', '015168194456', 'ManuelNeue@gmail.com'),
('Tony Kross', '015168194789', 'KrossTony@gmail.com'),
('Tony Stark', '015168194104', 'Stark@gmail.com'),
('Ronaldo', '01516819498', 'Ronaldo@gmail.com');





INSERT INTO addresses (customer_id, address_street, address_house_number, address_zipcode, address_city) VALUES
(1, 'Strassmannstraße', 123, 11249, 'Berlin'),
(2, 'Adalbertstraße', 421, 10549, 'Berlin'),
(3, 'Adele-Schreiber-Krieger-Straße', 41, 10249, 'Berlin'),
(4, 'Albrechtstraße', 411, 10649, 'Berlin'),
(5, 'Alexanderstraße', 41, 10149, 'Berlin'),
(6, 'Alexanderufer', 741, 11219, 'Berlin'),
(7, 'Alexandrinenstraße', 1, 12249, 'Berlin'),
(8, 'Alex-Wedding-Straße', 41, 13249, 'Berlin'),
(9, 'Jakobstraße', 11, 13249, 'Berlin'),
(10, 'Alte Leipziger Straße', 21, 15249, 'Berlin'),
(11, 'Schönhauser Straße', 21, 20249, 'Berlin'),
(12, 'Festungsgraben', 34, 13249, 'Berlin'),
(13, 'Am Köllnischen Park', 41, 15449, 'Berlin'),
(14, 'Am Nußbaum', 211, 10243, 'Berlin'),
(15, 'Am Pankepark', 65, 10239, 'Berlin'),
(16, 'Am Weidendamm', 54, 23249, 'Berlin'),
(17, 'Am Zeughaus', 21, 10549, 'Berlin'),
(18, 'Am Zirkus', 67, 10298, 'Berlin'),
(19, 'An der Kolonnade', 98, 13449, 'Berlin'),
(20, 'Aachener Straße', 11, 11229, 'Berlin'),
(21, 'Bernhardstraße', 54, 10221, 'Berlin'),
(22, 'Bernhard-Wieck-Promenade', 12, 10249, 'Berlin'),
(23, 'Bonner Straße', 34, 10249, 'Berlin'),
(22, 'Borkumer Straße', 141, 10249, 'Berlin'),
(21, 'Dachsberg', 22, 10249, 'Berlin'),
(20, 'Dahlmannstraße', 55, 10249, 'Berlin'),
(19, 'Dauerwaldweg', 666, 16249, 'Berlin'),
(18, 'Deidesheimer Straße', 32, 17249, 'Berlin'),
(17, 'Durlacher Straße', 41, 18249, 'Berlin'),
(16, 'Eberbacher Straße', 41, 19249, 'Berlin'),
(15, 'Emser Straße', 41, 10219, 'Berlin'),
(14, 'Fasanenstraße', 41, 10229, 'Berlin'),
(13, 'Friedrich-Hollaender-Platz', 41, 10239, 'Berlin'),
(12, 'Friedrichsruher Straße', 41, 10249, 'Berlin'),
(11, 'Friedrichshaller Straße', 41, 10259, 'Berlin'),
(10, 'Frischlingsteig', 41, 10269, 'Berlin'),
(9, 'Friedrichsruher Straße', 41, 10279, 'Berlin'),
(8, 'Haeselerstraße', 41, 10289, 'Berlin'),
(7, 'Halberstädter Straße', 41, 10299, 'Berlin'),
(6, 'Haeselerstraße', 41, 19249, 'Berlin');



INSERT INTO delivers (deliver_name, deliver_phone) VALUES
('Jonas Wisky', '0989251445'),
('Jenifer Lopez', '0125195477'),
('Maria Hash', '0989251449'),
('Blooper Müller', '0989255445'),
('Chang Ok', '0989251741'),
('Julien Brat', '0195412887');




INSERT INTO dishes (dish_name, dish_description, dish_price, course, on_menu) VALUES
('Goi Cuon Thap Cam', 'Chicken / Eggs / rolled in rice paper.', 8.2,'main', 0),
('Goi Cuon Chay', 'Tofu / Eggs / rolled in rice paper.', 8.2,'main', 0),
('Vietbowl Rolls', 'Tender Beef rolled in rice paper.', 4.5,'dessert', 0),
('Edamame', 'Green Beans steamed with see salt.', 4.5,'dessert', 0),
('Nem Ran Gion', 'Fried mint meat rolled in rice paper.', 8.2,'main', 0),
('Nom Mien Ga', 'Chicken salad with glas noodle.', 8.2,'main', 0),
('Nom Du Du', 'Green papaya salad with prawns and chili.', 4.5,'dessert', 0),
('Nom Xoai Ngo Sen', 'Chicken salad with fresh mango and lotus corns.', 4.5,'dessert', 0),
('Tom Nuong', 'Grilled Big prawns with salad.', 8.2,'main', 0),
('Wantan Chien', 'Fried dumplings with salad', 8.2,'main', 0),
('Pho Ga', 'Classical vietnamese soup with rice noodle ribbon and chicken.', 4.5,'dessert', 0),
('Pho Bo', 'Vietnamese soup with beef.', 4.5,'dessert', 0),
('Bun Bo Nam Bo', 'Rice noodle with beef and lime-dressing, salad.', 8.2,'main', 0),
('Bun Ga Nuong', 'Rice noodle with grilled chicken and salad.', 8.2,'main', 0),
('Bun Nem', 'Rice noodle with fried spring rolls.', 4.5,'dessert', 0),
('Bun Tom', 'Rice noodle with grilled prawns.', 4.5,'dessert', 0),
('Bun Chay', 'Rice noodle with tofu and salad.', 8.2,'main', 0),
('Ga Xao Xa Ot', 'Chicken breast fried with vegetables and chili.', 8.2,'main', 0),
('Ga Nuong La Chanh', 'Grilled chicken with lime leaves.', 4.5,'dessert', 0),
('Ga Curry', 'Chicken breast in curry sauce and vegetables.', 4.5,'dessert', 0),
('Lon Xa Ot', 'Fried pork with curry and coconut milk..', 8.2,'main', 0),
('Lon Curry', 'Grilled pork with lemon gras, ginger and chili.', 8.2,'main', 0),
('Bo Nuong Xa Ot', 'Grilled beef with lemon gras, ginger and chili.', 4.5,'dessert', 0),
('Bo Curry', 'Beef in coconut milk and curry sauce.', 4.5,'dessert', 0),
('Bo Cuon Rau Chien', 'Vegetable rolled in beef and deep fried.', 8.2,'main', 0),
('Bo Xao Dua', 'Fried tender beef with pineapple and oyster sauce.', 8.2,'main', 0),
('Bo Cuon La Lot', 'Mint meat rolled in lolot leaves and deep fried.', 4.5,'dessert', 0),
('Vit Hat Sen', 'Crispy duck with oyster sauce.', 4.5,'dessert', 0),
('Tom Curry', 'Prawns in coconut milk and curry sauce.', 8.2,'main', default),
('Tom Ran Muoi Ot', 'Fried big prawns with chili, ginger.', 8.2,'main', default),
('Tom Ran Muoi Ot', 'Fried big prawns with chili, ginger.', 4.5,'dessert', default),
('Tom Xao Hat Dieu', 'Fried prawns with cashew nuts and vegetables.', 4.5,'dessert', default);






INSERT INTO orders(deliver_id, customer_id, order_date, order_status, delivery_street, delivery_house_number, delivery_zipcode, delivery_city, payment_method) VALUES
(1,1,'2018-02-07 14:44:20', 'delivered', 'Straßmannstraße', 12, 10123, default, 'paypal'),
(2,2,'2018-04-07 14:44:20', 'canceled', 'Adalbertstraße', 22, 10234, default, default),
(3,3,'2018-04-08 14:44:20', 'delivered', 'Haeselerstraße', 32, 10345, default, 'credit_card'),
(4,4,'2018-04-09 14:44:20', 'delivered', 'Durlacher Straße', 42, 10456, default, default),
(5,5,'2018-04-10 14:44:20', 'delivered', 'Haeselerstraße', 52, 10567, default, 'paypal'),
(6,6,'2018-04-10 14:44:20', 'delivered', 'Adalbertstraße', 62, 10678, default, 'credit_card'),
(5,7,'2018-04-10 14:44:20', 'delivered', 'Durlacher Straße', 72, 10112, default, default),
(4,8,'2018-04-13 14:44:20', 'delivered', 'Adalbertstraße', 82, 10223, default, 'credit_card'),
(3,9,'2018-05-20 14:44:20', 'delivered', 'Straßmannstraße', 92, 10254, default, default),
(2,10,'2018-05-21 14:44:20', 'delivered', 'Haeselerstraße', 11, 10222, default, 'paypal'),
(1,11,'2018-05-21 14:44:20', 'canceled', 'Friedrichsruher Straße', 12, 10222, default, 'paypal'),
(2,12,'2018-05-22 14:44:20', 'delivered', 'Durlacher Straße', 22, 10222, default, default),
(3,13,'2018-05-22 14:44:20', 'delivered', 'Haeselerstraße', 22, 10222, default, 'credit_card'),
(4,14,'2018-05-22 14:44:20', 'delivered', 'Dachsberg', 99, 10222, default, default),
(5,15,'2018-05-23 14:44:20', 'delivered', 'Haeselerstraße', 32, 10222, default, 'credit_card'),
(6,16,'2018-06-23 14:44:20', 'delivered', 'Friedrichsruher Straße', 32, 10222, default, 'credit_card'),
(6,17,'2018-06-23 14:44:20', 'canceled', 'Adalbertstraße', 32, 10222, default, 'paypal'),
(5,18,'2018-06-24 14:44:20', 'delivered', 'Straßmannstraße', 12, 10222, default, default),
(4,19,'2018-06-27 14:44:20', 'delivered', 'Haeselerstraße', 55, 10222, default, default),
(3,10,'2018-06-27 14:44:20', 'delivered', 'Straßmannstraße', 66, 11222, default, 'paypal'),
(2,20,'2018-06-27 14:44:20', 'delivered', 'Haeselerstraße', 77, 10322, default, default),
(1,21,'2018-06-28 14:44:20', 'delivered', 'Dachsberg', 88, 10222, default, 'credit_card'),
(1,22,'2018-06-29 14:44:20', 'delivered', 'Straßmannstraße', 99, 10522, default, 'credit_card'),
(3,23,'2018-07-04 14:44:20', 'delivered', 'Haeselerstraße', 99, 10622, default, default),
(4,22,'2018-07-05 14:44:20', 'delivered', 'Dachsberg', 1, 10222, default, default),
(2,11,'2018-07-06 14:44:20', 'delivered', 'Straßmannstraße', 2, 10272, default, 'credit_card'),
(5,15,'2018-07-06 14:44:20', 'canceled', 'Adalbertstraße', 3, 10231, default, 'paypal'),
(6,3,'2018-07-07 14:44:20', 'delivered', 'Straßmannstraße', 4, 11992, default, default),
(4,3,'2018-07-08 14:44:20', 'delivered', 'Haeselerstraße', 5, 10222, default, 'paypal'),
(2,4,'2018-07-09 14:44:20', 'delivered', 'Adalbertstraße', 6, 10222, default, default),
(3,5,'2018-08-03 14:44:20', 'delivered', 'Dachsberg', 7, 10222, default, 'credit_card'),
(4,6,'2018-08-02 14:44:20', 'delivered', 'Friedrichsruher Straße', 8, 10222, default, 'paypal'),
(4,7,'2018-08-03 14:44:20', 'delivered', 'Dachsberg', 8, 10222, default, default),
(2,7,'2018-08-04 14:44:20', 'delivered', 'Haeselerstraße', 9, 10222, default, 'paypal'),
(1,8,'2018-08-05 14:44:20', 'delivered', 'Adalbertstraße', 19, 10222, default, default),
(4,18,'2018-08-05 14:44:20', 'delivered', 'Friedrichsruher Straße', 41, 10222, default, 'paypal'),
(4,18,'2018-08-05 14:44:20', 'delivered', 'Haeselerstraße', 41, 10222, default, 'credit_card'),
(2,23,'2018-08-05 14:44:20', 'delivered', 'Dachsberg', 77, 10222, default, 'paypal');


INSERT INTO order_details (order_id, dish_id, quantity) values
(1,1,5),
(1,2,1),
(2,3,1),
(2,4,2),
(3,5,2),
(4,6,1),
(5,4,3),
(6,7,4),
(7,1,3),
(8,8,2),
(8,17,2),
(9,24,3),
(10,12,2),
(11,25,1),
(11,2,1),
(11,22,1),
(11,19,4),
(12,24,2),
(12,22,1),
(13,22,1),
(14,21,3),
(14,20,2),
(15,29,1),
(15,32,5),
(16,31,4),
(16,21,2),
(16,28,1),
(16,7,4),
(17,2,5),
(17,2,2),
(18,2,1),
(18,16,1),
(18,2,3),
(19,2,2),
(20,17,2),
(21,2,1),
(21,2,3),
(22,2,1),
(22,19,2),
(23,2,3),
(23,2,2),
(23,2,3),
(24,2,2),
(25,2,3),
(26,2,3),
(27,2,3),
(27,2,3),
(28,2,3),
(29,2,3),
(30,2,1),
(30,2,1),
(30,2,1),
(31,2,2),
(31,2,2),
(32,2,1),
(32,2,1),
(33,2,3),
(33,2,3),
(34,2,1),
(35,2,3),
(35,2,3),
(36,2,1),
(36,2,3),
(37,2,1),
(37,2,3),
(38,2,1),
(38,2,1);



