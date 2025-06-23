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
    "number" TEXT NOT NULL,
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

INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('c2f31c84-5a26-4dda-a76a-abc3ce83e3a0', 'str_e2d71a54', 'str_ea58be8f', FALSE);
INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('7cd83341-661f-433c-9737-8e3650634e3f', 'str_1d22c28c', 'str_6490cb85', FALSE);
INSERT INTO "actor"."member" ("id", "name", "hint", "is_active") VALUES ('55a19059-57b1-44e3-a55c-fcaa4d17b43f', 'str_4030851c', 'str_b51e8505', TRUE);
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "id", "name", "hint", "is_active") VALUES ('d23b65db-ee50-4c19-aaa7-be034cb7f09a', '306c1efb-7fb5-400c-ae2d-16812f2d2d96', FALSE, 'c65ab199-0e9f-45c2-98da-71bed33227e7', 'str_861587fa', 'str_2ef42125', FALSE);
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "id", "name", "hint", "is_active") VALUES ('3c6b2198-da39-40d9-8575-e45d753db7da', '3bcc7f13-07b1-44c4-aca0-627cc0911d86', TRUE, '17e1d9bf-1134-4cc6-84bb-08a688a5fa19', 'str_d594ae45', 'str_8b27d18a', TRUE);
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "id", "name", "hint", "is_active") VALUES ('3ba6e491-e154-4944-88b1-94caaf6ce085', '7c980961-6d80-491d-87ed-cdc751ac114d', TRUE, 'c7a1376c-366c-4b0e-9a53-b6e692385b8f', 'str_ef285758', 'str_651bc6c4', TRUE);
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "id", "name", "hint", "is_active") VALUES ('thursday', 'str_56bcadf5', 'str_5db4c75b', 'dd6d475e-e714-4d7e-b8b9-fc018f861128', 'str_0548cc6e', 'str_52e9d150', TRUE);
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "id", "name", "hint", "is_active") VALUES ('wednesday', 'str_388518e2', 'str_73490099', '8f3c3803-61e7-48ff-b4e6-44bf339b54c8', 'str_7b7c2244', 'str_aa7fac64', FALSE);
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "id", "name", "hint", "is_active") VALUES ('friday', 'str_0013d7b4', 'str_be5552e9', '0384b9a7-ad17-43ba-bd4d-3e175bc51113', 'str_6c34d91a', 'str_8d1f9e7c', FALSE);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xb29689', '\x40d03e', '\x5c0d2d65488d0f9f2105', 29, '\xc107b8b1c5cc93c06a8902c9168e5f', 1566366824);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xe9dc52a372fdf11da00d', '\x27f08cfa7ef5cbf8bf73dadac8', '\xd22ea278d68407e066', 67, '\x0bcb8b910555dbff2297a3', 434429767);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xeea68b73711c1725fcde72cdf8c7', '\x3dc3f31f2a86af1ca0e748c326a1', '\x9ed3569cc3d2ff234aac', 12, '\x484e0e4e6e265d78bc3111d332', 805877745);
INSERT INTO "actor"."pass" ("number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('str_8bfb5816', 'virtual', 'expired', '2025-07-07 22:35:57', '2025-06-25 23:56:30', 'c2f31c84-5a26-4dda-a76a-abc3ce83e3a0', '2bc14b00-f4c2-48e7-9008-97878218750f', 'str_9fec5e75', 'str_f62b64c0', TRUE);
INSERT INTO "actor"."pass" ("number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('str_fb745afd', 'virtual', 'active', '2025-07-07 02:48:09', '2025-07-05 03:40:38', '7cd83341-661f-433c-9737-8e3650634e3f', 'c729e3ed-2172-4084-8d1d-6f1d9add2578', 'str_2946b4ef', 'str_e45e821f', TRUE);
INSERT INTO "actor"."pass" ("number", "type", "status", "issue_date", "expiry_date", "member_id", "id", "name", "hint", "is_active") VALUES ('str_081a9208', 'virtual', 'stolen', '2025-06-22 18:11:46', '2025-06-28 08:40:03', 'c2f31c84-5a26-4dda-a76a-abc3ce83e3a0', 'dc7f1634-377b-45e9-a921-9ac66f14e334', 'str_45a83f7d', 'str_0a60ff36', FALSE);
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('c2f31c84-5a26-4dda-a76a-abc3ce83e3a0', 'person', 'str_dea47f0e', 'str_6dd9bdfb');
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('55a19059-57b1-44e3-a55c-fcaa4d17b43f', 'person', 'str_5638cb60', 'str_3a646368');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('7cd83341-661f-433c-9737-8e3650634e3f', 'drone', 'str_cd74c504', 'str_b41f01a9');

INSERT INTO "contour"."spot" ("id", "name", "hint", "is_active") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', NULL, NULL, FALSE);
INSERT INTO "contour"."spot_ip" ("spot_id", "type", "host", "port") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', 'ip', 'office.sevenseals.ru', 5087);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', '77');
INSERT INTO "contour"."spot" ("id", "name", "hint", "is_active") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', NULL, NULL, FALSE);
INSERT INTO "contour"."spot_ip" ("spot_id", "type", "host", "port") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', 'ip', 'office.sevenseals.ru', 5086);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', '171');
INSERT INTO "contour"."spot" ("id", "name", "hint", "is_active") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', NULL, NULL, FALSE);
INSERT INTO "contour"."spot_com_port" ("spot_id", "type", "port_name", "baud_rate", "parity", "data_bits", "stop_bits", "read_timeout_ms", "write_timeout_ms") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', 'com_port', 'COM3', 19200, 'none', 8, 'one', 1000, 1000);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', '7');

INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('7b335e42-2c34-455b-8041-86111c50aac1', 'f9918759-9a99-40e9-9fbb-e06d57e07677', TRUE, NULL, '6102b44c-e253-479d-8dda-2c8bada596e1', 'Вход с улицы', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('4ba26900-7e80-4bb2-b916-38a24dd6a997', '26cf4711-9880-4a57-bcc5-6da0569df512', TRUE, NULL, 'b6ecb955-d757-4b03-8ae8-45c6fcc8efc7', 'Главный вход', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('4ba26900-7e80-4bb2-b916-38a24dd6a997', '4cb69f84-9d1c-4135-9421-e970054048da', TRUE, NULL, 'f1db5bb3-2d2a-47ba-83c2-c0dd6fe1a403', 'Вход в склад', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', '22bd61c5-967f-4457-82ce-573368774e71', TRUE, NULL, 'bec4e8e7-1711-43f6-aeb9-deac352912ba', 'Дверь', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', 'cd33e3e1-a977-45d8-bf81-2deacd978c52', TRUE, NULL, '4000fed0-cfdb-41e4-aaa5-5ebe280a0285', 'office.sevenseals.ru:5087', NULL, FALSE);
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "id", "name", "hint", "is_active") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', '336bb7c8-379f-44c0-9526-96077f4da03c', TRUE, NULL, 'e58442cd-7d81-4bb4-968f-5e5703815c52', 'office.sevenseals.ru:5086', NULL, FALSE);

INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('building', NULL, 'f9918759-9a99-40e9-9fbb-e06d57e07677', 'Семь Печатей HQ', 'Феодосийская, дом 1', FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('floor', 'f9918759-9a99-40e9-9fbb-e06d57e07677', '4ba26900-7e80-4bb2-b916-38a24dd6a997', 'Второй этаж', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('corridor', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '26cf4711-9880-4a57-bcc5-6da0569df512', 'Коридор', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '4cb69f84-9d1c-4135-9421-e970054048da', 'Склад', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '22bd61c5-967f-4457-82ce-573368774e71', 'Главный бухгалтер', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', 'cd33e3e1-a977-45d8-bf81-2deacd978c52', 'Учительская', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('room', '4ba26900-7e80-4bb2-b916-38a24dd6a997', '336bb7c8-379f-44c0-9526-96077f4da03c', 'Программисты', NULL, FALSE);
INSERT INTO "atlas"."zone" ("type", "parent_id", "id", "name", "hint", "is_active") VALUES ('external_area', NULL, '7b335e42-2c34-455b-8041-86111c50aac1', 'Внешний мир', NULL, FALSE);

