-- +micrate Up
CREATE TABLE devices (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  uuid VARCHAR UNIQUE NOT NULL,
  mac VARCHAR UNIQUE NOT NULL,
  active BOOL NOT NULL,
  topic_channel VARCHAR NOT NULL,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Create index
CREATE INDEX index_devices_on_uuid ON devices (uuid);
CREATE INDEX index_devices_on_mac ON devices (mac);
CREATE INDEX index_devices_on_user_id ON devices (user_id);

-- +micrate Down
DROP TABLE IF EXISTS devices;

-- Drop index
DROP INDEX IF EXISTS index_devices_on_uuid;
DROP INDEX IF EXISTS index_devices_on_mac;
DROP INDEX IF EXISTS index_devices_on_user_id;
