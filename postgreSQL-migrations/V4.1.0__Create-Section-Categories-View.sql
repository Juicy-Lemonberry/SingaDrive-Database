CREATE OR REPLACE VIEW "forum"."section_categories" as
SELECT
	"forum"."categories"."id" as "category_id",
	"forum"."categories"."section_id",
	"forum"."categories"."ordering" as "category_ordering",
	"forum"."sections"."ordering" as "section_ordering",
	"forum"."sections"."title" as "section_title",
	"forum"."categories"."title" as "category_title",
	"forum"."categories"."description"
FROM "forum"."categories"
FULL JOIN "forum"."sections"
ON "forum"."sections"."id" = "forum"."categories"."section_id";