CREATE OR REPLACE FUNCTION automobile.get_vehicles_by_model(p_model_id INT)
RETURNS TABLE (
    model_id INT,
    model_name VARCHAR(128),
    manufacturer_id INT,
    manufacturer_name VARCHAR(128),
    category automobile.vehicle_category,
    fuel_type automobile.fuel_type,
    registration_plate VARCHAR(8),
    is_rented BOOLEAN
) SECURITY DEFINER AS $$
BEGIN
    RETURN QUERY
    SELECT
        mo.id AS model_id,
        mo.name AS model_name,
        mf.id AS manufacturer_id,
        mf.name AS manufacturer_name,
        mo.category,
        mo.model_fuel_type AS fuel_type,
        ve.registration_plate,
        EXISTS (
            SELECT 1
            FROM automobile.vehicle_booking vb
            WHERE vb.registration_plate = ve.registration_plate
            AND vb.end_date IS NULL
        ) AS is_rented
    FROM
        automobile.model mo
    JOIN automobile.manufacturer mf ON mo.manufacturer_id = mf.id
    JOIN automobile.vehicle ve ON mo.id = ve.model_id
    WHERE
        mo.id = p_model_id;
END;
$$ LANGUAGE plpgsql STABLE;