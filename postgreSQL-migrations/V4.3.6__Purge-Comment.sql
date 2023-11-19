CREATE OR REPLACE FUNCTION "forum"."purge_comment"(
    p_comment_id INT
)
RETURNS TABLE (
	message TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    l_account_id INT;
BEGIN
	SELECT "account_id" INTO l_account_id 
	FROM "forum"."comments"
	WHERE "id" = p_comment_id;
	
	IF l_account_id IS NULL THEN
		DELETE FROM "forum"."comments"
		WHERE "id" = p_comment_id;
		message := 'SUCCESS';
	ELSE
		-- Comment is still tied to a user,  dont delete.
		message := 'FAILURE';
	END IF;
	RETURN NEXT;
END;
$$;
