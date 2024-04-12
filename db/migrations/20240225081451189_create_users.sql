-- +micrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  email VARCHAR UNIQUE NOT NULL,
  uid VARCHAR UNIQUE NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Create index
CREATE INDEX index_users_on_email ON users (email);
CREATE INDEX index_users_on_uid ON users (uid);

-- +micrate Down
DROP TABLE IF EXISTS users;

-- Drop index
DROP INDEX IF EXISTS index_users_on_email;
DROP INDEX IF EXISTS index_users_on_uid;
