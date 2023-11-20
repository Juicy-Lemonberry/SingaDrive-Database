CREATE OR REPLACE FUNCTION "forum"."get_post_details" (p_post_id INT)
RETURNS TABLE (
    post_id INT,
    category_id INT,
    username VARCHAR(64),
    display_name VARCHAR(64),
    tags VARCHAR(128)[],
    created_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY SELECT
        p."id" AS post_id,
        p."category_id",
        a."username",
        a."display_name",
        ARRAY(
            SELECT t."name" FROM "forum"."post_tags" pt
            INNER JOIN "forum"."tags" t ON pt."tag_id" = t."id"
            WHERE pt."post_id" = p."id"
        ) AS tags,
        p."created_at"
    FROM "forum"."posts" p
    LEFT JOIN "user"."accounts" a ON p."account_id" = a."id"
    WHERE p."id" = p_post_id;
END;
$$;