CREATE TABLE IF NOT EXISTS automobile.vehicle (
    registration_plate VARCHAR(8) PRIMARY KEY,
    model_id INT NOT NULL,
    FOREIGN KEY (model_id) REFERENCES automobile.model (id)
);