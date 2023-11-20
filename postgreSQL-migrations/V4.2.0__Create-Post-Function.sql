CREATE OR REPLACE FUNCTION "forum"."create_new_post" (
    p_session_token VARCHAR,
    p_category_id INT,
    p_post_tags INT[]
)
RETURNS TABLE (
    post_id INT,
    message TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    l_account_id INT;
    l_post_id INT;
	l_tag_id INT;
BEGIN
    SELECT "account_id" INTO l_account_id
    FROM "user"."account_sessions"
    WHERE "session_token" = p_session_token;

    -- Account ID not found...
    IF l_account_id IS NULL THEN
        post_id := NULL;
        message := 'USER';
        RETURN NEXT;
        RETURN;
    END IF;

    BEGIN
        INSERT INTO "forum"."posts"("category_id", "account_id", "created_at")
        VALUES (p_category_id, l_account_id, (NOW() AT TIME ZONE 'GMT+8'))
        RETURNING "id" INTO l_post_id;
    EXCEPTION WHEN OTHERS THEN
        post_id := NULL;
        message := 'INVALID';
        RETURN NEXT;
        RETURN;
    END;

    -- Insert into "forum"."post_tags" for each tag id
    IF p_post_tags IS NOT NULL THEN
        FOREACH l_tag_id IN ARRAY p_post_tags
        LOOP
            BEGIN
                INSERT INTO "forum"."post_tags"("post_id", "tag_id")
                VALUES (l_post_id, l_tag_id);
            EXCEPTION WHEN OTHERS THEN
                -- If insertion fails, ignore and continue...
                CONTINUE;
            END;
        END LOOP;
    END IF;

    post_id := l_post_id;
    message := 'SUCCESS';
    RETURN NEXT;
END;
$$;