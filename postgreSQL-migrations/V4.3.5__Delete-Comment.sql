CREATE OR REPLACE FUNCTION "forum"."delete_comment"(
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
    -- Validate user credentials
    SELECT account_id INTO l_account_id
    FROM "user"."check_session_token"(p_session_token, p_browser_info);

    -- Check if the account_id was returned
    IF l_account_id IS NOT NULL THEN
        -- Check if the user owns the comment or has deletion rights
        IF EXISTS (
            SELECT 1
            FROM "forum"."comments"
            WHERE "id" = p_comment_id AND "account_id" = l_account_id
        ) THEN
            -- Delete the comment
            DELETE FROM "forum"."comments"
            WHERE "id" = p_comment_id;

            -- Return success message
            message := 'SUCCESS';
        ELSE
            -- User does not own the comment or lacks deletion rights
            message := 'FAILURE';
        END IF;
    ELSE
        -- User validation failed
        message := 'USER';
    END IF;
	RETURN NEXT;
END;
$$;
