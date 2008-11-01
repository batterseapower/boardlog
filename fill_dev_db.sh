#!/bin/bash

sqlite3 sample_development.db <<DUMPEDDATA
BEGIN TRANSACTION;
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('users',2);
INSERT INTO "sqlite_sequence" VALUES('whiteboards',1);
--CREATE TABLE "whiteboards" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "name" VARCHAR(50));
INSERT INTO "whiteboards" VALUES(1,'FC13');
--CREATE TABLE "sessions" ("session_id" VARCHAR(32) NOT NULL, "data" TEXT DEFAULT 'BAh7AA== ', "created_at" DATETIME, PRIMARY KEY("session_id"));
--CREATE TABLE "users_whiteboards" ("whiteboard_id" INTEGER NOT NULL, "user_id" INTEGER NOT NULL, PRIMARY KEY("whiteboard_id", "user_id"));
INSERT INTO "users_whiteboards" VALUES(1,1);
--CREATE TABLE "users" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "login" VARCHAR(50), "crypted_password" VARCHAR(50), "salt" VARCHAR(50));
INSERT INTO "users" VALUES(1,'batterseapower','5b05cf137fe2af377509607bb5b05509667ece32','567381051046dc198937332a55426ba1b2a185ed');
INSERT INTO "users" VALUES(2,'dorchard','9fb5b779cc92bae36657cf11f5345d96c8a379c8','c1680350a84b069f3eda935523da9fe7aa128a65');
COMMIT;
DUMPEDDATA