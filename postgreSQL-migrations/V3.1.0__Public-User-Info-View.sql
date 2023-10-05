CREATE OR REPLACE VIEW "user"."public_accounts_info" AS
SELECT "id", "username", "display_name", "email", "created_at"
FROM "user"."accounts";
