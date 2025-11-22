-- Просто работа с юзером
INSERT INTO users (user_name, created_at) VALUES
('Non-generated user', now());

UPDATE users
SET user_name = 'Refactored non-generated user'
WHERE user_name = 'Non-generated user';

DELETE FROM users
WHERE user_name = 'Refactored non-generated user';


-- Продолжаем играться, но уже с 2 таблицами
INSERT INTO users (user_name, created_at) VALUES
('Non-generated user', now());

-- Захотелось подоставать значение сиквенсов, наверное плохая практика, но тут чистые эксперименты,
-- запускаю естественно весь SQL разом.
INSERT INTO blogs (name, description, creator_id, created_at) VALUES
('Non-generated blog', 'My amAzIng blog', currval('users_id_seq'), now());

UPDATE blogs
SET name = 'Amazing blog', description = 'Changed description'
WHERE id = currval('blogs_id_seq');

DELETE FROM blogs
WHERE id = currval('blogs_id_seq');