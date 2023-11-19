CREATE OR REPLACE FUNCTION "forum"."is_user_comment"(
    p_session_token VARCHAR,
    p_browser_info TEXT,
    p_comment_id INT
)
RETURNS TABLE (
    message TEXT,
    is_user BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    l_account_id INT;
BEGIN
    -- validate user credentials
    SELECT account_id INTO l_account_id
    FROM "user"."check_session_token"(p_session_token, p_browser_info);

    IF l_account_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
            FROM "forum"."comments"
            WHERE "id" = p_comment_id AND "account_id" = l_account_id
        ) THEN
            message := 'SUCCESS';
            is_user := TRUE;
        ELSE
            message := 'FAILURE';
            is_user := FALSE;
        END IF;
    ELSE
        message := 'USER';
        is_user := FALSE;
    END IF;

    RETURN NEXT;
END;
$$;
