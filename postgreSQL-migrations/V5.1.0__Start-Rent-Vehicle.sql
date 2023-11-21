CREATE OR REPLACE FUNCTION automobile.rent_vehicle(
    p_session_token VARCHAR,
    p_browser_info TEXT,
    p_registration_plate VARCHAR(8)
)
RETURNS TABLE (message TEXT) SECURITY DEFINER AS $$
DECLARE
    v_account_id INT;
	v_username VARCHAR(64);
BEGIN
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
	
	-- Check if user currently booked a vehicle
	IF EXISTS (
		SELECT *
		FROM automobile.get_user_rented_vehicle(v_username) 
	) THEN
		message := 'RENTING';
		RETURN NEXT;
		RETURN;
	END IF;

    -- Check if the vehicle is rentable
    IF NOT EXISTS (
        SELECT *
        FROM automobile.rentable_vehicles
        WHERE registration_plate = p_registration_plate
    ) THEN
        message := 'RENTED';
        RETURN NEXT;
        RETURN;
    END IF;

    -- Insert into vehicle_booking and return SUCCESS
    INSERT INTO automobile.vehicle_booking (registration_plate, account_id)
    VALUES (
        p_registration_plate,
        v_account_id
    );

    message := 'SUCCESS';
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;