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

INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_b3891091', 'str_7296b93c', FALSE, 60526190, 'a3fd6081-d3c4-45b7-9aeb-0ae8f7b2db4f');
INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_9949ecf6', 'str_1070cc5c', TRUE, 354115591, '4bb7b098-6860-403b-8d94-b9b1164845db');
INSERT INTO "actor"."member" ("name", "hint", "is_active", "order", "id") VALUES ('str_7f1152d2', 'str_d435da50', FALSE, 75608279, '443dbeca-74d3-4334-a2b6-5378d7de2b0e');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('1d8b878a-9fc3-4538-b41d-6920a32bcdc8', 'e8e2361c-1e36-4693-90f2-cb65cfcd1527', FALSE, 'str_51bf62c1', 'str_e42f99d1', FALSE, 999677171, '59c26fc6-36f4-4358-af4a-898e4e56a5c8');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('b22f3941-ffb5-46dc-a3f7-1baa0a24f14c', 'f9d369e5-a29e-43ad-9b3d-46004b14a7a3', FALSE, 'str_82278a49', 'str_75cba17f', FALSE, 378538949, 'bf2346cb-ad62-4f56-bca7-f2ec2997b641');
INSERT INTO "codex"."route_rule" ("from_zone_id", "to_zone_id", "is_bidirectional", "name", "hint", "is_active", "order", "id") VALUES ('8c73ca2b-32fb-4f2e-938f-a3dcfbe4e86c', 'c6b3680d-710f-415e-8a7b-853eddd98cbc', FALSE, 'str_00d2f957', 'str_c5bda8b2', TRUE, 896505128, 'd9dde402-e096-46e9-8292-5e04a721e522');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('thursday', 'str_ad93ec07', 'str_4695122d', 'str_d3eaf336', 'str_c5731e03', TRUE, 1150187854, 'd185c0aa-ede0-4a98-b0d3-1101e9e94ae9');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('monday', 'str_7b6893e3', 'str_dad42be2', 'str_1411646f', 'str_f716ddc3', FALSE, 924278353, '0068263a-6c8c-4d0f-ae01-f67ed8cb771c');
INSERT INTO "codex"."time_zone_rule" ("day_of_week", "start_time", "end_time", "name", "hint", "is_active", "order", "id") VALUES ('wednesday', 'str_3f07e0d8', 'str_050db108', 'str_c9c2d374', 'str_1c477861', FALSE, 544587696, '75c15b14-1d51-4d92-bdc1-a2a11aeb46eb');
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x91ce96ccb406bcddafbe8d3361f4f59d', '\x1b991a32ec489e300599292c63e7', '\xc4b38dbdc53d0c', 111, '\x5347f7800f858d330740a608', 2015284120);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\xfc3e3417dda4ebc39488fe330c4542', '\xac3fd0e7144008c351e7d956', '\x1faab453846efa', 198, '\x47c5bf1abababd73a50b0b9aab6576', 286377126);
INSERT INTO "contour"."event_log" ("ch", "controller_timestamp", "timestamp", "addr", "data", "id") VALUES ('\x738a3d368986', '\xf8bd', '\xdf339685f8854f248954d176', 235, '\x7d8c6fcd7bf45bf7603f9b7e53ce', 42049920);
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_e7ff91c5', 'card', 'lost', '2025-08-07 07:49:58', '2025-08-20 15:51:02', '4bb7b098-6860-403b-8d94-b9b1164845db', 'str_7c7a5d04', 'str_26d733b8', TRUE, 419771375, 'e396bcad-bc4a-4be7-9419-862b2bb7d334');
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_03ae5f8c', 'physical', 'deactivated', '2025-08-10 22:11:30', '2025-08-11 03:30:10', '4bb7b098-6860-403b-8d94-b9b1164845db', 'str_32bea7b8', 'str_2f3bf194', FALSE, 85854926, '66f8383d-9918-4329-9fdb-ce24f71619dd');
INSERT INTO "actor"."pass" ("key_number", "type", "status", "issue_date", "expiry_date", "member_id", "name", "hint", "is_active", "order", "id") VALUES ('str_d160fb1a', 'mobile', 'lost', '2025-08-11 22:26:56', '2025-08-22 17:05:10', 'a3fd6081-d3c4-45b7-9aeb-0ae8f7b2db4f', 'str_c442eb4f', 'str_8e8ec3be', TRUE, 275222578, '29f89d72-46fc-43aa-8466-1f862fd13ba8');
INSERT INTO "actor"."member_person" ("member_id", "type", "email", "phone") VALUES ('4bb7b098-6860-403b-8d94-b9b1164845db', 'person', 'str_5efd55d5', 'str_33b664f7');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('a3fd6081-d3c4-45b7-9aeb-0ae8f7b2db4f', 'drone', 'str_7daf7928', 'str_44197266');
INSERT INTO "actor"."member_drone" ("member_id", "type", "serial_number", "firmware_version") VALUES ('443dbeca-74d3-4334-a2b6-5378d7de2b0e', 'drone', 'str_cb6d5856', 'str_50bca74a');

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

