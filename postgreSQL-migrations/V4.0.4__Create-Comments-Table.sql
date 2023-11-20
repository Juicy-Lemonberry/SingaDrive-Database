CREATE TABLE "forum"."comments" (
    "id" SERIAL PRIMARY KEY,
    "post_id" INT NOT NULL,
    "account_id" INT,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'GMT+8'),
    FOREIGN KEY ("post_id") REFERENCES "forum"."posts" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("account_id") REFERENCES "user"."accounts" ("id") ON DELETE SET NULL
);

CREATE INDEX "idx_comments_post_id" ON "forum"."comments" ("post_id");
CREATE INDEX "idx_comments_account_id" ON "forum"."comments" ("account_id");