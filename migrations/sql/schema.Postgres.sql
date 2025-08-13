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
    "design" TEXT NOT NULL,
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

INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_f7aaa0ea', 'str_39e4f447', FALSE, 708173129, '10bb4e60-42ad-425d-b0b3-3367ddd5235b');
INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_7b688931', 'str_c6b113b3', TRUE, 570530307, 'b31c5e1e-836a-4086-8e85-fc1dee76d5c4');
INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_bc3594a3', 'str_d57c5701', TRUE, 692678395, 'd500e843-ac53-4f8f-8beb-44a08f1e6cc6');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('e3080c49-8b48-4688-ad09-90a461896b61', 'b5e640f6-4750-46ba-b1de-126b09fa5e55', TRUE, 'str_dad80af4', 'str_eccc4e6d', TRUE, 1354801240, '8784ee01-8edd-43dc-a9c8-a2a21d4e4bb0');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('2c60d638-550d-4a81-abb8-8c2d8b2b0b6f', 'acc651b9-b390-4fc4-9cdd-edcbed6b5697', FALSE, 'str_46cb35bf', 'str_8480e5d0', FALSE, 1143062852, '17a989b4-e49e-4072-ac84-413814c162c6');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('35dc21d1-21a7-4c82-aaa2-133ffd7b6757', 'ca88ec1d-2dc1-4667-9874-afac833c647a', TRUE, 'str_81172b46', 'str_4c8b3911', FALSE, 1928148361, '628b1d17-57a8-430c-a894-2284b1431c69');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('thursday', 'str_c68e1c33', 'str_ff6ba675', 'str_08f3a713', 'str_c64a7371', TRUE, 915258386, 'ee5374fe-eaaa-4023-85e4-5d1b8c95b3f9');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('tuesday', 'str_1a643b0b', 'str_adea84fe', 'str_670fad64', 'str_5df68bfc', FALSE, 247739304, '9e0d47e9-5367-447a-8f3f-f326302fc1d7');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('saturday', 'str_7c79b02e', 'str_82f6e7e7', 'str_3f4360ad', 'str_4d5bd230', FALSE, 1122726393, '42184af2-22b2-47c7-b07c-886f755b6720');
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x2568daefe1fe3bdd25c8', '\xc40625ba', '\x4f63a1ad', 45, '\x9af5', 935814255);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xf55b96419cba', '\x1908a1a3368976', '\x2f232196e7b81a9696f5', 170, '\xc816ef368701820c66e25a', 744932236);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x343aa0012dfdb86120bbdb7aa2', '\xa8e92d41be', '\x0bdc4d0b', 82, '\x340f945990506635', 1086506250);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_2718f9e9', 'card', 'stolen', '2025-08-23 20:45:36', '2025-08-08 00:49:20', 'b31c5e1e-836a-4086-8e85-fc1dee76d5c4', 'str_94bcb8dc', 'str_daa7817e', TRUE, 2049763265, '0f4dd684-3d1b-4c3e-91d8-2deb9c9dde31');
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_b522c07d', 'mobile', 'expired', '2025-08-05 11:31:55', '2025-08-09 21:08:56', 'd500e843-ac53-4f8f-8beb-44a08f1e6cc6', 'str_48b1ae19', 'str_96c36ad8', TRUE, 2136891698, '85511caa-af3f-4517-9955-ebce61e49ecc');
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_ec8d17b1', 'card', 'stolen', '2025-08-03 11:32:53', '2025-08-20 14:27:13', '10bb4e60-42ad-425d-b0b3-3367ddd5235b', 'str_bc859cf8', 'str_c1836433', FALSE, 1814706708, '313ba6b1-857f-451d-9945-210ebf9c2831');
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('10bb4e60-42ad-425d-b0b3-3367ddd5235b', 'person', 'str_e45dcc87', 'str_84acc1b5');
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('b31c5e1e-836a-4086-8e85-fc1dee76d5c4', 'person', 'str_1104c0cd', 'str_6215e7bb');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('d500e843-ac53-4f8f-8beb-44a08f1e6cc6', 'drone', 'str_a729927d', 'str_5f0c126f');

INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('external_area', NULL, NULL, 'Outside World', NULL, TRUE, 1, '7b335e42-2c34-455b-8041-86111c50aac1');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('building', '7b335e42-2c34-455b-8041-86111c50aac1', NULL, 'Seven Seals HQ', 'Feodosiyskaya, building 1', TRUE, 2, 'f9918759-9a99-40e9-9fbb-e06d57e07677');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('floor', 'f9918759-9a99-40e9-9fbb-e06d57e07677', NULL, '1-st floor', NULL, TRUE, 3, '74ea2417-a157-4852-b91a-4646aa35e779');
INSERT INTO "atlas"."zone" ("type", "parent_id", "design", "name", "hint", "is_active", "order", "id") VALUES ('floor', 'f9918759-9a99-40e9-9fbb-e06d57e07677', NULL, 'Second floor', NULL, TRUE, 4, '4ba26900-7e80-4bb2-b916-38a24dd6a997');
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

