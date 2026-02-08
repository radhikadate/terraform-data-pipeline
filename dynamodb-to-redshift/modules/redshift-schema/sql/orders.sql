-- Orders table schema
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(255) PRIMARY KEY,
    status VARCHAR(255),
    type VARCHAR(255)
);
