CREATE OR REPLACE FUNCTION "user".delete_session_token(p_session_token VARCHAR)
RETURNS TABLE (message TEXT) AS $$
BEGIN
  DELETE FROM "user"."account_sessions"
  WHERE session_token = p_session_token;

  IF FOUND THEN
    RETURN QUERY SELECT 'OK'::TEXT;
  ELSE
    RETURN QUERY SELECT 'INVALID'::TEXT;
  END IF;
END;
$$ LANGUAGE plpgsql;
