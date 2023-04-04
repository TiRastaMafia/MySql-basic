USE lesson_4;

-- Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, 
-- с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
-- (использование транзакции с выбором commit или rollback – обязательно).

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old LIKE users;

DROP PROCEDURE IF EXISTS relocate_users; 
DELIMITER // 
CREATE PROCEDURE relocate_users(   
user_id INT, 
OUT  tran_result varchar(100)) 

BEGIN

  DECLARE _rollback BIT DEFAULT b'0'; 
  DECLARE code varchar(100); 
  DECLARE error_string varchar(100);  
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
  BEGIN 
     SET _rollback = b'1'; 
     GET stacked DIAGNOSTICS CONDITION 1 
      code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT; 
  END; 

  START TRANSACTION;
  INSERT INTO users_old (id, lastname, firstname, email) 

  SELECT id, lastname, firstname, email
  FROM users 
  WHERE id = user_id;
  DELETE FROM users WHERE id = user_id ;
    
  IF _rollback THEN
    SET tran_result = CONCAT('УПС. Ошибка: ', code, ' Текст ошибки: ', error_string);
    ROLLBACK;
  ELSE
    SET tran_result = 'O K';
    COMMIT;
  END IF;    
 END //
DELIMITER ;

CALL relocate_users(8, @tran_result);
SELECT @tran_result;


-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- С 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".


DROP FUNCTION IF EXISTS hello; 
DELIMITER //
CREATE FUNCTION hello()
RETURNS TINYTEXT NOT DETERMINISTIC NO SQL
BEGIN
  DECLARE hour INT;
  SET hour = HOUR(NOW());
  CASE
    WHEN hour BETWEEN 0 AND 5 THEN RETURN "Доброй ночи";
    WHEN hour BETWEEN 6 AND 11 THEN RETURN "Доброе утро";
    WHEN hour BETWEEN 12 AND 17 THEN RETURN "Добрый день";
    WHEN hour BETWEEN 18 AND 23 THEN RETURN "Добрый вечер";
  END CASE;
END//
DELIMITER ;
SELECT TIME(NOW()), hello();




-- 3. (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, communities и messages в таблицу logs помещается время и дата
-- создания записи, название таблицы, идентификатор первичного ключа.

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
  append_dt DATETIME DEFAULT CURRENT_TIMESTAMP,
  append_tn VARCHAR (255),
  pk_id INT UNSIGNED NOT NULL
  ) ENGINE ARCHIVE;

DROP PROCEDURE IF EXISTS append_logs;
delimiter //
CREATE PROCEDURE append_logs (
  tn VARCHAR (255),
  id INT
)
BEGIN
  INSERT INTO logs (append_tn, pk_id) VALUES (tn, id);
END //
delimiter ;

DROP TRIGGER IF EXISTS log_appending_from_users;
delimiter $$
CREATE TRIGGER log_appending_from_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
  CALL append_logs('users', NEW.id);
END $$
delimiter ;

DROP TRIGGER IF EXISTS log_appending_from_communities;
delimiter //
CREATE TRIGGER log_appending_from_communities
AFTER INSERT ON communities
FOR EACH ROW
BEGIN
  CALL append_logs('communities', NEW.id);
END //
delimiter ;

DROP TRIGGER IF EXISTS log_appending_from_messages;
delimiter //
CREATE TRIGGER log_appending_from_messages
AFTER INSERT ON messages
FOR EACH ROW
BEGIN
  CALL append_logs('messages', NEW.id);
END //
delimiter ;

-- Проверяем работу триггеров
INSERT INTO users (id, firstname, lastname, email) VALUES (13,
  'Ivan', 'Petrov', '13@ya.ru');
SELECT * FROM users;
SELECT * FROM logs;

INSERT INTO communities (id, name) VALUES (55, 'Iliya');
SELECT * FROM communities;
SELECT * FROM logs;

INSERT INTO messages (id, from_user_id, to_user_id, body, created_at) VALUES (5,
  '4', '6', '1cbdgndgs@ya.ru', '2021-01-14 23:00:04');
SELECT * FROM messages ;
SELECT * FROM logs;
