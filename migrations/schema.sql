\encoding UTF8
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'tss') THEN
      CREATE USER tss WITH PASSWORD '123' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;
   END IF;
END$$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'acs') THEN
      CREATE DATABASE acs OWNER tss ENCODING 'UTF8' LC_COLLATE='ru_RU.UTF-8' LC_CTYPE='ru_RU.UTF-8' TEMPLATE template0;
   END IF;
END$$;

ALTER DATABASE acs OWNER TO tss;
GRANT ALL PRIVILEGES ON DATABASE acs TO tss;
GRANT CREATE ON DATABASE acs TO tss;

\c acs tss

CREATE SCHEMA IF NOT EXISTS "actor" AUTHORIZATION tss;
CREATE SCHEMA IF NOT EXISTS "atlas" AUTHORIZATION tss;
CREATE SCHEMA IF NOT EXISTS "codex" AUTHORIZATION tss;
CREATE SCHEMA IF NOT EXISTS "contour" AUTHORIZATION tss;

-- Enum tables
CREATE TABLE IF NOT EXISTS "atlas"."zone_type" (
    "name" TEXT PRIMARY KEY,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "codex"."day_of_week" (
    "name" TEXT PRIMARY KEY,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "actor"."pass_type" (
    "name" TEXT PRIMARY KEY,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "actor"."pass_status" (
    "name" TEXT PRIMARY KEY,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "actor"."member_type" (
    "name" TEXT PRIMARY KEY,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "contour"."channel_type" (
    "name" TEXT PRIMARY KEY,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "contour"."com_port_parity" (
    "name" TEXT PRIMARY KEY,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "contour"."com_port_stop_bits" (
    "name" TEXT PRIMARY KEY,
    "description" TEXT
);

-- Regular tables
CREATE TABLE "actor"."member" (
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "atlas"."zone" (
    "type" TEXT NOT NULL,
    "parent_id" UUID NULL,
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "codex"."route_rule" (
    "from_zone_id" UUID NOT NULL,
    "to_zone_id" UUID NOT NULL,
    "is_bidirectional" BOOLEAN NOT NULL,
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "codex"."time_zone_rule" (
    "day_of_week" TEXT NOT NULL,
    "start_time" TEXT NOT NULL,
    "end_time" TEXT NOT NULL,
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "contour"."event_log" (
    "ch" BYTEA NOT NULL,
    "controller_timestamp" BYTEA NOT NULL,
    "timestamp" BYTEA NOT NULL,
    "addr" SMALLINT NOT NULL,
    "data" BYTEA NOT NULL,
    "id" SERIAL PRIMARY KEY NOT NULL
);

CREATE TABLE "contour"."spot" (
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "actor"."pass" (
    "key_number" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "issue_date" TIMESTAMP NOT NULL,
    "expiry_date" TIMESTAMP NULL,
    "member_id" UUID NULL REFERENCES "actor"."member"("id"),
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "atlas"."transit" (
    "from_zone_id" UUID NOT NULL REFERENCES "atlas"."zone"("id"),
    "to_zone_id" UUID NOT NULL REFERENCES "atlas"."zone"("id"),
    "is_bidirectional" BOOLEAN NOT NULL,
    "spot_id" UUID NULL REFERENCES "contour"."spot"("id"),
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL
);

-- Polymorphic tables
CREATE TABLE IF NOT EXISTS "actor"."member_person" (
    "member_id" UUID REFERENCES "actor"."member"("id"),
    "type" TEXT NOT NULL,
    "email" TEXT NULL,
    "phone" TEXT NULL
);

CREATE TABLE IF NOT EXISTS "actor"."member_drone" (
    "member_id" UUID REFERENCES "actor"."member"("id"),
    "type" TEXT NOT NULL,
    "serial_number" TEXT NULL,
    "firmware_version" TEXT NULL
);

CREATE TABLE IF NOT EXISTS "contour"."spot_ip" (
    "spot_id" UUID REFERENCES "contour"."spot"("id"),
    "type" TEXT NOT NULL,
    "host" TEXT NOT NULL,
    "port" INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS "contour"."spot_com_port" (
    "spot_id" UUID REFERENCES "contour"."spot"("id"),
    "type" TEXT NOT NULL,
    "port_name" TEXT NOT NULL,
    "baud_rate" INTEGER NOT NULL,
    "parity" TEXT NOT NULL,
    "data_bits" INTEGER NOT NULL,
    "stop_bits" TEXT NOT NULL,
    "read_timeout_ms" INTEGER NOT NULL,
    "write_timeout_ms" INTEGER NOT NULL
);

-- Child tables
CREATE TABLE IF NOT EXISTS "contour"."spot_address" (
    "spot_id" UUID REFERENCES "contour"."spot"("id"),
    "address" TEXT NOT NULL
);

-- Indexes
CREATE INDEX IF NOT EXISTS "idx_pass_key_number" ON "actor"."pass"("key_number");

-- Enum data population
INSERT INTO "atlas"."zone_type" ("name", "description") VALUES ('building', 'Building') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name", "description") VALUES ('floor', 'Floor') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name", "description") VALUES ('room', 'Room') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name", "description") VALUES ('corridor', 'Corridor') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name", "description") VALUES ('lobby', 'Lobby') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name", "description") VALUES ('elevator', 'Elevator') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name", "description") VALUES ('staircase', 'Staircase') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name", "description") VALUES ('parking', 'Parking') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name", "description") VALUES ('external_area', 'ExternalArea') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name", "description") VALUES ('sunday', 'Sunday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name", "description") VALUES ('monday', 'Monday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name", "description") VALUES ('tuesday', 'Tuesday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name", "description") VALUES ('wednesday', 'Wednesday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name", "description") VALUES ('thursday', 'Thursday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name", "description") VALUES ('friday', 'Friday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name", "description") VALUES ('saturday', 'Saturday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."pass_type" ("name", "description") VALUES ('physical', 'Physical') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."pass_type" ("name", "description") VALUES ('virtual', 'Virtual') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."pass_type" ("name", "description") VALUES ('card', 'Card') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."pass_type" ("name", "description") VALUES ('mobile', 'Mobile') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."pass_status" ("name", "description") VALUES ('active', 'Active') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."pass_status" ("name", "description") VALUES ('lost', 'Lost') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."pass_status" ("name", "description") VALUES ('stolen', 'Stolen') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."pass_status" ("name", "description") VALUES ('expired', 'Expired') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."pass_status" ("name", "description") VALUES ('deactivated', 'Deactivated') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."member_type" ("name", "description") VALUES ('person', 'Person') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."member_type" ("name", "description") VALUES ('drone', 'Drone') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."channel_type" ("name", "description") VALUES ('ip', 'Ip') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."channel_type" ("name", "description") VALUES ('com_port', 'ComPort') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."com_port_parity" ("name", "description") VALUES ('none', 'None') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."com_port_parity" ("name", "description") VALUES ('odd', 'Odd') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."com_port_parity" ("name", "description") VALUES ('even', 'Even') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."com_port_parity" ("name", "description") VALUES ('mark', 'Mark') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."com_port_parity" ("name", "description") VALUES ('space', 'Space') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."com_port_stop_bits" ("name", "description") VALUES ('none', 'None') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."com_port_stop_bits" ("name", "description") VALUES ('one', 'One') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."com_port_stop_bits" ("name", "description") VALUES ('two', 'Two') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."com_port_stop_bits" ("name", "description") VALUES ('one_point_five', 'OnePointFive') ON CONFLICT ("name") DO NOTHING;

-- Enum foreign keys
ALTER TABLE "atlas"."zone" ADD CONSTRAINT "fk_zone_type" FOREIGN KEY ("type") REFERENCES "atlas"."zone_type"("name");
ALTER TABLE "codex"."time_zone_rule" ADD CONSTRAINT "fk_time_zone_rule_day_of_week" FOREIGN KEY ("day_of_week") REFERENCES "codex"."day_of_week"("name");
ALTER TABLE "actor"."pass" ADD CONSTRAINT "fk_pass_type" FOREIGN KEY ("type") REFERENCES "actor"."pass_type"("name");
ALTER TABLE "actor"."pass" ADD CONSTRAINT "fk_pass_status" FOREIGN KEY ("status") REFERENCES "actor"."pass_status"("name");
ALTER TABLE "actor"."member_person" ADD CONSTRAINT "fk_member_person_type" FOREIGN KEY ("type") REFERENCES "actor"."member_type"("name");
ALTER TABLE "actor"."member_drone" ADD CONSTRAINT "fk_member_drone_type" FOREIGN KEY ("type") REFERENCES "actor"."member_type"("name");
ALTER TABLE "contour"."spot_ip" ADD CONSTRAINT "fk_spot_ip_type" FOREIGN KEY ("type") REFERENCES "contour"."channel_type"("name");
ALTER TABLE "contour"."spot_com_port" ADD CONSTRAINT "fk_spot_com_port_type" FOREIGN KEY ("type") REFERENCES "contour"."channel_type"("name");
ALTER TABLE "contour"."spot_com_port" ADD CONSTRAINT "fk_spot_com_port_parity" FOREIGN KEY ("parity") REFERENCES "contour"."com_port_parity"("name");
ALTER TABLE "contour"."spot_com_port" ADD CONSTRAINT "fk_spot_com_port_stop_bits" FOREIGN KEY ("stop_bits") REFERENCES "contour"."com_port_stop_bits"("name");

INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('45c8352e-3cb0-4dab-96dd-9cb7093e2a85', 'str_65816c5c', 'str_00e389d7', TRUE);
INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('b71619b9-d4b8-467a-a9b6-2a4dae128688', 'str_53f96906', 'str_8b9a1dc2', FALSE);
INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('e534be14-001f-47c4-9f04-f5621a58ddec', 'str_7463860e', 'str_dbe26fba', TRUE);
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "id", "name", "hint", "is_active") VALUES ('d83ece25-4f13-4ab4-884a-61690f54db07', '53eed3f3-5181-4bd2-a930-21fb465d02c5', FALSE, '95e5e1d6-d25f-4bd5-b399-da48f44df410', 'str_a1919b58', 'str_4f875515', FALSE);
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "id", "name", "hint", "is_active") VALUES ('3b438ddc-7e1c-4df2-a03f-928bff735de0', 'd413ba0f-61c3-4f82-b81b-1b9fa5c34a1c', TRUE, '660daf3d-3eba-4b0f-8b2c-d673411f5cde', 'str_87a65293', 'str_57756832', FALSE);
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "id", "name", "hint", "is_active") VALUES ('f648b85d-eacd-46a9-9d96-e35c1feb7f34', '2ac1018d-fec7-4786-8f03-78435b07067d', FALSE, 'a45e99ce-a709-4838-b03e-5c01850597d5', 'str_f818cfaa', 'str_54ec155d', TRUE);
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "id", "name", "hint", "is_active") VALUES ('wednesday', 'str_7c08e634', 'str_9bc29770', 'a3e09263-5ea8-4a40-b3c3-a1282d002801', 'str_8930f66e', 'str_d99c59b4', FALSE);
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "id", "name", "hint", "is_active") VALUES ('tuesday', 'str_79647fea', 'str_c8357d11', 'e9d5484d-4573-4547-9803-02e3cbb22733', 'str_9d2a1ae1', 'str_4c0e4915', FALSE);
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "id", "name", "hint", "is_active") VALUES ('saturday', 'str_724debd1', 'str_a16e52fa', '294cc79e-91a9-4089-9d2e-2df5b096a309', 'str_51782dbe', 'str_3fc2a633', TRUE);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x861464e1b704b4741e43708bfd84', '\xc3f137ff877f63f6783bac80a5da', '\xe43cb8f739', 185, '\x35d806ce92a0b7', 1126415403);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x9c1020a1d0b8b927', '\x73fa4db0a0e10e1e555e', '\x80736c4b948e3808e77324cc43cb', 35, '\x6fc5a3d0d3', 1412835035);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x937e87aa647ead6f1ee78f14ee4980', '\x3381', '\xa2', 12, '\x4b16', 57404383);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('str_95717cc5', 'mobile', 'deactivated', '2025-07-16 14:32:54', '2025-07-02 00:30:23', 'e534be14-001f-47c4-9f04-f5621a58ddec', '218f18a4-bfde-4d77-8877-c73a5058d22d', 'str_313cea5d', 'str_26064322', FALSE);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('str_3f4931da', 'card', 'stolen', '2025-07-02 22:46:21', '2025-07-05 13:01:25', 'e534be14-001f-47c4-9f04-f5621a58ddec', 'a80bcc9e-b189-4330-8eda-3aa085a9df61', 'str_9b648ec9', 'str_a6512e46', FALSE);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('str_0da5b0f3', 'physical', 'lost', '2025-07-13 05:17:36', '2025-07-18 22:00:42', 'b71619b9-d4b8-467a-a9b6-2a4dae128688', 'eea2f600-b9b6-46c6-9c7f-3925abb64a1c', 'str_4204f7bb', 'str_ad03a816', FALSE);
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('e534be14-001f-47c4-9f04-f5621a58ddec', 'person', 'str_9c034ffd', 'str_4d3ba875');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('45c8352e-3cb0-4dab-96dd-9cb7093e2a85', 'drone', 'str_cfcfc39e', 'str_f8edda54');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('b71619b9-d4b8-467a-a9b6-2a4dae128688', 'drone', 'str_2e4e8fd5', 'str_bde96f22');

INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('db5a6024-eeb8-4c09-9314-86f8e4a04989', 'Person A', NULL, TRUE);
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('db5a6024-eeb8-4c09-9314-86f8e4a04989', 'person', 'PersonA@tss.com', NULL);
INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', 'Person B', NULL, TRUE);
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', 'person', 'PersonB@tss.com', NULL);

INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('000003C6A799', 'physical', 'active', '0001-01-01 00:00:00.000', NULL, 'db5a6024-eeb8-4c09-9314-86f8e4a04989', 'db5a6024-eeb8-4c09-9314-86f8e4a04989', NULL, NULL, TRUE);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('0000007B1B89', 'physical', 'stolen', '0001-01-01 00:00:00.000', NULL, '5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', '5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', NULL, NULL, TRUE);

INSERT INTO "contour"."spot" ("id", "name", "hint", "is_active") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', 'classrom', NULL, TRUE);
INSERT INTO "contour"."spot_ip" ("spot_id", "type", "host", "port") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', 'ip', 'office.sevenseals.ru', 5087);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', '77');
INSERT INTO "contour"."spot" ("id", "name", "hint", "is_active") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', 'progers', NULL, TRUE);
INSERT INTO "contour"."spot_ip" ("spot_id", "type", "host", "port") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', 'ip', 'office.sevenseals.ru', 5086);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', '171');
INSERT INTO "contour"."spot" ("id", "name", "hint", "is_active") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', 'progers-comport', NULL, TRUE);
INSERT INTO "contour"."spot_com_port" ("spot_id", "type", "port_name", "baud_rate", "parity", "data_bits", "stop_bits", "read_timeout_ms", "write_timeout_ms") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', 'com_port', 'COM3', 19200, 'none', 8, 'one', 1000, 1000);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', '7');

INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('7b335e42-2c34-455b-8041-86111c50aac1', 'f9918759-9a99-40e9-9fbb-e06d57e07677', TRUE, NULL, '6102b44c-e253-479d-8dda-2c8bada596e1', 'Вход с улицы', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('4ba26900-7e80-4bb2-b916-38a24dd6a997', '26cf4711-9880-4a57-bcc5-6da0569df512', TRUE, NULL, 'b6ecb955-d757-4b03-8ae8-45c6fcc8efc7', 'Главный вход', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('4ba26900-7e80-4bb2-b916-38a24dd6a997', '4cb69f84-9d1c-4135-9421-e970054048da', TRUE, NULL, 'f1db5bb3-2d2a-47ba-83c2-c0dd6fe1a403', 'Вход в склад', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', '22bd61c5-967f-4457-82ce-573368774e71', TRUE, NULL, 'bec4e8e7-1711-43f6-aeb9-deac352912ba', 'Дверь', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', 'cd33e3e1-a977-45d8-bf81-2deacd978c52', TRUE, NULL, '4000fed0-cfdb-41e4-aaa5-5ebe280a0285', 'office.sevenseals.ru:5087', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', '336bb7c8-379f-44c0-9526-96077f4da03c', TRUE, NULL, 'e58442cd-7d81-4bb4-968f-5e5703815c52', 'office.sevenseals.ru:5086', NULL, FALSE);

INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('building', '7b335e42-2c34-455b-8041-86111c50aac1', 'f9918759-9a99-40e9-9fbb-e06d57e07677', 'Seven Seals HQ', 'Feodosiyskaya, building 1', FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('floor', 'f9918759-9a99-40e9-9fbb-e06d57e07677', '4ba26900-7e80-4bb2-b916-38a24dd6a997', 'Second floor', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('corridor', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '26cf4711-9880-4a57-bcc5-6da0569df512', 'Corridor', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '4cb69f84-9d1c-4135-9421-e970054048da', 'Storage', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '22bd61c5-967f-4457-82ce-573368774e71', 'Chief Accountant', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', 'cd33e3e1-a977-45d8-bf81-2deacd978c52', 'Staff Room', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '336bb7c8-379f-44c0-9526-96077f4da03c', 'Programmers', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('external_area', NULL, '7b335e42-2c34-455b-8041-86111c50aac1', 'Outside World', NULL, FALSE);

