CREATE TABLE "forum"."posts" (
    "id" SERIAL PRIMARY KEY,
    "category_id" INT,
    "account_id" INT,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'GMT+8'),
    FOREIGN KEY ("category_id") REFERENCES "forum"."categories" ("id") ON DELETE SET NULL,
    FOREIGN KEY ("account_id") REFERENCES "user"."accounts" ("id") ON DELETE SET NULL
);

CREATE INDEX "idx_posts_category_id" ON "forum"."posts" ("category_id");
CREATE INDEX "idx_posts_account_id" ON "forum"."posts" ("account_id");