-- For non-sensitive info...
CREATE OR REPLACE FUNCTION "user"."update_account_details"(
    p_session_token VARCHAR,
    p_browser_info TEXT,
    p_display_name VARCHAR
)
RETURNS TABLE(message TEXT) AS $$
DECLARE
    v_account_id INT;
    v_expiry_time TIMESTAMP;
    v_browser_info TEXT;
BEGIN
    -- Get session details
    SELECT account_id, expiry_time, browser_info 
    INTO v_account_id, v_expiry_time, v_browser_info
    FROM "user"."account_sessions"
    WHERE session_token = p_session_token;

    -- Validate session
    IF v_account_id IS NULL THEN
        RETURN QUERY SELECT 'INVALID'::TEXT;
        RETURN;
    END IF;

    IF v_expiry_time <= NOW() THEN
        DELETE FROM "user"."account_sessions" WHERE session_token = p_session_token;
        RETURN QUERY SELECT 'EXPIRED'::TEXT;
        RETURN;
    END IF;

    IF v_browser_info != p_browser_info THEN
        DELETE FROM "user"."account_sessions" WHERE session_token = p_session_token;
        RETURN QUERY SELECT 'BROWSER'::TEXT;
        RETURN;
    END IF;

    -- Update account details
    UPDATE "user"."accounts"
    SET display_name = COALESCE(p_display_name, display_name)
    WHERE id = v_account_id;

    -- Return message
    RETURN QUERY SELECT 'OK'::TEXT;
END;
$$ LANGUAGE plpgsql;
