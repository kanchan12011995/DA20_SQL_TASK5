CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY ,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    address VARCHAR(255),
    phone_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE,
    pan_number VARCHAR(10) UNIQUE,
    aadhaar_number VARCHAR(12) UNIQUE,
	city VARCHAR(255),
	state VARCHAR(255),
	zipcode VARCHAR(255),
	Balance DECIMAL(10,2) DEFAULT 0,
	account_number VARCHAR(255) UNIQUE,
    account_type account_type_enum  NOT NULL,
    account_status VARCHAR(20) DEFAULT 'Active' CHECK(account_status IN ('Active', 'Inactive', 'Closed')),
    date_opened TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    bank_id INT,
    FOREIGN KEY (bank_id) REFERENCES bank(id)
);

Create type account_type_enum as ENUM(c);

Select * from customer;

 
-- Insert 500 records
INSERT INTO customer (
    first_name, last_name, date_of_birth, address,
    phone_number, email, pan_number, aadhaar_number,
    city, state, zipcode, Balance, account_number,
    account_type, account_status, bank_id
)
SELECT
    'First_' || gs AS first_name,
    'Last_' || gs AS last_name,
    date '1970-01-01' + (random() * 18000)::int AS date_of_birth,
    'Street ' || gs AS address,
    '91' || LPAD((random()*100000000)::bigint::text, 8, '0') AS phone_number,
    'user' || gs || '@example.com' AS email,
    substring(md5(random()::text), 1, 10) AS pan_number,
    LPAD((random()*100000000000)::bigint::text, 12, '0') AS aadhaar_number,
    'City_' || ((random()*50)::int) AS city,
    'State_' || ((random()*30)::int) AS state,
    LPAD((random()*100000)::int::text, 6, '0') AS zipcode,
    round((random()*100000)::numeric, 2) AS Balance,
    'ACCT-' || gs AS account_number,
    (ARRAY['Savings', 'Checking', 'Loan','Credit'])[floor(random()*3)+1]::account_type_enum AS account_type,
    (ARRAY['Active','Inactive','Closed'])[floor(random()*3)+1] AS account_status,
    (random()*5)::int + 1 AS bank_id
FROM generate_series(501, 8000) gs;
