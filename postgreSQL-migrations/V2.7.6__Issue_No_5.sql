DROP FUNCTION IF EXISTS "user".validate_user_credentials;

CREATE OR REPLACE FUNCTION "user"."find_user_hashed_password"(
   p_username varchar(64)
) RETURNS text AS $$
DECLARE
   v_hashed_password text;
BEGIN
   SELECT "hashed_password" INTO v_hashed_password
   FROM "user"."accounts"
   WHERE "username" = p_username
   LIMIT 1;

   IF v_hashed_password IS NULL THEN
      RAISE EXCEPTION 'Username not found: %', p_username;
   END IF;

   RETURN v_hashed_password;
EXCEPTION
   WHEN OTHERS THEN
      RETURN 'NOT FOUND';
END;
$$ LANGUAGE plpgsql;