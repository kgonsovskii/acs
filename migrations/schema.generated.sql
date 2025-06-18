DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'tss') THEN
      CREATE USER tss WITH PASSWORD '123' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;
   END IF;
END$$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'acs') THEN
      CREATE DATABASE acs OWNER tss;
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
    "name" TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS "codex"."day_of_week" (
    "name" TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS "actor"."card_type" (
    "name" TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS "contour"."channel_type" (
    "name" TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS "contour"."parity" (
    "name" TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS "contour"."stop_bits" (
    "name" TEXT PRIMARY KEY
);

-- Regular tables
CREATE TABLE "actor"."actor" (
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NOT NULL,
    "hint" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "atlas"."transit" (
    "from_zone_id" UUID NOT NULL,
    "to_zone_id" UUID NOT NULL,
    "is_bidirectional" BOOLEAN NOT NULL,
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NOT NULL,
    "hint" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "atlas"."zone" (
    "type" TEXT NOT NULL,
    "parent_id" UUID NULL,
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NOT NULL,
    "hint" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "codex"."route_rule" (
    "from_zone_id" UUID NOT NULL,
    "to_zone_id" UUID NOT NULL,
    "is_bidirectional" BOOLEAN NOT NULL,
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NOT NULL,
    "hint" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL
);

CREATE TABLE "codex"."time_zone_rule" (
    "day_of_week" TEXT NOT NULL,
    "start_time" INTERVAL NOT NULL,
    "end_time" INTERVAL NOT NULL,
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NOT NULL,
    "hint" TEXT NOT NULL,
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
    "addresses" TEXT NOT NULL,
    "id" UUID PRIMARY KEY NOT NULL,
    "name" TEXT NOT NULL,
    "hint" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL
);

-- Polymorphic tables
CREATE TABLE IF NOT EXISTS "actor"."actor_person" (
    "actorId" UUID REFERENCES "actor"."actor"("id"),
    "type" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS "actor"."actor_drone" (
    "actorId" UUID REFERENCES "actor"."actor"("id"),
    "type" TEXT NOT NULL,
    "serial_number" TEXT NOT NULL,
    "firmware_version" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS "contour"."spot_ip" (
    "spotId" UUID REFERENCES "contour"."spot"("id"),
    "type" TEXT NOT NULL,
    "host" TEXT NOT NULL,
    "port" INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS "contour"."spot_com_port" (
    "spotId" UUID REFERENCES "contour"."spot"("id"),
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
CREATE TABLE IF NOT EXISTS "atlas"."zone_zone" (
    "zoneId" UUID REFERENCES "atlas"."zone"("id"),
    "childId" UUID REFERENCES "atlas"."zone"("id"),
    PRIMARY KEY ("zoneId", "childId")
);

-- Indexes
CREATE INDEX IF NOT EXISTS "idx_zone_zone_zoneId" ON "atlas"."zone_zone"("zoneId");
CREATE INDEX IF NOT EXISTS "idx_zone_zone_childId" ON "atlas"."zone_zone"("childId");

-- Enum data population
INSERT INTO "atlas"."zone_type" ("name") VALUES ('building') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name") VALUES ('floor') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name") VALUES ('room') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name") VALUES ('corridor') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name") VALUES ('lobby') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name") VALUES ('elevator') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name") VALUES ('staircase') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name") VALUES ('parking') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "atlas"."zone_type" ("name") VALUES ('external_area') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name") VALUES ('sunday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name") VALUES ('monday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name") VALUES ('tuesday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name") VALUES ('wednesday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name") VALUES ('thursday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name") VALUES ('friday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "codex"."day_of_week" ("name") VALUES ('saturday') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."card_type" ("name") VALUES ('person') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "actor"."card_type" ("name") VALUES ('drone') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."channel_type" ("name") VALUES ('ip') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."channel_type" ("name") VALUES ('com_port') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."parity" ("name") VALUES ('none') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."parity" ("name") VALUES ('odd') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."parity" ("name") VALUES ('even') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."parity" ("name") VALUES ('mark') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."parity" ("name") VALUES ('space') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."stop_bits" ("name") VALUES ('none') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."stop_bits" ("name") VALUES ('one') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."stop_bits" ("name") VALUES ('two') ON CONFLICT ("name") DO NOTHING;
INSERT INTO "contour"."stop_bits" ("name") VALUES ('one_point_five') ON CONFLICT ("name") DO NOTHING;

-- Enum foreign keys
ALTER TABLE "atlas"."zone" ADD CONSTRAINT "fk_zone_type" FOREIGN KEY ("type") REFERENCES "atlas"."zone_type"("name");
ALTER TABLE "codex"."time_zone_rule" ADD CONSTRAINT "fk_time_zone_rule_day_of_week" FOREIGN KEY ("day_of_week") REFERENCES "codex"."day_of_week"("name");
ALTER TABLE "actor"."actor_person" ADD CONSTRAINT "fk_actor_person_type" FOREIGN KEY ("type") REFERENCES "actor"."card_type"("name");
ALTER TABLE "actor"."actor_drone" ADD CONSTRAINT "fk_actor_drone_type" FOREIGN KEY ("type") REFERENCES "actor"."card_type"("name");
ALTER TABLE "contour"."spot_ip" ADD CONSTRAINT "fk_spot_ip_type" FOREIGN KEY ("type") REFERENCES "contour"."channel_type"("name");
ALTER TABLE "contour"."spot_com_port" ADD CONSTRAINT "fk_spot_com_port_type" FOREIGN KEY ("type") REFERENCES "contour"."channel_type"("name");
ALTER TABLE "contour"."spot_com_port" ADD CONSTRAINT "fk_spot_com_port_parity" FOREIGN KEY ("parity") REFERENCES "contour"."parity"("name");
ALTER TABLE "contour"."spot_com_port" ADD CONSTRAINT "fk_spot_com_port_stop_bits" FOREIGN KEY ("stop_bits") REFERENCES "contour"."stop_bits"("name");
ALTER TABLE "atlas"."zone" ADD CONSTRAINT "fk_zone_type" FOREIGN KEY ("type") REFERENCES "atlas"."zone_type"("name");
