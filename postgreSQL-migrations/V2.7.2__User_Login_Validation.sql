CREATE OR REPLACE FUNCTION validate_user_credentials(
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