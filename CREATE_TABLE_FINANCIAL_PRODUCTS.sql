CREATE TABLE IF NOT EXISTS financial_products (
    product_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    bank_id INT NOT NULL,
    employee_id INT,
    
    insurance_plan VARCHAR(100),
    insurance_amount NUMERIC(12,2),
    insurance_status VARCHAR(20) CHECK (insurance_status IN ('Active', 'Expired', 'Pending')),

    loan_type VARCHAR(50),
    loan_amount NUMERIC(12,2),
    loan_status VARCHAR(20) CHECK (loan_status IN ('Approved', 'Pending', 'Rejected')),

    fd_amount NUMERIC(12,2),
    fd_duration_months INT,
    fd_maturity_date DATE,

    created_on DATE DEFAULT CURRENT_DATE,

    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (bank_id) REFERENCES bank(id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

INSERT INTO financial_products (
    customer_id,
    bank_id,
    employee_id,
    insurance_plan,
    insurance_amount,
    insurance_status,
    loan_type,
    loan_amount,
    loan_status,
    fd_amount,
    fd_duration_months,
    fd_maturity_date
)
SELECT
    (SELECT customer_id FROM customer ORDER BY random() LIMIT 1),
    (SELECT id FROM bank ORDER BY random() LIMIT 1),
    (SELECT employee_id FROM employee ORDER BY random() LIMIT 1),
    (ARRAY['Health Shield', 'Life Secure', 'Vehicle Protect', 'Home Safety'])[floor(random()*4)],
    round((random()*250000 + 50000)::numeric, 2),  -- ₹50K–₹3L
    (ARRAY['Active', 'Expired', 'Pending'])[floor(random()*3)],
    (ARRAY['Personal Loan', 'Home Loan', 'Car Loan', 'Education Loan'])[floor(random()*4)],
    round((random()*2000000 + 100000)::numeric, 2), -- ₹1L–₹21L
    (ARRAY['Approved', 'Pending', 'Rejected'])[floor(random()*3)],
    round((random()*1000000 + 50000)::numeric, 2),  -- ₹50K–₹10L FD
    (floor(random()*60) + 12),           -- FD term: 12–72 months
    CURRENT_DATE + ((floor(random()*60) + 12) || ' months')::interval
FROM generate_series(1, 1000);

SELECT * FROM FINANCIAL_PRODUCTS;