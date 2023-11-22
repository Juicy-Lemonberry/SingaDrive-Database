CREATE OR REPLACE FUNCTION automobile.get_vehicles_by_manufacturer(p_manufacturer_id INT)
RETURNS TABLE (
    manufacturer_id INT,
    manufacturer_name VARCHAR(128),
    model_id INT,
    model_name VARCHAR(128),
    category automobile.vehicle_category,
    fuel_type automobile.fuel_type,
    registration_plate VARCHAR(8),
    is_rented BOOLEAN
) SECURITY DEFINER AS $$
BEGIN
    RETURN QUERY
    SELECT
        mf.id,
        mf.name,
        mo.id,
        mo.name,
        mo.category,
        mo.model_fuel_type,
        ve.registration_plate,
        EXISTS (
            SELECT 1
            FROM automobile.vehicle_booking vb
            WHERE vb.registration_plate = ve.registration_plate
            AND vb.end_date IS NULL
        ) AS is_rented
    FROM
        automobile.manufacturer mf
    JOIN automobile.model mo ON mf.id = mo.manufacturer_id
    JOIN automobile.vehicle ve ON mo.id = ve.model_id
    WHERE
        mf.id = p_manufacturer_id;
END;
$$ LANGUAGE plpgsql STABLE;