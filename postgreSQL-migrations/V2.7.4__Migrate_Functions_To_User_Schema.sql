CREATE OR REPLACE FUNCTION "user".check_session_token(session_token VARCHAR)
RETURNS TABLE (
  message VARCHAR,
  username VARCHAR(64),
  email VARCHAR,
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

DROP FUNCTION IF EXISTS "public".check_session_token(session_token VARCHAR);

CREATE OR REPLACE FUNCTION "user".validate_user_credentials(
    in_username VARCHAR(64),
    in_hashed_password BYTEA
)
RETURNS TABLE (
    message TEXT,
    id INT,
    username VARCHAR(64),
    display_name VARCHAR(64),
    email VARCHAR,
    created_at TIMESTAMP
)
AS $$
BEGIN
    -- username no exists
    IF NOT EXISTS (SELECT 1 FROM "user"."accounts" WHERE "username" = in_username) THEN
        RETURN QUERY (SELECT 'USERNAME'::TEXT, NULL::INT, NULL::VARCHAR(64), NULL::VARCHAR(64), NULL::VARCHAR, NULL::TIMESTAMP);
    END IF;

    -- password is incorrect
    IF NOT EXISTS (SELECT 1 FROM "user"."accounts" WHERE "username" = in_username AND "hashed_password" = in_hashed_password) THEN
        RETURN QUERY (SELECT 'PASSWORD'::TEXT, NULL::INT, NULL::VARCHAR(64), NULL::VARCHAR(64), NULL::VARCHAR, NULL::TIMESTAMP);
    END IF;

    RETURN QUERY SELECT 'OK'::TEXT, "id", "username", "display_name", "email", "created_at"
    FROM "user"."accounts"
    WHERE "username" = in_username;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS "public".validate_user_credentials(in_username VARCHAR(64), in_hashed_password BYTEA);

CREATE OR REPLACE FUNCTION "user".create_account_session(username TEXT, browser_info TEXT)
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
DROP FUNCTION IF EXISTS "public".create_account_session(username TEXT, browser_info TEXT);

DROP FUNCTION IF EXISTS "public".check_user_availability(username TEXT, email TEXT);
CREATE OR REPLACE FUNCTION "user".check_user_availability(username TEXT, email TEXT)
RETURNS TEXT AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM "user"."accounts" WHERE username = $1) THEN
        RETURN 'USERNAME';
    ELSIF EXISTS (SELECT 1 FROM "user"."accounts" WHERE email = $2) THEN
        RETURN 'EMAIL';
    ELSE
        RETURN 'OK';
    END IF;
END;
$$ LANGUAGE plpgsql;
