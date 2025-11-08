-- Запрашиваем данные о пользователях, имеющих блоги, где последний блог создан пользователем более чем час назад
SELECT
    u.id as creator_id,
    u.user_name as сreator,
    MIN(b.created_at) as first_blog_created_at,
    MAX(b.created_at) as last_blog_created_at,
    COUNT(b) as blogs_count

FROM users u
    LEFT JOIN blogs b ON u.id = b.creator_id

WHERE b.id IS NOT NULL
GROUP BY u.id, u.user_name
HAVING MAX(b.created_at) < now() - INTERVAL '1 hour'
ORDER BY сreator;

-- Запрашиваем подписки пользователя с ID = 3
SELECT
    b.id as blog_id,
    b.name as blog_name,
    COUNT(DISTINCT (l.user_id, l.post_id)) AS blog_likes_count,
    COUNT(DISTINCT s2.user_id) AS blog_subscribers_count

FROM subscriptions s
    JOIN blogs b ON b.id = s.blog_id
    LEFT JOIN posts p ON b.id = p.blog_id
    LEFT JOIN likes l ON l.post_id = p.id
    JOIN subscriptions s2 ON s2.blog_id = b.id

WHERE s.user_id = 3
GROUP BY b.id, b.name
ORDER BY b.name;