DROP TRIGGER IF EXISTS set_display_name_default_trigger ON "user"."accounts";
DROP FUNCTION IF EXISTS "public".set_display_name_default();

CREATE OR REPLACE FUNCTION "user".set_display_name_default()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW."display_name" IS NULL THEN
        NEW."display_name" := NEW."username";
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_display_name_default_trigger
BEFORE INSERT ON "user"."accounts"
FOR EACH ROW
EXECUTE FUNCTION "user".set_display_name_default();