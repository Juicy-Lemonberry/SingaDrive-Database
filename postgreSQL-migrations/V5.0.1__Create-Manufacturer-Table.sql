CREATE TABLE IF NOT EXISTS automobile.manufacturer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    description TEXT
);