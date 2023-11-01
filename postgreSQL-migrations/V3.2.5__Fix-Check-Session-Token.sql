CREATE OR REPLACE FUNCTION "user".check_session_token(p_session_token VARCHAR, p_browser_info TEXT)
RETURNS TABLE (
  message VARCHAR,
  account_id INT,
  username VARCHAR(64),
  email VARCHAR,
  created_at TIMESTAMP,
  display_name VARCHAR(64)
) AS $$
DECLARE
    user_id INT;
    v_expiry_time TIMESTAMP;
    v_browser_info TEXT;
BEGIN
    -- Get session details
    SELECT acc_sess.account_id, acc_sess.expiry_time, acc_sess.browser_info 
    INTO user_id, v_expiry_time, v_browser_info
    FROM "user"."account_sessions" AS acc_sess
    WHERE session_token = p_session_token;

    -- Validate session
    IF user_id IS NULL THEN
        RETURN QUERY SELECT 'INVALID'::VARCHAR, NULL::INT, NULL::VARCHAR, NULL::VARCHAR, NULL::TIMESTAMP, NULL::VARCHAR;
    END IF;

    IF v_expiry_time <= NOW() THEN
        DELETE FROM "user"."account_sessions" WHERE session_token = p_session_token;
        RETURN QUERY SELECT 'EXPIRED'::VARCHAR, NULL::INT, NULL::VARCHAR, NULL::VARCHAR, NULL::TIMESTAMP, NULL::VARCHAR;
    END IF;

    IF v_browser_info != p_browser_info THEN
        DELETE FROM "user"."account_sessions" WHERE session_token = p_session_token;
        RETURN QUERY SELECT 'BROWSER'::VARCHAR, NULL::INT, NULL::VARCHAR, NULL::VARCHAR, NULL::TIMESTAMP, NULL::VARCHAR;
    END IF;

    -- Update last_used column
    UPDATE "user"."account_sessions"
    SET last_used = (NOW() AT TIME ZONE 'GMT+8')
    WHERE session_token = p_session_token;

    RETURN QUERY SELECT 'OK'::VARCHAR, u.id, u.username, u.email, u.created_at, u.display_name
    FROM "user"."accounts" AS u
    WHERE u.id = user_id;
END;
$$ LANGUAGE plpgsql;