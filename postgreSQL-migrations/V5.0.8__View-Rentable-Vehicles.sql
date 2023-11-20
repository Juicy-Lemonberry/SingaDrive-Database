CREATE OR REPLACE VIEW automobile.rentable_vehicles AS
SELECT 
    v.registration_plate,
    m.id AS model_id,
    m.name AS model_name,
    mf.id AS manufacturer_id,
    mf.name AS manufacturer_name,
    m.model_fuel_type AS fuel_type,
    m.category
FROM 
    automobile.vehicle v
JOIN 
    automobile.model m ON v.model_id = m.id
JOIN 
    automobile.manufacturer mf ON m.manufacturer_id = mf.id
LEFT JOIN 
    automobile.vehicle_booking vb ON v.registration_plate = vb.registration_plate
    AND vb.end_date IS NULL
WHERE 
    vb.registration_plate IS NULL;