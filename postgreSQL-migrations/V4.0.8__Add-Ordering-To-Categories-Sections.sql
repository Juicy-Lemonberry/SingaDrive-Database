-- Used in frontend to acknowledge which category/section should be displayed at the top first...
-- (Lower value = at the top)
ALTER TABLE "forum"."categories" ADD COLUMN "ordering" INT DEFAULT 0;

ALTER TABLE "forum"."sections" ADD COLUMN "ordering" INT DEFAULT 0;
UPDATE "forum"."sections" SET "ordering" = 1 WHERE "title" = 'General';
