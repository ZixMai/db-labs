CREATE OR REPLACE FUNCTION user_insert_action()
RETURNS trigger AS $$
BEGIN
    CALL add_blog(NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trg_blog_insert
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION user_insert_action();


CREATE OR REPLACE FUNCTION trigger_blog_milestone_post()
RETURNS trigger AS $$
DECLARE
    sub_count bigint;
    creator bigint;
BEGIN
    SELECT COUNT(*) INTO sub_count
    FROM subscriptions
    WHERE blog_id = NEW.blog_id;

    RAISE NOTICE 'blog_id=%,   new_user_id=%,   sub_count=%',
                 NEW.blog_id, NEW.user_id, sub_count;

    -- Проверяю, что количество подписчиков степень десяти.
    IF sub_count > 0 AND sub_count::text ~ '^(1(0)+)$' THEN
        SELECT creator_id INTO creator
        FROM blogs
        WHERE id = NEW.blog_id;

        INSERT INTO posts(content, blog_id, creator_id)
        VALUES (
            'Блог преодолел порог в ' || sub_count || ' подписчиков! ' || sub_count || '-ый подписчик: '
                || (SELECT user_name FROM users WHERE id = NEW.user_id),
            NEW.blog_id,
            creator
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trg_subscription_insert
AFTER INSERT ON subscriptions
FOR EACH ROW
EXECUTE FUNCTION trigger_blog_milestone_post();
