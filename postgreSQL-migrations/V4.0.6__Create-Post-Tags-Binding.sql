CREATE TABLE "forum"."post_tags" (
    "post_id" INT NOT NULL,
    "tag_id" INT NOT NULL,
    PRIMARY KEY ("post_id", "tag_id"),
    FOREIGN KEY ("post_id") REFERENCES "forum"."posts" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("tag_id") REFERENCES "forum"."tags" ("id") ON DELETE CASCADE
);