-- NOTE: Same as V2.6__Update_Registration_Availablity_Function.sql
-- Just updated messages to be easier to use on nodejs side...

CREATE OR REPLACE FUNCTION check_user_availability(username TEXT, email TEXT)
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
