import random
import string
from datetime import datetime, timedelta

# Количество записей
NUM_USERS = 10
NUM_BLOGS = 5
NUM_POSTS = 20
NUM_COMMENTS = 30
NUM_LIKES = 40
NUM_SUBSCRIPTIONS = 20

def random_string(length=10):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def random_timestamp():
    now = datetime.now()
    delta = timedelta(days=random.randint(0, 365), seconds=random.randint(0, 86400))
    return (now - delta).strftime("%Y-%m-%d %H:%M:%S")

def values_list(rows):
    """Формирует VALUES (...),(...),(...);"""
    return ",\n".join(rows) + ";"

# ---------- TRUNCATE ----------
truncate_sql = """-- Очистка всех таблиц и сброс последовательностей
TRUNCATE TABLE
  comments,
  likes,
  subscriptions,
  posts,
  blogs,
  users
RESTART IDENTITY CASCADE;
"""

# ---------- USERS ----------
user_rows = []
for _ in range(NUM_USERS):
    username = random_string(8)
    created_at = random_timestamp()
    user_rows.append(f"('{username}', '{created_at}')")

users_sql = f"INSERT INTO users (user_name, created_at) VALUES\n{values_list(user_rows)}"

# ---------- BLOGS ----------
blog_rows = []
for _ in range(NUM_BLOGS):
    name = f"Blog_{random_string(5)}"
    desc = f"Description_{random_string(10)}"
    creator_id = random.randint(1, NUM_USERS)
    created_at = random_timestamp()
    blog_rows.append(f"('{name}', '{desc}', {creator_id}, '{created_at}')")

blogs_sql = f"INSERT INTO blogs (name, description, creator_id, created_at) VALUES\n{values_list(blog_rows)}"

# ---------- POSTS ----------
post_rows = []
for i in range(NUM_POSTS):
    content = f"Post content {random_string(15)}"
    blog_id = random.randint(1, NUM_BLOGS)
    creator_id = random.randint(1, NUM_USERS)
    created_at = random_timestamp()
    reply_to_id = "NULL" if random.random() < 0.8 or i == 0 else str(random.randint(1, i))
    post_rows.append(f"('{content}', {blog_id}, {creator_id}, '{created_at}', {reply_to_id})")

posts_sql = f"INSERT INTO posts (content, blog_id, creator_id, created_at, reply_to_id) VALUES\n{values_list(post_rows)}"

# ---------- COMMENTS ----------
comment_rows = []
for i in range(NUM_COMMENTS):
    content = f"Comment {random_string(10)}"
    post_id = random.randint(1, NUM_POSTS)
    created_at = random_timestamp()
    reply_to_id = "NULL" if random.random() < 0.8 or i == 0 else str(random.randint(1, i))
    comment_rows.append(f"('{content}', {post_id}, '{created_at}', {reply_to_id})")

comments_sql = f"INSERT INTO comments (content, post_id, created_at, reply_to_id) VALUES\n{values_list(comment_rows)}"

# ---------- LIKES ----------
likes = set()
while len(likes) < NUM_LIKES:
    likes.add((random.randint(1, NUM_USERS), random.randint(1, NUM_POSTS)))

like_rows = [f"({u}, {p}, '{random_timestamp()}')" for u, p in likes]
likes_sql = f"INSERT INTO likes (user_id, post_id, created_at) VALUES\n{values_list(like_rows)}"

# ---------- SUBSCRIPTIONS ----------
subs = set()
while len(subs) < NUM_SUBSCRIPTIONS:
    subs.add((random.randint(1, NUM_USERS), random.randint(1, NUM_BLOGS)))

sub_rows = [f"({u}, {b}, '{random_timestamp()}')" for u, b in subs]
subs_sql = f"INSERT INTO subscriptions (user_id, blog_id, created_at) VALUES\n{values_list(sub_rows)}"

# ---------- ВЫВОД ----------
print(truncate_sql)
print("\n-- USERS")
print(users_sql)
print("\n-- BLOGS")
print(blogs_sql)
print("\n-- POSTS")
print(posts_sql)
print("\n-- COMMENTS")
print(comments_sql)
print("\n-- LIKES")
print(likes_sql)
print("\n-- SUBSCRIPTIONS")
print(subs_sql)