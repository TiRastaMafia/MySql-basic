-- DROP DATABASE IF EXISTS homework_1;
CREATE DATABASE homework_1;
USE homework_1;

INSERT INTO mobile_phones (product_name, manufacturer, product_count, price)
VALUES
('iPhone X', 'Apple', 3, 76000),
('iPhone 8', 'Apple', 2, 51000),
('Galaxy S9', 'Samsung', 2, 56000),
('Galaxy S8', 'Samsung', 1, 41000),
('P20 Pro', 'Huawei', 5, 36000);

SELECT product_name, manufacturer, product_count, price 
FROM mobile_phones;
SELECT product_name, manufacturer, price 
FROM mobile_phones 
WHERE product_count > 2;
SELECT product_name, manufacturer, product_count, price 
FROM mobile_phones 
WHERE manufacturer = 'Samsung';
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones 
WHERE product_name 
LIKE "iPhone%" OR manufacturer 
LIKE 'iPhone%';
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones 
WHERE product_name 
LIKE "Samsung%" OR manufacturer LIKE 'Samsung%';
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones 
WHERE product_name REGEXP '[0-9]' OR manufacturer LIKE '[0-9]';
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones 
WHERE product_name REGEXP '8' OR manufacturer LIKE '8';

