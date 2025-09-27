-- Вариант 7: Блог-платформа с подписками
-- Описание: Пользователи ведут блоги, публикуют посты. Другие пользователи могут подписываться на блоги, комментировать посты и ставить лайки.

CREATE TABLE IF NOT EXISTS "blogs" (
  "id" bigserial PRIMARY KEY,
  "name" varchar(200) NOT NULL DEFAULT '',
  "description" varchar(200) NOT NULL DEFAULT '',
  "creator_id" bigint NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "posts" (
  "id" bigserial PRIMARY KEY,
  "content" text NOT NULL DEFAULT '',
  "blog_id" bigint NOT NULL,
  "creator_id" bigint NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT now(),
  "reply_to_id" bigint DEFAULT null
);

CREATE TABLE IF NOT EXISTS "likes" (
  "user_id" bigint NOT NULL,
  "post_id" bigint NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, post_id)
);

CREATE TABLE IF NOT EXISTS "subscriptions" (
  "user_id" bigint NOT NULL,
  "blog_id" bigint NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, blog_id)
);

CREATE TABLE IF NOT EXISTS "users" (
  "id" bigserial PRIMARY KEY,
  "user_name" varchar(200),
  "created_at" timestamp NOT NULL DEFAULT now()
);

ALTER TABLE "posts" ADD FOREIGN KEY ("creator_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "posts" ADD FOREIGN KEY ("blog_id") REFERENCES "blogs" ("id") ON DELETE CASCADE;

ALTER TABLE "posts" ADD FOREIGN KEY ("reply_to_id") REFERENCES "posts" ("id") ON DELETE CASCADE;

ALTER TABLE "likes" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id") ON DELETE CASCADE;

ALTER TABLE "likes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "subscriptions" ADD FOREIGN KEY ("blog_id") REFERENCES "blogs" ("id") ON DELETE CASCADE;

ALTER TABLE "subscriptions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "blogs" ADD FOREIGN KEY ("creator_id") REFERENCES "users" ("id") ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_posts_blog_id       ON "posts" ("blog_id");
CREATE INDEX IF NOT EXISTS idx_posts_creator_id    ON "posts" ("creator_id");
CREATE INDEX IF NOT EXISTS idx_posts_reply_to_id   ON "posts" ("reply_to_id");

CREATE INDEX IF NOT EXISTS idx_likes_post_id       ON "likes" ("post_id");
CREATE INDEX IF NOT EXISTS idx_likes_user_id       ON "likes" ("user_id");

CREATE INDEX IF NOT EXISTS idx_subs_blog_id        ON "subscriptions" ("blog_id");
CREATE INDEX IF NOT EXISTS idx_subs_user_id        ON "subscriptions" ("user_id");