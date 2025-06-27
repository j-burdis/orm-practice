CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username text,
    password text
);

CREATE TABLE IF NOT EXISTS messages (
    id SERIAL PRIMARY KEY,
    content text,
    message_time timestamp,
    user_id int,
    constraint fk_user foreign key(user_id)
        references users(id)
        on delete cascade
);

TRUNCATE TABLE messages, users RESTART IDENTITY CASCADE;

INSERT INTO users (username, password) VALUES ('jon', 'password');
INSERT INTO users (username, password) VALUES ('fred', 'password');

INSERT INTO messages (content, message_time, user_id) VALUES ('hi fred', '2024-06-27 10:30:00', 1);
INSERT INTO messages (content, message_time, user_id) VALUES ('hi jon', '2024-06-27 11:45:00', 2);
