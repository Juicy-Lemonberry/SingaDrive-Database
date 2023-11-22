CREATE TABLE IF NOT EXISTS automobile.vehicle_booking (
    registration_plate VARCHAR(8) NOT NULL,
    account_id INT NOT NULL,
    start_date TIMESTAMP WITHOUT TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC' AT TIME ZONE 'GMT+8'),
    end_date TIMESTAMP WITHOUT TIME ZONE,
    FOREIGN KEY (registration_plate) REFERENCES automobile.vehicle (registration_plate),
    FOREIGN KEY (account_id) REFERENCES "user".accounts (id),
    PRIMARY KEY (registration_plate, account_id, start_date)
);