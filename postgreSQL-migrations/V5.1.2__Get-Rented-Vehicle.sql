CREATE OR REPLACE FUNCTION automobile.get_user_rented_vehicle(p_username VARCHAR(64))
RETURNS TABLE (
    registration_plate VARCHAR(8),
    model_id INT,
    manufacturer_id INT,
    model_name VARCHAR(128),
    manufacturer_name VARCHAR(128),
    category automobile.vehicle_category,
    fuel_type automobile.fuel_type
) SECURITY DEFINER AS $$
BEGIN
    RETURN QUERY
    SELECT
        v.registration_plate,
        m.id AS model_id,
        mf.id AS manufacturer_id,
        m.name AS model_name,
        mf.name AS manufacturer_name,
        m.category,
        m.model_fuel_type AS fuel_type
    FROM
        "user".accounts a
    INNER JOIN automobile.vehicle_booking vb ON a.id = vb.account_id
    INNER JOIN automobile.vehicle v ON vb.registration_plate = v.registration_plate
    INNER JOIN automobile.model m ON v.model_id = m.id
    INNER JOIN automobile.manufacturer mf ON m.manufacturer_id = mf.id
    WHERE
        a.username = p_username
        AND vb.end_date IS NULL;
END;
$$ LANGUAGE plpgsql STABLE;
