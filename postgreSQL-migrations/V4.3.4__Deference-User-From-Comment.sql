CREATE OR REPLACE FUNCTION "forum"."remove_comment_user"(
    p_session_token VARCHAR,
    p_browser_info TEXT,
    p_comment_id INT
)
RETURNS TABLE (
	message TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    l_account_id INT;
BEGIN
 
    SELECT account_id INTO l_account_id
    FROM "user"."check_session_token"(p_session_token, p_browser_info);

    IF l_account_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
            FROM "forum"."comments"
            WHERE "id" = p_comment_id AND "account_id" = l_account_id
        ) THEN
            UPDATE "forum"."comments"
            SET "account_id" = NULL
            WHERE "id" = p_comment_id;
            message := 'SUCCESS';
        ELSE
            -- User does not own the comment
            message := 'FAILURE';
        END IF;
    ELSE
        -- User validation failed
        message := 'USER';
    END IF;
	RETURN NEXT;
END;
$$;
