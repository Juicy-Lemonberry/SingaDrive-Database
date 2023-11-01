CREATE OR REPLACE FUNCTION "user"."update_account_credentials"(
    "p_session_token" VARCHAR,
    "p_browser_info" TEXT,
    "p_hashed_password" BYTEA DEFAULT NULL,
    "p_email" VARCHAR DEFAULT NULL
)
RETURNS TABLE ("message" TEXT) AS $$
DECLARE
    "v_account_id" INT;
    "v_expiry_time" TIMESTAMP;
    "v_browser_info" TEXT;
BEGIN
    -- Check all conditions at once
    SELECT "account_id", "expiry_time", "browser_info" 
    INTO "v_account_id", "v_expiry_time", "v_browser_info"
    FROM "user"."account_sessions"
    WHERE "session_token" = "p_session_token";

    -- Session token doesn't exist
    IF "v_account_id" IS NULL THEN
        RETURN QUERY SELECT 'INVALID'::TEXT;
        RETURN;
    END IF;

    -- Session token is expired
    IF "v_expiry_time" <= NOW() THEN
        DELETE FROM "user"."account_sessions" WHERE "session_token" = "p_session_token";
        RETURN QUERY SELECT 'EXPIRED'::TEXT;
        RETURN;
    END IF;

    -- Browser info doesn't match
    IF "v_browser_info" != "p_browser_info" THEN
        DELETE FROM "user"."account_sessions" WHERE "session_token" = "p_session_token";
        RETURN QUERY SELECT 'BROWSER'::TEXT;
        RETURN;
    END IF;

    -- Update the account's hashed_password and email if provided
    UPDATE "user"."accounts"
    SET "hashed_password" = COALESCE("p_hashed_password", "hashed_password"),
        "email" = COALESCE("p_email", "email")
    WHERE "id" = "v_account_id";

    -- Successful update
    RETURN QUERY SELECT 'OK'::TEXT;

END;
$$ LANGUAGE plpgsql;

