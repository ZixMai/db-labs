-- Тест триггера на создание стартового блога

SELECT * FROM blogs ORDER BY id DESC LIMIT 1;

INSERT INTO users (user_name) VALUES ('Александр Маёвский ' || gen_random_uuid());

SELECT * FROM blogs ORDER BY id DESC LIMIT 1;


-- Тест триггера на аудит
DELETE
FROM subscriptions
WHERE blog_id = 5;

SELECT * FROM posts WHERE blog_id = 5 ORDER BY id DESC LIMIT 1;

INSERT INTO subscriptions (user_id, blog_id) SELECT generate_series(1, 9), 5;
INSERT INTO subscriptions (user_id, blog_id) SELECT 10, 5;

SELECT * FROM posts WHERE blog_id = 5 ORDER BY id DESC LIMIT 1;


-- Тест функций
SELECT get_blog_sub_count(5);
CALL like_post(1, 1);
SELECT get_post_likes_count(1);
CALL like_post(1, 1)