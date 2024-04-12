-- +micrate Up
CREATE TABLE api_keys (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  key VARCHAR NOT NULL,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  device_id BIGINT REFERENCES devices(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Create index
CREATE INDEX index_api_keys_on_key ON api_keys (key);
CREATE INDEX index_api_keys_on_user_id ON api_keys (user_id);
CREATE INDEX index_api_keys_on_device_id ON api_keys (device_id);

-- +micrate Down
DROP TABLE IF EXISTS api_keys;

-- Drop index
DROP INDEX IF EXISTS index_api_keys_on_key;
DROP INDEX IF EXISTS index_api_keys_on_user_id;
DROP INDEX IF EXISTS index_api_keys_on_device_id;

