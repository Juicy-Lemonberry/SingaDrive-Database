CREATE OR REPLACE FUNCTION check_session_token(session_token VARCHAR)
RETURNS TABLE (
  message VARCHAR,
  username TEXT,
  email TEXT,
  created_at TIMESTAMP
) AS $$
DECLARE
  user_id INT;
BEGIN
  -- Find the user_id associated with the session_token
  SELECT account_id INTO user_id
  FROM "user"."account_sessions"
  WHERE session_token = session_token;
  
  -- No matching session token...
  IF NOT FOUND THEN
    RETURN QUERY SELECT 'INVALID'::VARCHAR, NULL, NULL, NULL;
  END IF;

  -- Check for expiration
  DELETE FROM "user"."account_sessions"
  WHERE session_token = session_token
  AND expiry_time < NOW();
    -- Token expired...
  IF NOT FOUND THEN
    RETURN QUERY SELECT 'EXPIRED'::VARCHAR, NULL, NULL, NULL;
  END IF;

  RETURN QUERY SELECT 'OK'::VARCHAR, u.username, u.email, u.created_at
  FROM "user"."accounts" u
  WHERE u.id = user_id;
END;
$$ LANGUAGE plpgsql;
