CREATE OR REPLACE FUNCTION "forum"."get_post_comments"(p_post_id INT)
RETURNS TABLE (
    comment_id INT,
    username VARCHAR(64),
    display_name VARCHAR(64),
    created_at TIMESTAMP
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c."id" AS comment_id,
        a."username",
        a."display_name",
        c."created_at"
    FROM
        "forum"."comments" c
        LEFT JOIN "user"."accounts" a ON c."account_id" = a."id"
    WHERE
        c."post_id" = p_post_id;
END;
$$;