DROP TABLE IF EXISTS "user"."account_sessions";

CREATE TABLE "user"."account_sessions" (
    id SERIAL PRIMARY KEY,
    account_id INT REFERENCES "user"."accounts"(id),
    session_token VARCHAR UNIQUE,
    browser_info TEXT,
    expiry_time TIMESTAMP DEFAULT NOW() + INTERVAL '30 days',
    created_at TIMESTAMP DEFAULT NOW(),
    last_used TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_account_sessions_account_id ON "user"."account_sessions" (account_id);
CREATE INDEX idx_session_token ON "user"."account_sessions" (session_token);