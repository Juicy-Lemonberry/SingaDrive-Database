CREATE OR REPLACE FUNCTION "forum"."get_category_posts" (p_category_id INT)
RETURNS TABLE (
    post_id INT,
    created_at TIMESTAMP,
    display_name VARCHAR(64),
    tags VARCHAR(64)[],
    last_activity TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        p."id" AS post_id,
        p."created_at",
        a."display_name",
        ARRAY(
            SELECT t."name"
            FROM "forum"."post_tags" pt
            INNER JOIN "forum"."tags" t ON pt."tag_id" = t."id"
            WHERE pt."post_id" = p."id"
        ) AS tags,
        COALESCE(
            (
                SELECT MAX(c."created_at")
                FROM "forum"."comments" c
                WHERE c."post_id" = p."id"
            ),
            NULL
        ) AS last_activity
    FROM "forum"."posts" p
    LEFT JOIN "user"."accounts" a ON p."account_id" = a."id"
    WHERE p."category_id" = p_category_id;
END;
$$;