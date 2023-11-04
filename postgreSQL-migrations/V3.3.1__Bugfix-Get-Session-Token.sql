CREATE OR REPLACE FUNCTION "user"."get_session_tokens"(
    p_session_token VARCHAR,
    p_browser_info TEXT
)
RETURNS TABLE (
    message TEXT,
    session_token VARCHAR,
    browser_info TEXT,
    expiry_time TIMESTAMP,
    created_at TIMESTAMP,
    last_used TIMESTAMP
)
AS $$
DECLARE
    l_account_id INT;
BEGIN
    -- find account id...
    SELECT account_id INTO l_account_id
    FROM "user"."account_sessions" s
    WHERE s.session_token = p_session_token;

    -- find all session token matching the account id.
    RETURN QUERY
    SELECT
        CASE
			WHEN s.session_token IS NULL THEN 'INVALID'
            WHEN s.expiry_time < NOW() AT TIME ZONE 'Asia/Singapore' THEN 'EXPIRED'
            WHEN lower(s.browser_info) <> lower(p_browser_info) THEN 'BROWSER'
            ELSE 'OK'
        END AS message,
        s.session_token,
        s.browser_info,
        s.expiry_time,
        s.created_at,
        s.last_used
    FROM "user"."account_sessions" s
    WHERE s.account_id = l_account_id;
END;
$$ LANGUAGE plpgsql;