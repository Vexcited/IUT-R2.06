CREATE SCHEMA blog;

CREATE TABLE blog.articles (
    article_id SERIAL PRIMARY KEY,
    author TEXT,
    title TEXT NOT NULL,
    body TEXT
);
