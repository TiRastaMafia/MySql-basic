USE lesson_4;

-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.

CREATE OR REPLACE VIEW new_view AS
	SELECT CONCAT(lastname, ' ' ,firstname) AS 'ФИО', hometown, gender
	FROM users Join profiles ON users.id = profiles.user_id
	WHERE TIMESTAMPDIFF(YEAR, profiles.birthday, NOW()) < 20; 

SELECT ФИО, hometown, gender
FROM new_view;

-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователь, 
-- указав указать имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным количеством сообщений) .
-- (используйте DENSE_RANK)

WITH
	cte_result AS (SELECT CONCAT(lastname, ' ' ,firstname) AS 'ФИО', COUNT(from_user_id) AS `Количество сообщений` 
					FROM messages JOIN users ON messages.from_user_id = users.id GROUP BY users.id)
SELECT ФИО, `Количество сообщений`, 
DENSE_RANK() OVER(ORDER BY `Количество сообщений` DESC) AS Ranking
FROM cte_result;

-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и найдите разницу дат отправления между соседними сообщениями,
-- получившегося списка. (используйте LEAD или LAG)

SELECT body, created_at, 
TIMESTAMPDIFF(MINUTE,  LAG(created_at, 1, 0) OVER(ORDER BY created_at), created_at) AS lag_diff,
TIMESTAMPDIFF(MINUTE,  created_at, LEAD(created_at, 1, 0) OVER(ORDER BY created_at)) AS lead_diff
FROM messages
ORDER BY created_at;



