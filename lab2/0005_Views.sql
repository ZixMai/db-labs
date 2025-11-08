-- Юзеры с блогами живыми более чем час и их статистика
CREATE VIEW v_users_with_confirmed_blogs AS

SELECT
    u.id as creator_id,
    u.user_name AS creator,
    MIN(b.created_at) AS first_blog_created_at,
    MAX(b.created_at) AS last_blog_created_at,
    COUNT(b.id) AS blogs_count

FROM users u
    LEFT JOIN blogs b ON u.id = b.creator_id

WHERE b.id IS NOT NULL
GROUP BY u.id, u.user_name
HAVING MAX(b.created_at) < now() - INTERVAL '1 hour'
ORDER BY creator;


-- Статистика по подпискам человека с наибольшим их количеством
CREATE VIEW v_top_user_blog_stats AS

SELECT
    b.id AS blog_id,
    b.name AS blog_name,
    COUNT(DISTINCT (l.user_id, l.post_id)) AS blog_likes_count,
    COUNT(DISTINCT s2.user_id) AS blog_subscribers_count

FROM subscriptions s
    JOIN blogs b ON b.id = s.blog_id
    LEFT JOIN posts p ON b.id = p.blog_id
    LEFT JOIN likes l ON l.post_id = p.id
    JOIN subscriptions s2 ON s2.blog_id = b.id

WHERE s.user_id = (
    SELECT user_id
    FROM subscriptions
    GROUP BY user_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
)

GROUP BY b.id, b.name
ORDER BY b.name;