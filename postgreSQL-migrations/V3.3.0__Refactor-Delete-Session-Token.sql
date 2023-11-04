DROP FUNCTION IF EXISTS "user".delete_session_token(VARCHAR);

CREATE OR REPLACE FUNCTION "user".delete_session_token(
    p_session_token VARCHAR,
    p_browser_info TEXT,
    target_session_token VARCHAR
)
RETURNS TABLE (MESSAGE TEXT) AS $$
DECLARE
    v_account_id INT;
    v_target_account_id INT;
BEGIN
    SELECT account_id INTO v_account_id
    FROM "user"."account_sessions"
    WHERE session_token = p_session_token AND browser_info = p_browser_info;

    IF NOT FOUND THEN
        RETURN QUERY SELECT 'INVALID'::TEXT;
        RETURN;
    ELSIF v_account_id IS NULL THEN
        -- Drop row if session token exists, but browser mismatch.
        DELETE FROM "user"."account_sessions"
        WHERE session_token = p_session_token;

        RETURN QUERY SELECT 'BROWSER'::TEXT;
        RETURN;
    END IF;

    -- Check if target token exists, and if the account ID matches with the
    -- requesting user's id.
    SELECT account_id INTO v_target_account_id
    FROM "user"."account_sessions"
    WHERE session_token = target_session_token;

    IF NOT FOUND THEN
        RETURN QUERY SELECT 'NOT FOUND'::TEXT;
        RETURN;
    ELSIF v_target_account_id <> v_account_id THEN
        RETURN QUERY SELECT 'ACCOUNT'::TEXT;
        RETURN;
    END IF;

    DELETE FROM "user"."account_sessions"
    WHERE session_token = target_session_token;

    RETURN QUERY SELECT 'SUCCESS'::TEXT;
END;
$$ LANGUAGE plpgsql;
