-- Manufacturer
INSERT INTO automobile.manufacturer (name, description) VALUES
('Toyota', 'A multinational automotive manufacturer headquartered in Japan.'),
('Honda', 'A Japanese public multinational conglomerate known for manufacturing automobiles.'),
('BMW', 'A German multinational company which produces luxury vehicles and motorcycles.'),
('Hyundai', 'A South Korean multinational automotive manufacturer.'),
('Tesla', 'An American electric vehicle and clean energy company.'),
('Nissan', 'A Japanese multinational automobile manufacturer.'),
('Mercedes-Benz', 'A German global automobile marque and a subsidiary of Daimler AG.'),
('Volkswagen', 'A German motor vehicle manufacturer.'),
('Mitsubishi', 'A Japanese multinational automotive manufacturer.'),
('Kia', 'South Korea''s second-largest automobile manufacturer following the Hyundai Motor Company.');

-- Model table
INSERT INTO automobile.model (manufacturer_id, name, description, category, model_fuel_type) VALUES
(1, 'Corolla Altis', 'Compact car known for its durability and reliability.', 'Sedan', 'Gas'),
(2, 'Civic', 'A line of cars manufactured by Honda.', 'Sedan', 'Hybrid'),
(3, 'i8', 'Plug-in hybrid sports car developed by BMW.', 'Sports Car', 'Plug-in Hybrid'),
(4, 'Tucson', 'A compact crossover SUV produced by Hyundai.', 'SUV', 'Diesel'),
(5, 'Model 3', 'An electric four-door sedan developed by Tesla.', 'Sedan', 'Electric'),
(6, 'Leaf', 'The Nissan Leaf is a compact five-door hatchback electric car.', 'Hatchback', 'Electric'),
(7, 'C-Class', 'A line of compact executive cars produced by Mercedes-Benz.', 'Sedan', 'Diesel'),
(8, 'Golf', 'A compact car produced by the German automotive manufacturer Volkswagen.', 'Hatchback', 'Gas'),
(9, 'Outlander', 'A crossover SUV manufactured by Japanese automaker Mitsubishi.', 'SUV', 'Hybrid'),
(10, 'Sorento', 'A mid-size crossover SUV produced by South Korean manufacturer Kia.', 'SUV', 'Diesel');

-- Vehicle table
-- generate random registration plates in the format used in Singapore.
INSERT INTO automobile.vehicle (model_id, registration_plate) VALUES
(1, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(2, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(3, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(4, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(5, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(6, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(7, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(8, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(9, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(10, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(1, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(2, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(3, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(4, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(5, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(6, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(7, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(8, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(9, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0')),
(10, 'S' || LPAD(FLOOR(RANDOM() * 999999)::TEXT, 7, '0'));

-- Repeat the last INSERT statement as needed to create more vehicles
