CREATE OR REPLACE FUNCTION "user"."find_user_hashed_password"(
   p_username varchar(64)
) RETURNS TABLE (
    message TEXT,
    hashed_password BYTEA
) AS $$
DECLARE
   v_hashed_password BYTEA;
BEGIN
   SELECT "user"."accounts"."hashed_password" INTO v_hashed_password
   FROM "user"."accounts"
   WHERE "username" = p_username
   LIMIT 1;

   IF v_hashed_password IS NULL THEN
      RETURN QUERY SELECT 'NOT FOUND'::TEXT, NULL::BYTEA;
   END IF;

   RETURN QUERY SELECT NULL::TEXT, v_hashed_password::BYTEA;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "user".create_account_session(p_username TEXT, p_browser_info TEXT)
RETURNS VARCHAR AS $$
DECLARE
  new_session_token VARCHAR;
  user_id INT;
  new_expiry_time TIMESTAMP;
BEGIN
  SELECT id INTO user_id FROM "user"."accounts" WHERE "user"."accounts".username = p_username;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Username not found: %', p_username;
  END IF;

  new_session_token := encode(gen_random_bytes(16), 'hex');
  new_expiry_time := (NOW() AT TIME ZONE 'GMT+8') + INTERVAL '30 days';

  INSERT INTO "user"."account_sessions" (account_id, session_token, browser_info, expiry_time, created_at, last_used)
  VALUES (
      user_id,
      new_session_token,
      p_browser_info,
      new_expiry_time,               
      NOW() AT TIME ZONE 'GMT+8',
      NOW() AT TIME ZONE 'GMT+8'
  );

  RETURN new_session_token;
END;
$$ LANGUAGE plpgsql;