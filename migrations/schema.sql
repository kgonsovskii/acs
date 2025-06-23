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
    "from_zone_id" UUID NOT NULL,
    "to_zone_id" UUID NOT NULL,
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

INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('def48e9c-0990-4f33-be2f-e920f6b194bf', 'str_8355f04b', 'str_f2503bed', FALSE);
INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('c4a945f1-d466-41f9-87ce-f3c402f39428', 'str_bcec5c69', 'str_f2b5ef18', TRUE);
INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('2278d116-676a-48c1-8699-65f4d63de471', 'str_f912a3d1', 'str_3c1b7389', FALSE);
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "id", "name", "hint", "is_active") VALUES ('8f6af4bc-2f08-476a-94dc-c7637925e2c9', 'd44a7406-7602-486c-9d74-af2e701da0f6', TRUE, 'f70ebfb8-ad7c-4d99-83d1-d0803a82d973', 'str_3cdf92b9', 'str_08fc94ff', TRUE);
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "id", "name", "hint", "is_active") VALUES ('745d6171-8303-431d-af4b-4c334c5732db', 'ab316737-cec9-401d-ac83-06a34bafc059', FALSE, '184f1555-03b6-47c2-94aa-e92179419ab5', 'str_2fb35220', 'str_7e18668d', FALSE);
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "id", "name", "hint", "is_active") VALUES ('4001653c-c7ed-4bf5-ae35-940c4f286d98', 'bff1bf6d-e90f-481a-a8bb-1a4431f6f0d5', TRUE, 'b2498fa4-9186-45a4-a79b-b2084e351758', 'str_179d921d', 'str_016b3842', TRUE);
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "id", "name", "hint", "is_active") VALUES ('thursday', 'str_27ebc3b8', 'str_3d4859d4', 'c9c0ed33-11fa-480d-a56a-2072127fb338', 'str_6d368652', 'str_3a049e48', TRUE);
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "id", "name", "hint", "is_active") VALUES ('saturday', 'str_d2c4366c', 'str_91d33646', '113c7b0b-9f88-415d-af51-fe0a368cf04c', 'str_731b8d99', 'str_bb8a341f', FALSE);
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "id", "name", "hint", "is_active") VALUES ('thursday', 'str_48c43e56', 'str_b882b8be', '568237eb-db57-44a3-b87d-a1ddeb4ce47c', 'str_d1ffc465', 'str_67084a7b', FALSE);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x0d1e65e781e1e320', '\x49161294d80f1c73d8601775f4', '\x5e', 87, '\x5f3c772b7a', 2088614791);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xe483407de1', '\x142acdc70d35', '\x2980edcfe3b5008a2857', 138, '\x668987900a5c2ef5757419', 1770863411);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xf6618474b8f8c9004cd316b3', '\x322f697411584e65c7d59be5', '\xf512134d762c1a3d8c4cf81506c426b8', 87, '\x74bac38fd8f327', 568522529);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('str_ab15d18c', 'physical', 'active', '2025-06-26 20:06:49', '2025-07-10 13:53:14', 'c4a945f1-d466-41f9-87ce-f3c402f39428', 'fefa4357-3fc8-4c48-b057-728ea0b66d9d', 'str_4e760e98', 'str_6190805e', TRUE);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('str_0c7fc8c8', 'card', 'stolen', '2025-06-30 22:06:38', '2025-07-13 21:31:07', '2278d116-676a-48c1-8699-65f4d63de471', 'b007149e-0da8-465c-ba4b-9503d4e734f1', 'str_61b8a204', 'str_6327d5fa', FALSE);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('str_2e21dd60', 'virtual', 'active', '2025-06-28 08:22:06', '2025-07-06 04:25:30', '2278d116-676a-48c1-8699-65f4d63de471', '7530f097-456e-4327-b2fb-386e7dad7d83', 'str_07174170', 'str_8daa95b8', TRUE);
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('2278d116-676a-48c1-8699-65f4d63de471', 'person', 'str_3bbf92b2', 'str_af8d22df');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('def48e9c-0990-4f33-be2f-e920f6b194bf', 'drone', 'str_1f5bff91', 'str_8131eda4');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('c4a945f1-d466-41f9-87ce-f3c402f39428', 'drone', 'str_4ee202ee', 'str_8e805b2a');

INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('db5a6024-eeb8-4c09-9314-86f8e4a04989', 'Person A', NULL, TRUE);
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('db5a6024-eeb8-4c09-9314-86f8e4a04989', 'person', 'PersonA@tss.com', NULL);
INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', 'Person B', NULL, TRUE);
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', 'person', 'PersonB@tss.com', NULL);

INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('000003C6A799', 'physical', 'active', '0001-01-01 00:00:00.000', NULL, 'db5a6024-eeb8-4c09-9314-86f8e4a04989', 'db5a6024-eeb8-4c09-9314-86f8e4a04989', NULL, NULL, TRUE);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('0000007B1B89', 'physical', 'stolen', '0001-01-01 00:00:00.000', NULL, '5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', '5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', NULL, NULL, TRUE);

INSERT INTO "contour"."spot" ("id", "name", "hint", "is_active") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', NULL, NULL, TRUE);
INSERT INTO "contour"."spot_ip" ("spot_id", "type", "host", "port") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', 'ip', 'office.sevenseals.ru', 5087);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', '77');
INSERT INTO "contour"."spot" ("id", "name", "hint", "is_active") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', NULL, NULL, TRUE);
INSERT INTO "contour"."spot_ip" ("spot_id", "type", "host", "port") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', 'ip', 'office.sevenseals.ru', 5086);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', '171');
INSERT INTO "contour"."spot" ("id", "name", "hint", "is_active") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', NULL, NULL, TRUE);
INSERT INTO "contour"."spot_com_port" ("spot_id", "type", "port_name", "baud_rate", "parity", "data_bits", "stop_bits", "read_timeout_ms", "write_timeout_ms") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', 'com_port', 'COM3', 19200, 'none', 8, 'one', 1000, 1000);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', '7');

INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('7b335e42-2c34-455b-8041-86111c50aac1', 'f9918759-9a99-40e9-9fbb-e06d57e07677', TRUE, NULL, '6102b44c-e253-479d-8dda-2c8bada596e1', 'Вход с улицы', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('4ba26900-7e80-4bb2-b916-38a24dd6a997', '26cf4711-9880-4a57-bcc5-6da0569df512', TRUE, NULL, 'b6ecb955-d757-4b03-8ae8-45c6fcc8efc7', 'Главный вход', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('4ba26900-7e80-4bb2-b916-38a24dd6a997', '4cb69f84-9d1c-4135-9421-e970054048da', TRUE, NULL, 'f1db5bb3-2d2a-47ba-83c2-c0dd6fe1a403', 'Вход в склад', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', '22bd61c5-967f-4457-82ce-573368774e71', TRUE, NULL, 'bec4e8e7-1711-43f6-aeb9-deac352912ba', 'Дверь', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', 'cd33e3e1-a977-45d8-bf81-2deacd978c52', TRUE, NULL, '4000fed0-cfdb-41e4-aaa5-5ebe280a0285', 'office.sevenseals.ru:5087', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', '336bb7c8-379f-44c0-9526-96077f4da03c', TRUE, NULL, 'e58442cd-7d81-4bb4-968f-5e5703815c52', 'office.sevenseals.ru:5086', NULL, FALSE);

INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('building', NULL, 'f9918759-9a99-40e9-9fbb-e06d57e07677', 'Seven Seals HQ', 'Feodosiyskaya, building 1', FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('floor', 'f9918759-9a99-40e9-9fbb-e06d57e07677', '4ba26900-7e80-4bb2-b916-38a24dd6a997', 'Second floor', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('corridor', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '26cf4711-9880-4a57-bcc5-6da0569df512', 'Corridor', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '4cb69f84-9d1c-4135-9421-e970054048da', 'Storage', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '22bd61c5-967f-4457-82ce-573368774e71', 'Chief Accountant', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', 'cd33e3e1-a977-45d8-bf81-2deacd978c52', 'Staff Room', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '336bb7c8-379f-44c0-9526-96077f4da03c', 'Programmers', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('external_area', NULL, '7b335e42-2c34-455b-8041-86111c50aac1', 'Outside World', NULL, FALSE);

