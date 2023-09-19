-- Migration to just solve ambigiouity issues in referencing the `username` and `email` columns in the `user.accounts` table.
CREATE OR REPLACE FUNCTION "user".check_user_availability(username TEXT, email TEXT)
RETURNS TEXT AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM "user"."accounts" WHERE "user"."accounts".username = $1) THEN
        RETURN 'USERNAME';
    ELSIF EXISTS (SELECT 1 FROM "user"."accounts" WHERE "user"."accounts".email = $2) THEN
        RETURN 'EMAIL';
    ELSE
        RETURN 'OK';
    END IF;
END;
$$ LANGUAGE plpgsql;