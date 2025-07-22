CREATE TABLE IF NOT EXISTS account_opening_log (
    account_opening_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    bank_id INT NOT NULL,
    employee_id INT NOT NULL,
    opening_date DATE DEFAULT CURRENT_DATE,
    opening_method VARCHAR(50) CHECK(opening_method IN ('Online', 'In Branch', 'Agent Assisted')),
    initial_deposit NUMERIC(12,2) CHECK(initial_deposit >= 0),
    status VARCHAR(20) DEFAULT 'Initiated' CHECK(status IN ('Initiated', 'Verified', 'Completed')),

    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_bank FOREIGN KEY (bank_id) REFERENCES bank(id),
    CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

INSERT INTO account_opening_log (
    customer_id,
    bank_id,
    employee_id,
    opening_date,
    opening_method,
    initial_deposit,
    status
)
SELECT
    (SELECT customer_id FROM customer ORDER BY random() LIMIT 1),
    (SELECT id FROM bank ORDER BY random() LIMIT 1),
    (SELECT employee_id FROM employee ORDER BY random() LIMIT 1),
    current_date - ((gs % 90))::int,  -- Within past 90 days
    (ARRAY['Online', 'In Branch', 'Agent Assisted'])[floor(random() * 3 + 1)],
    round((gs * random())::numeric, 2) % 50000 + 500,  -- ₹500 to ₹50K initial deposit
    (ARRAY['Initiated', 'Verified', 'Completed'])[floor(random() * 3 + 1)]
FROM generate_series(1, 2000) gs;

SELECT * FROM ACCOUNT_OPENING_LOG;
