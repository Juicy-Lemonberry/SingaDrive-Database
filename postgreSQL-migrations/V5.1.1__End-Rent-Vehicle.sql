CREATE OR REPLACE FUNCTION automobile.end_vehicle_rental(
    p_session_token VARCHAR,
    p_browser_info TEXT,
    p_registration_plate VARCHAR(8)
)
RETURNS TABLE (message TEXT) SECURITY DEFINER AS $$
DECLARE
    v_account_id INT;
	v_username VARCHAR(64);
    v_current_timestamp TIMESTAMP WITHOUT TIME ZONE;
BEGIN
    -- Convert current timestamp to GMT+8
    SELECT CURRENT_TIMESTAMP AT TIME ZONE 'UTC' AT TIME ZONE 'GMT+8' INTO v_current_timestamp;

    -- Check the session token and get account_id
    SELECT account_id, username INTO v_account_id, v_username
    FROM "user".check_session_token(p_session_token, p_browser_info)
    LIMIT 1;

    -- If account_id is NULL, the user is not logged in or the session is invalid
    IF v_account_id IS NULL THEN
        message := 'USER';
        RETURN NEXT;
        RETURN;
    END IF;

    -- Check if the vehicle is currently rented by the user
    IF NOT EXISTS (
		SELECT *
		FROM automobile.get_user_rented_vehicle(v_username) 
		WHERE registration_plate = p_registration_plate
	) THEN
        message := 'NOT RENTED';
        RETURN NEXT;
        RETURN;
    END IF;

    -- Update vehicle_booking to set end_date
    UPDATE automobile.vehicle_booking vb
    SET end_date = v_current_timestamp
    FROM automobile.vehicle v
    WHERE v.registration_plate = p_registration_plate
      AND vb.account_id = v_account_id
      AND vb.end_date IS NULL;

    IF FOUND THEN
        message := 'SUCCESS';
    ELSE
        message := 'UPDATE FAILED';
    END IF;

    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;