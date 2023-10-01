CREATE OR REPLACE FUNCTION "user".check_session_token(session_token VARCHAR, browser_info TEXT)
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
  FROM "user"."account_sessions" acc_ses
  WHERE acc_ses.session_token = session_token;
  
  -- No matching session token...
  IF NOT FOUND THEN
    RETURN QUERY SELECT 'INVALID'::VARCHAR, NULL, NULL, NULL, NULL;
  END IF;

  -- Check for expiration
  DELETE FROM "user"."account_sessions" acc_ses
  WHERE acc_ses.session_token = session_token
  AND acc_ses.expiry_time < NOW();
  
  -- Token expired...
  IF NOT FOUND THEN
    RETURN QUERY SELECT 'EXPIRED'::VARCHAR, NULL, NULL, NULL, NULL;
  END IF;

  -- Check browser_info
  SELECT COUNT(*) INTO user_id
  FROM "user"."account_sessions" acc_ses
  WHERE acc_ses.session_token = session_token
  AND lower(acc_ses.browser_info) = lower(browser_info);
  
  -- Browser info doesn't match...
  IF user_id = 0 THEN
    -- Session token is likely compromised, so delete it.
    DELETE FROM "user"."account_sessions" acc_ses
    WHERE acc_ses.session_token = session_token;

    RETURN QUERY SELECT 'BROWSER'::VARCHAR, NULL, NULL, NULL, NULL;
  END IF;

  RETURN QUERY SELECT 'OK'::VARCHAR, u.id, u.username, u.email, u.created_at
  FROM "user"."accounts" u
  WHERE u.id = user_id;
END;
$$ LANGUAGE plpgsql;

