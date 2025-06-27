# Two Tables Design Recipe Template

_Copy this recipe template to design and create two related database tables from a specification._

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:
# (analyse only the relevant part - here, the final line).

As a Maker
So that I can let people know what I am doing
I want to post a message (peep) to chitter

As a maker
So that I can see what others are saying
I want to see all peeps in reverse chronological order

As a Maker
So that I can better appreciate the context of a peep
I want to see the time at which it was made

As a Maker
So that I can post messages on Chitter as me
I want to sign up for Chitter
```

```
Nouns:

message (peep), time, sign up, user

Verbs:
post, see all peeps, see the time (of peep)

```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| users                 | username, password
| messages              | content, date + time

1. Name of the first table (always plural): `users` 

    Column names: `username`, `password`

2. Name of the second table (always plural): `mesages` 

    Column names: `content`, `date`

## 3. Decide the column types

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: users
id: SERIAL
username: text
password: text

Table: messages
id: SERIAL
content: text
date: timestamp
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
2. Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)

You'll then be able to say that:

1. **[A] has many [B]**
2. And on the other side, **[B] belongs to [A]**
3. In that case, the foreign key is in the table [B]

Replace the relevant bits in this example with your own:

```
# EXAMPLE

1. Can one user have many messages? YES
2. Can one message have many users? NO

-> Therefore,
-> An user HAS MANY messages
-> An message BELONGS TO an user

-> Therefore, the foreign key is on the messages table.
```

*If you can answer YES to the two questions, you'll probably have to implement a Many-to-Many relationship, which is more complex and needs a third table (called a join table).*

## 5. Write the SQL

```sql
-- EXAMPLE
-- file: albums_table.sql

-- Replace the table name, columm names and types.

-- Create the table without the foreign key first.
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username text,
  password text,
);

-- Then the table with the foreign key second.
CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  content text,
  message_time timestamp,
-- The foreign key name is always {other_table_singular}_id
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

```

## 6. Create the tables

```bash
psql -h 127.0.0.1 chitter < chitter.sql
```



# {{ NAME }} Route Design Recipe

_Copy this design recipe template to test-drive a plain-text Flask route._

## 1. Design the Route Signature

_Include the HTTP method, the path, and any query or body parameters._

```
# EXAMPLE

# Home route
GET /home

# Waving route
GET /wave?name=

# Submit message route
POST /submit
  name: string
  message: string
```

## 2. Create Examples as Tests

_Go through each route and write down one or more example responses._

_Remember to try out different parameter values._

_Include the status code and the response body._

```python
# EXAMPLE

# GET /messages
#  Expected response (200 OK):
"""
Page with list of messages (all)
"""

# GET /messages/new
#  Expected response (200 OK):
"""
Page with form to post new message
"""

# POST /submit
#  Parameters:
#    content: hello there
#    message: "timestamp"
#  Expected response (200 OK):
"""
User: hello there (at "timestamp")
"""

# POST /submit
#  Parameters:
#    content: None
#    message: "timestamp"
#  Expected response (200 OK):
"""
Error message to enter message content
"""
```

## 3. Test-drive the Route

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

Here's an example for you to start with:

```python
"""
GET /messages
  Expected response (200 OK):
  Displays list of messages
"""
def test_get_messages(web_client):
    response = web_client.get('/messages')
    assert response.status_code == 200
    assert response.data.decode('utf-8') == "Here are your messages"

@app.route('/messages', methods=['GET'])
def get_messages():
    return "Here are your messages"
"""

"""
def test_post_submit_message(web_client):
    response = web_client.post('/submit', data={
        'content': 'Hi there!',
        'message_time': '2024-06-27 10:30:00'
    })
    assert response.status_code == 200
    assert response.data.decode('utf-8') == 'You received message "Hi there!" at 2024-06-27 10:30:00'

@app.route('/submit', methods=['POST'])
def post_message():
    content = request.form['content']
    timestamp = request.form['message_time']
    return f"You received message \"{content}\" at {timestamp}"
```

