CREATE OR REPLACE FUNCTION "user".check_session_token(p_session_token VARCHAR, p_browser_info TEXT)
RETURNS TABLE (
  message VARCHAR,
  account_id INT,
  username VARCHAR(64),
  email VARCHAR,
  created_at TIMESTAMP
) AS $$
DECLARE
  user_id INT;
BEGIN
  -- Find the user_id associated with the session_token
  SELECT acc_ses.account_id INTO user_id
  FROM "user"."account_sessions" AS acc_ses
  WHERE acc_ses.session_token = p_session_token;
  
  -- No matching session token...
  IF NOT FOUND THEN
    RETURN QUERY SELECT 'INVALID'::VARCHAR, NULL::INT, NULL::VARCHAR, NULL::VARCHAR, NULL::TIMESTAMP;
  END IF;

  -- Check for expiration and delete if expired
  DELETE FROM "user"."account_sessions"
  WHERE session_token = p_session_token
  AND expiry_time < (NOW() AT TIME ZONE 'GMT+8');
  
  -- Token expired...
  IF NOT FOUND THEN
    RETURN QUERY SELECT 'EXPIRED'::VARCHAR, NULL::INT, NULL::VARCHAR, NULL::VARCHAR, NULL::TIMESTAMP;
  END IF;

  -- Check browser_info
  SELECT COUNT(*) INTO user_id
  FROM "user"."account_sessions" AS acc_ses
  WHERE acc_ses.session_token = p_session_token
  AND lower(acc_ses.browser_info) = lower(p_browser_info);
  
  -- Browser info doesn't match...
  IF user_id = 0 THEN
    -- Session token is likely compromised, so delete it.
    DELETE FROM "user"."account_sessions"
    WHERE session_token = p_session_token;

    RETURN QUERY SELECT 'BROWSER'::VARCHAR, NULL::INT, NULL::VARCHAR, NULL::VARCHAR, NULL::TIMESTAMP;
  END IF;

  -- Update last_used column
  UPDATE "user"."account_sessions"
  SET last_used = (NOW() AT TIME ZONE 'GMT+8')
  WHERE session_token = p_session_token;

  RETURN QUERY SELECT 'OK'::VARCHAR, u.id, u.username, u.email, u.created_at
  FROM "user"."accounts" AS u
  WHERE u.id = user_id;
END;
$$ LANGUAGE plpgsql;

