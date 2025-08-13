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
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL,
    "order" INTEGER NULL,
    "id" UUID PRIMARY KEY NOT NULL
);

CREATE TABLE "atlas"."zone" (
    "type" TEXT NOT NULL,
    "parent_id" UUID NULL,
    "design" TEXT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL,
    "order" INTEGER NULL,
    "id" UUID PRIMARY KEY NOT NULL
);

CREATE TABLE "codex"."route_rule" (
    "from_zone_id" UUID NOT NULL,
    "to_zone_id" UUID NOT NULL,
    "is_bidirectional" BOOLEAN NOT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL,
    "order" INTEGER NULL,
    "id" UUID PRIMARY KEY NOT NULL
);

CREATE TABLE "codex"."time_zone_rule" (
    "day_of_week" TEXT NOT NULL,
    "start_time" TEXT NOT NULL,
    "end_time" TEXT NOT NULL,
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL,
    "order" INTEGER NULL,
    "id" UUID PRIMARY KEY NOT NULL
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
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL,
    "order" INTEGER NULL,
    "id" UUID PRIMARY KEY NOT NULL
);

CREATE TABLE "actor"."pass" (
    "key_number" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "issue_date" TIMESTAMP NOT NULL,
    "expiry_date" TIMESTAMP NULL,
    "member_id" UUID NULL REFERENCES "actor"."member"("id"),
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL,
    "order" INTEGER NULL,
    "id" UUID PRIMARY KEY NOT NULL
);

CREATE TABLE "atlas"."transit" (
    "from_zone_id" UUID NOT NULL REFERENCES "atlas"."zone"("id"),
    "to_zone_id" UUID NOT NULL REFERENCES "atlas"."zone"("id"),
    "is_bidirectional" BOOLEAN NOT NULL,
    "spot_id" UUID NULL REFERENCES "contour"."spot"("id"),
    "name" TEXT NULL,
    "hint" TEXT NULL,
    "is_active" BOOLEAN NOT NULL,
    "order" INTEGER NULL,
    "id" UUID PRIMARY KEY NOT NULL
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

INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_dd2242a7', 'str_25646149', TRUE, 301812634, '562defb7-74b0-40ce-a099-9da54895fbf4');
INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_b3b8506e', 'str_0f8d343c', TRUE, 361386738, '707b4ee5-f0fb-4981-acf6-527b5255ead9');
INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_09701751', 'str_e9d4c643', TRUE, 46859328, '9035f56e-1621-4497-9237-fdb4df9770bf');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('433a59f2-4e9a-47a1-ae4d-2149e5ae41ec', '4579dc26-1e7c-4e2d-b9cd-9b13327ec530', FALSE, 'str_22c372a1', 'str_8a1ba30f', TRUE, 2072029972, 'cb3fd8c3-fdc6-446b-9a51-1cfc55ea5b82');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('94e1b558-2345-4ea8-bbe7-da9c09816eaf', 'e9be5a9d-1f22-4f6d-9d67-7960e00b4560', TRUE, 'str_5740b8cf', 'str_1da662a1', TRUE, 1864784771, '1352b080-b7e6-4e2f-9090-a36d1f828756');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('2859dd12-1bc4-48e3-b57c-6fb918dffaa5', 'd3637679-fd85-4756-bbd7-3c292f8ee1fb', TRUE, 'str_29b2eb9a', 'str_eb5c8eb7', FALSE, 398216295, '6ed61306-3461-4a6c-be13-a95a4a82f0b0');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('thursday', 'str_b5ff5fa6', 'str_9a3c1da7', 'str_7eac60ff', 'str_bf51d5ce', FALSE, 191740788, '40e72373-0ffd-407f-8ea0-07ccc8286737');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('friday', 'str_12ea39e2', 'str_a49ee189', 'str_6ff9da85', 'str_8876aae9', FALSE, 1263129380, '60e103e8-1bf9-43dd-9506-c6125ebb491b');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('tuesday', 'str_fce42aa6', 'str_d419b034', 'str_17b0844a', 'str_8d0ab826', FALSE, 613244031, '2a42cd99-7bef-4bfe-a4af-a1e408e1b730');
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xeffafb5684dd0fbec14a5a46d5f5', '\x41ca324eba', '\x93', 132, '\x1aa697646ce4757ade', 2041822582);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xdecd2488a1', '\x10623948ac4043ac6e06', '\xb90384af9ed97c347d8665181fc9', 20, '\x814fd497043bd5981c43e6', 1433426557);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xf11899f0b235424c2fb5f1c52010', '\x0866ad854f', '\x04b3fa858780c272d3', 82, '\x67115e08580d2d1da2', 329364203);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_6566c77f', 'mobile', 'deactivated', '2025-08-17 20:37:36', '2025-08-12 19:39:50', '562defb7-74b0-40ce-a099-9da54895fbf4', 'str_a924f4b4', 'str_fc37fbe3', FALSE, 2053912677, 'cafcfaac-3997-4033-9f4e-f26015c38877');
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_fa186911', 'card', 'active', '2025-08-09 22:54:10', '2025-08-12 21:53:32', '707b4ee5-f0fb-4981-acf6-527b5255ead9', 'str_330bc282', 'str_dc0bceaa', TRUE, 848868213, 'bd7fe73f-1bd6-47c7-aa49-1f27c390a926');
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_ef89e2b3', 'mobile', 'lost', '2025-08-09 07:12:11', '2025-08-12 17:44:05', '9035f56e-1621-4497-9237-fdb4df9770bf', 'str_d1885d0f', 'str_805d0a36', FALSE, 372216848, '9ae60389-a918-4187-9e81-6358033e8d19');
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('707b4ee5-f0fb-4981-acf6-527b5255ead9', 'person', 'str_01dc8628', 'str_c2fbec7e');
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('9035f56e-1621-4497-9237-fdb4df9770bf', 'person', 'str_f039a49d', 'str_6bc33857');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('562defb7-74b0-40ce-a099-9da54895fbf4', 'drone', 'str_bf847f64', 'str_a62a69c5');

INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('external_area', NULL, NULL, 'Outside World', NULL, TRUE, 1, '7b335e42-2c34-455b-8041-86111c50aac1');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('building', '7b335e42-2c34-455b-8041-86111c50aac1', NULL, 'Seven Seals HQ', 'Feodosiyskaya, building 1', TRUE, 2, 'f9918759-9a99-40e9-9fbb-e06d57e07677');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('floor', 'f9918759-9a99-40e9-9fbb-e06d57e07677', NULL, 'Second floor', NULL, TRUE, 1, '4ba26900-7e80-4bb2-b916-38a24dd6a997');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('floor', 'f9918759-9a99-40e9-9fbb-e06d57e07677', NULL, '1-st floor', NULL, TRUE, 2, '74ea2417-a157-4852-b91a-4646aa35e779');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('corridor', '4ba26900-7e80-4bb2-b916-38a24dd6a997', NULL, 'Corridor', NULL, TRUE, 1, '26cf4711-9880-4a57-bcc5-6da0569df512');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('room', '26cf4711-9880-4a57-bcc5-6da0569df512', NULL, 'Chief Accountant', 'Galina Ivanovna', TRUE, 2, '22bd61c5-967f-4457-82ce-573368774e71');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('room', '26cf4711-9880-4a57-bcc5-6da0569df512', NULL, 'Programmers', 'Kostya, Vadik', TRUE, 3, '336bb7c8-379f-44c0-9526-96077f4da03c');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('room', '26cf4711-9880-4a57-bcc5-6da0569df512', NULL, 'Director', 'Arkadiy Efimovich', TRUE, 4, 'a1b2c3d4-e5f6-7890-abcd-ef1234567891');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('room', '26cf4711-9880-4a57-bcc5-6da0569df512', NULL, 'Class Room', NULL, TRUE, 5, 'b2c3d4e5-f6a7-8901-bcde-f23456789012');

INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('Person A', NULL, TRUE, 0, 'db5a6024-eeb8-4c09-9314-86f8e4a04989');
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('db5a6024-eeb8-4c09-9314-86f8e4a04989', 'person', 'PersonA@tss.com', NULL);
INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('Person B', NULL, TRUE, 0, '5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b');
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', 'person', 'PersonB@tss.com', NULL);

INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('000003C6A799', 'physical', 'active', '0001-01-01 00:00:00.000', NULL, 'db5a6024-eeb8-4c09-9314-86f8e4a04989', NULL, NULL, TRUE, 0, 'db5a6024-eeb8-4c09-9314-86f8e4a04989');
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('0000007B1B89', 'physical', 'stolen', '0001-01-01 00:00:00.000', NULL, '5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b', NULL, NULL, TRUE, 0, '5d5f9a6e-2b4c-49e9-82ee-083c7d0dd80b');

INSERT INTO "contour"."spot" ("name", "hint", "is_active", "order", "id") VALUES ('classrom', NULL, TRUE, 0, 'd414e607-964f-40a1-8b31-470d3b9d85ca');
INSERT INTO "contour"."spot_ip" ("spot_id", "type", "host", "port") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', 'ip', 'office.sevenseals.ru', 5087);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('d414e607-964f-40a1-8b31-470d3b9d85ca', '77');
INSERT INTO "contour"."spot" ("name", "hint", "is_active", "order", "id") VALUES ('progers', NULL, TRUE, 0, '3037e535-87b3-46a4-8ece-349da4bb7bd4');
INSERT INTO "contour"."spot_ip" ("spot_id", "type", "host", "port") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', 'ip', 'office.sevenseals.ru', 5086);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('3037e535-87b3-46a4-8ece-349da4bb7bd4', '171');
INSERT INTO "contour"."spot" ("name", "hint", "is_active", "order", "id") VALUES ('progers-comport', NULL, TRUE, 0, '1d9f31e9-90e3-45ea-a85f-fb07f1b4b334');
INSERT INTO "contour"."spot_com_port" ("spot_id", "type", "port_name", "baud_rate", "parity", "data_bits", "stop_bits", "read_timeout_ms", "write_timeout_ms") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', 'com_port', 'COM3', 19200, 'none', 8, 'one', 1000, 1000);
INSERT INTO "contour"."spot_address" ("spot_id", "address") VALUES ('1d9f31e9-90e3-45ea-a85f-fb07f1b4b334', '7');

INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "name", "hint", "is_active", "order", "id") VALUES ('7b335e42-2c34-455b-8041-86111c50aac1', 'f9918759-9a99-40e9-9fbb-e06d57e07677', TRUE, NULL, 'Vhod s ulizi', NULL, TRUE, 1, '6102b44c-e253-479d-8dda-2c8bada596e1');
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "name", "hint", "is_active", "order", "id") VALUES ('f9918759-9a99-40e9-9fbb-e06d57e07677', '4ba26900-7e80-4bb2-b916-38a24dd6a997', TRUE, NULL, 'Vhod na 2 etaj', NULL, TRUE, 2, 'b6ecb955-d757-4b03-8ae8-45c6fcc8efc7');
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "name", "hint", "is_active", "order", "id") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', '22bd61c5-967f-4457-82ce-573368774e71', TRUE, NULL, 'Vhod v Chief Accountant', NULL, TRUE, 3, 'd2e3f4a5-6789-0123-bcde-f23456789012');
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "name", "hint", "is_active", "order", "id") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', '336bb7c8-379f-44c0-9526-96077f4da03c', TRUE, NULL, 'Vhod v Programmers', 'office.sevenseals.ru:5086', TRUE, 4, 'e3f4a5b6-7890-1234-cdef-345678901234');
INSERT INTO "atlas"."transit" ("from_zone_id", "to_zone_id", "is_bidirectional", "spot_id", "name", "hint", "is_active", "order", "id") VALUES ('26cf4711-9880-4a57-bcc5-6da0569df512', 'b2c3d4e5-f6a7-8901-bcde-f23456789012', TRUE, NULL, 'Vhod v Class Room', 'office.sevenseals.ru:5087', TRUE, 5, 'f4a5b6c7-8901-2345-defa-456789012345');

