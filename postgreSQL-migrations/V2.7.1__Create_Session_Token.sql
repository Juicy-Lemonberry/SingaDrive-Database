-- Install pgcrypto extension for hashing...
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION create_account_session(username TEXT, browser_info TEXT)
RETURNS VARCHAR AS $$
DECLARE
  session_token VARCHAR;
  user_id INT;
BEGIN
  SELECT id INTO user_id FROM "user"."accounts" WHERE username = username;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Username not found: %', username;
  END IF;

  session_token := encode(gen_random_bytes(16), 'hex');
  INSERT INTO "user"."account_sessions" (account_id, session_token, browser_info, expiry_time, created_at, last_used)
  VALUES (
      user_id,
      session_token,
      browser_info,
      NOW() + INTERVAL '30 days',
      NOW(),
      NOW()
  );

  RETURN session_token;
END;
$$ LANGUAGE plpgsql;
