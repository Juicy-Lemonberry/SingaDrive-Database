ALTER TABLE "forum"."comments"
ALTER COLUMN "created_at" SET DATA TYPE TIMESTAMP;

ALTER TABLE "forum"."posts"
ALTER COLUMN "created_at" SET DATA TYPE TIMESTAMP;