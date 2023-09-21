CREATE OR REPLACE FUNCTION "user"."find_user_hashed_password"(
   p_username varchar(64)
) RETURNS TABLE (
    message TEXT,
    hashed_password BYTEA
) AS $$
DECLARE
   v_hashed_password BYTEA;
BEGIN
   SELECT "hashed_password" INTO v_hashed_password
   FROM "user"."accounts"
   WHERE "username" = p_username
   LIMIT 1;

   IF v_hashed_password IS NULL THEN
      RETURN QUERY SELECT 'NOT FOUND'::TEXT, NULL::BYTEA;
   END IF;

   RETURN QUERY SELECT NULL::TEXT, v_hashed_password::BYTEA;
EXCEPTION
   WHEN OTHERS THEN
      RETURN QUERY SELECT 'ERROR'::TEXT, NULL::BYTEA;
END;
$$ LANGUAGE plpgsql;