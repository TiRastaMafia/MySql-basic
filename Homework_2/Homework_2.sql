-- create new DB
CREATE DATABASE Homework_2;

-- activate new DB
USE Homework_2;

-- Используя операторы языка SQL, создайте табличку “sales”. Заполните ее данными.
CREATE TABLE sales
(
	id INT PRIMARY KEY auto_increment,
    order_date DATE,
    count_product INT
);

-- добавить данные в таблицу sales

INSERT sales (order_date, count_product)
VALUES
	("2023-03-05", 500), -- id = 1
    ("2023-03-04", 80), -- id = 2
    ("2023-03-01", 120), -- id=3
    ("2023-03-04", 300), -- id=4
    ("2023-03-02", 205), -- id=5
    ("2023-03-09", 318), -- id=6
    ("2023-03-08", 56); -- id=7
    


/* Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва : 
меньше 100 - Маленький заказ; от 100 до 300 - Средний заказ; больше 300 - Большой заказ. */

SELECT sales.id AS 'Продажи', sales.count_product AS 'Кол-во',
CASE 
    WHEN count_product < 100 THEN 'Маленький заказ'
    WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
    WHEN count_product > 300 THEN 'Большой заказ'
    ELSE 'Не определено'
  END AS 'Order type'  
FROM sales;


/* Создайте таблицу “orders”, заполните ее значениями. Выберите все заказы. 
В зависимости от поля order_status выведите столбец full_order_status: 
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED - «Order is cancelled» */

CREATE TABLE orders
(
	id INT PRIMARY KEY auto_increment,
	employee_id VARCHAR(3),
	amount DECIMAL(5,2),
	order_status VARCHAR(30)
);


INSERT orders (employee_id, amount, order_status)
VALUES
	("e03", 15.00, "OPEN"), 
    ("e01", 25.50, "OPEN"),
    ("e05", 100.70, "CLOSED"),
    ("e02", 22.18, "OPEN"),
    ("e04", 9.50, "CANCELLED"); 
    
-/* Выберите все заказы. В зависимости от поля order_status выведите столбец full_order_status: 
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED - «Order is cancelled» */

SELECT orders.id AS 'Номер',orders.employee_id AS "Работник", orders.amount AS "Кол-во", orders.order_status AS "Статус",
CASE 
    WHEN order_status = "OPEN" THEN 'Order is in open state'
    WHEN order_status = "CLOSED" THEN 'Order is closed'
    WHEN order_status = "CANCELLED" THEN 'Order is cancelled'
    ELSE 'Не определено'
  END AS 'Статус заказа'  
FROM orders;


-- Чем NULL отличается от 0?
-- Ответ: NULL это отсутсвие вообще значения как такового, а 0 это число или false (boolean значение, отрицание)