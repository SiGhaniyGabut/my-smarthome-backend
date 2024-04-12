-- +micrate Up
CREATE TABLE switches (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  description VARCHAR,
  icon VARCHAR,
  pin INTEGER NOT NULL,
  pin_alias VARCHAR NOT NULL,
  mode VARCHAR NOT NULL, -- IN, OUT
  state INTEGER NOT NULL, -- 0, 1
  invert_state BOOLEAN NOT NULL, -- Determines if the state of the pin should be inverted.
  active BOOL NOT NULL,
  device_topic_channel VARCHAR NOT NULL,
  device_id BIGINT REFERENCES devices(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Create index
CREATE INDEX index_switches_on_device_id ON switches (device_id);

-- +micrate Down
DROP TABLE IF EXISTS switches;

-- Drop index
DROP INDEX IF EXISTS index_switches_on_device_id;
