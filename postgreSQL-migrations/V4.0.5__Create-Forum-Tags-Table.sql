CREATE TABLE "forum"."tags" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(64) NOT NULL,
    "description" TEXT
);