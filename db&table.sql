CREATE DATABASE ottos_diner;

Use ottos_diner;

CREATE TABLE sales (
customer_id VARCHAR(1),
order_date DATE,
product_id INTEGER
);

select * from sales;

INSERT INTO sales 
(customer_id, order_date, product_id)

Values ('A', '2021-01-01', 1),
	('A', '2021-01-01', 2),
	('A', '2021-01-07', 4),
	('A', '2021-01-10', 3),
	('A', '2021-01-11', 3),
	('A', '2021-01-11', 5),
	('B', '2021-01-01', 2),
	('B', '2021-01-02', 7),
	('B', '2021-01-04', 6),
	('B', '2021-01-11', 5),
	('B', '2021-01-16', 8),
	('B', '2021-02-01', 7),
	('C', '2021-01-01', 9),
	('C', '2021-01-01', 8),
	('C', '2021-01-07', 9);
    
    CREATE TABLE menu(
    product_id INTEGER, 
    product_name VARCHAR(8),
    price INTEGER
    );
    
    select * from menu;
    
INSERT INTO menu 
    (product_id, product_name, price)
    values 
    (1, 'sushi', 10),
    (2, 'curry', 15),
    (3, 'ramen', 12),
    (4, 'burger', 9),
    (5, 'pizza', 18),
    (6, 'hotdog', 7),
    (7, 'wings', 12),
    (8, 'chicken', 13),
    (9, 'fish', 11);
    
    CREATE TABLE members(
    customer_id VARCHAR(1),
    join_date DATE
    );
   
   INSERT INTO members 
   (customer_id, join_date)
   
   values 
   ('A', '2021-01-07'),
    ('B', '2021-01-09');
    
    