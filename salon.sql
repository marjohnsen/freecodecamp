-- Create tables for salon database

-- Table: customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(15) UNIQUE
);

-- Table: services
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

-- Table: appointments
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    service_id INT REFERENCES services(service_id),
    time VARCHAR(50)
);

-- Insert initial data into services
INSERT INTO services (name) VALUES ('Haircut'), ('Color'), ('Styling');
