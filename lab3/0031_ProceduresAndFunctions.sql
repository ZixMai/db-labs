CREATE OR REPLACE PROCEDURE add_blog(IN user_id BIGINT)
AS $$
BEGIN
    INSERT INTO blogs (name, description, creator_id, created_at)
    VALUES (
        'Блог ' || (SELECT user_name FROM users WHERE id = user_id), '', user_id, now()
    );

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Пользователь не существует';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_blog_sub_count(id BIGINT)
RETURNS int STABLE AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM subscriptions where blog_id = id);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_post_likes_count(id BIGINT)
RETURNS int STABLE AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM likes where post_id = id);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE like_post(IN p_user_id bigint, IN p_post_id bigint)
AS $$
BEGIN
    INSERT INTO likes(user_id, post_id)
    VALUES (p_user_id, p_post_id);

EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Лайк уже стоит на этом посте';

    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Пост или пользователь не существует';
END;
$$ LANGUAGE plpgsql;