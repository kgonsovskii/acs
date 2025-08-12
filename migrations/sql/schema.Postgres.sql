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

INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_303d27c9', 'str_e879b274', TRUE, 74029363, '18748eee-83e6-4a1a-b17b-fd1808e4d3a0');
INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_94fef2b7', 'str_856c540a', FALSE, 1695985721, '1e76f57b-646f-4c64-8dde-46e06dde0c50');
INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_7af711ad', 'str_a8bb5f2c', TRUE, 523457529, '1258afb0-e9eb-4c80-852f-8512c5e2e01f');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('47e09742-1851-4ae8-9310-8134b7719967', 'a93d1a55-4ca2-4f72-aee9-f1216a41496b', TRUE, 'str_5746d4d6', 'str_89e74745', FALSE, 260081625, '2ff117a9-3c57-40e2-89f1-9d61a647493e');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('01dcc321-0eae-4472-8fd0-6db9b26e9626', 'b2385751-5190-4919-8304-d0e8c5071318', TRUE, 'str_1678ba7a', 'str_a194bec7', FALSE, 523747317, 'da3199b2-e389-4455-8f26-c1aee1852d46');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('4a5f42b9-648f-4853-9792-937f7c4be915', 'cc1b6528-bae4-4f88-8773-a8cdc22f0874', FALSE, 'str_483ca29c', 'str_6ebd09b8', FALSE, 102063759, '3c304125-84e9-46d7-8bea-ea4031bb27a5');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('sunday', 'str_0e31cf78', 'str_3b5e1b78', 'str_1d92d050', 'str_0cdba7db', FALSE, 340411102, '189b87ad-4583-49fd-b7b6-9b546b1aa5a7');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('thursday', 'str_72228e01', 'str_ecfb0387', 'str_93819046', 'str_a82bf6ae', FALSE, 829095382, 'f3c22293-49e6-46c6-bedb-482edf91f1f3');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('saturday', 'str_c629e24c', 'str_97495fd3', 'str_c6f96c9b', 'str_59893c32', TRUE, 2110016108, 'a7c67820-a4f7-42b6-b63b-b933083beafb');
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x8607', '\x666b29d664f60cc40a1b2227f50e362e', '\x64051b357db5c2', 39, '\xcd1092c652', 1290109890);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x9d0a98dee16271498742f93401ec10', '\xf5f823ccfb29c0bedabadd7302accc40', '\x2f4261d13b2ff7069e1a4bf0c982630c', 241, '\xd1dafafe3fef68e6bec7bb6ddd50', 693595019);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x2c64bf85ff95', '\xe98002206f', '\x94cee474f25633', 61, '\xdc129f74755177b4', 217332643);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_6a5b49fc', 'mobile', 'stolen', '2025-08-06 08:10:40', '2025-08-14 23:14:59', '18748eee-83e6-4a1a-b17b-fd1808e4d3a0', 'str_32533b73', 'str_c548952d', TRUE, 342902497, '65b57c28-8d1e-4914-b2d1-e4b537eced7a');
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_9d40525b', 'card', 'deactivated', '2025-08-13 09:00:20', '2025-08-05 19:10:51', '1258afb0-e9eb-4c80-852f-8512c5e2e01f', 'str_e8b34590', 'str_e251d10d', TRUE, 519147923, '2d58092d-7bea-4b10-aed8-7c9e3b754aa4');
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_957889c9', 'physical', 'active', '2025-08-20 05:12:51', '2025-08-03 05:02:55', '1e76f57b-646f-4c64-8dde-46e06dde0c50', 'str_d4088d4b', 'str_6ab7c0f4', FALSE, 44382647, '752748f3-79ed-41d3-bfd0-91c6caba75de');
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('1e76f57b-646f-4c64-8dde-46e06dde0c50', 'person', 'str_d56eaf04', 'str_96f9cdec');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('18748eee-83e6-4a1a-b17b-fd1808e4d3a0', 'drone', 'str_b12065c2', 'str_8784735d');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('1258afb0-e9eb-4c80-852f-8512c5e2e01f', 'drone', 'str_a54c7767', 'str_549432a5');

INSERT INTO "atlas"."zone" ("type", "parent_id", "name", "hint", "is_active", "order", "id") VALUES ('external_area', NULL, 'Outside World', NULL, TRUE, 1, '7b335e42-2c34-455b-8041-86111c50aac1');
INSERT INTO "atlas"."zone" ("type", "parent_id", "name", "hint", "is_active", "order", "id") VALUES ('building', '7b335e42-2c34-455b-8041-86111c50aac1', 'Seven Seals HQ', 'Feodosiyskaya, building 1', TRUE, 2, 'f9918759-9a99-40e9-9fbb-e06d57e07677');
INSERT INTO "atlas"."zone" ("type", "parent_id", "name", "hint", "is_active", "order", "id") VALUES ('floor', 'f9918759-9a99-40e9-9fbb-e06d57e07677', '1-st floor', NULL, TRUE, 3, '74ea2417-a157-4852-b91a-4646aa35e779');
INSERT INTO "atlas"."zone" ("type", "parent_id", "name", "hint", "is_active", "order", "id") VALUES ('floor', 'f9918759-9a99-40e9-9fbb-e06d57e07677', 'Second floor', NULL, TRUE, 4, '4ba26900-7e80-4bb2-b916-38a24dd6a997');
INSERT INTO "atlas"."zone" ("type", "parent_id", "name", "hint", "is_active", "order", "id") VALUES ('corridor', '4ba26900-7e80-4bb2-b916-38a24dd6a997', 'Corridor', NULL, TRUE, 1, '26cf4711-9880-4a57-bcc5-6da0569df512');
INSERT INTO "atlas"."zone" ("type", "parent_id", "name", "hint", "is_active", "order", "id") VALUES ('room', '26cf4711-9880-4a57-bcc5-6da0569df512', 'Chief Accountant', 'Galina Ivanovna', TRUE, 2, '22bd61c5-967f-4457-82ce-573368774e71');
INSERT INTO "atlas"."zone" ("type", "parent_id", "name", "hint", "is_active", "order", "id") VALUES ('room', '26cf4711-9880-4a57-bcc5-6da0569df512', 'Programmers', 'Kostya, Vadik', TRUE, 3, '336bb7c8-379f-44c0-9526-96077f4da03c');
INSERT INTO "atlas"."zone" ("type", "parent_id", "name", "hint", "is_active", "order", "id") VALUES ('room', '26cf4711-9880-4a57-bcc5-6da0569df512', 'Director', 'Arkadiy Efimovich', TRUE, 4, 'a1b2c3d4-e5f6-7890-abcd-ef1234567891');
INSERT INTO "atlas"."zone" ("type", "parent_id", "name", "hint", "is_active", "order", "id") VALUES ('room', '26cf4711-9880-4a57-bcc5-6da0569df512', 'Class Room', NULL, TRUE, 5, 'b2c3d4e5-f6a7-8901-bcde-f23456789012');

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

