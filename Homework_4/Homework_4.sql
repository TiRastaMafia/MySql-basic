USE lesson_4;

-- 1.Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
SELECT COUNT(*) AS 'Общее количество' FROM likes WHERE media_id IN (SELECT id FROM media WHERE user_id IN (SELECT user_id FROM profiles WHERE (TIMESTAMPDIFF(YEAR, birthday, NOW())< 12)));

-- 2. Определить кто больше поставил лайков (всего): мужчины или женщины.
SELECT CASE (gender)
        WHEN 'm' THEN 'мужчины'
        WHEN 'f' THEN 'женщины'
      END AS 'кто больше поставил лайков', COUNT(*) as 'количество лайков'
FROM profiles AS p 
JOIN
likes AS l 
WHERE l.user_id = p.user_id
GROUP BY gender 
LIMIT 1;

-- 3. Вывести всех пользователей, которые не отправляли сообщения.
SELECT id, firstname, lastname
FROM users
WHERE id NOT IN (SELECT from_user_id FROM messages group by from_user_id);