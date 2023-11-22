CREATE TABLE IF NOT EXISTS automobile.model (
    id SERIAL PRIMARY KEY,
    manufacturer_id INT NOT NULL,
    name VARCHAR(128) NOT NULL,
    description TEXT,
    category automobile.vehicle_category NOT NULL,
    model_fuel_type automobile.fuel_type NOT NULL,
    FOREIGN KEY (manufacturer_id) REFERENCES automobile.manufacturer (id)
);