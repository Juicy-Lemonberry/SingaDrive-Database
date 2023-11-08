CREATE TABLE "forum"."categories" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR(128) NOT NULL,
    "description" TEXT,
    "section_id" INT,
    FOREIGN KEY ("section_id") REFERENCES "forum"."sections" ("id") ON DELETE SET NULL
);