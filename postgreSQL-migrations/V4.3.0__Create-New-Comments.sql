CREATE OR REPLACE FUNCTION "forum"."create_new_comment"(
    p_post_id INT,
    p_session_token VARCHAR,
    p_browser_info TEXT
)
RETURNS TABLE (
    comment_id INT,
    message TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    l_account_id INT;
    l_auth_record RECORD;
BEGIN
    SELECT * INTO l_auth_record
    FROM "user".check_session_token(p_session_token, p_browser_info);

    IF l_auth_record.message = 'OK' THEN
        l_account_id := l_auth_record.account_id;
        INSERT INTO "forum"."comments"("post_id", "account_id", "created_at")
        VALUES (p_post_id, l_account_id, NOW())
        RETURNING "id" INTO comment_id;

        message := 'OK';
        RETURN NEXT;
    ELSE
        comment_id := NULL;
        message := 'ACCOUNT';
        RETURN NEXT;
    END IF;
END;
$$;