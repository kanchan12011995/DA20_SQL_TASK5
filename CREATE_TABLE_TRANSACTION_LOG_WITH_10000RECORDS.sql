CREATE TABLE IF NOT EXISTS transaction_log (
    transaction_id SERIAL PRIMARY KEY,
    transaction_date DATE NOT NULL,
    amount NUMERIC(12,2) CHECK (amount > 0),
    transaction_type VARCHAR(20) CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Transfer')),
    status VARCHAR(20) DEFAULT 'Success' CHECK (status IN ('Success', 'Pending', 'Failed')),
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    bank_id INT NOT NULL,
    
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (bank_id) REFERENCES bank(id)
);


INSERT INTO transaction_log (
    transaction_date,
    amount,
    transaction_type,
    status,
    customer_id,
    employee_id,
    bank_id
)
SELECT
    current_date - (gs % 60) AS transaction_date,                    -- Random date in past 60 days
    round((gs * random())::numeric, 2) % 100000 + 100 AS amount,     -- ₹100–₹100,000 range
    CASE 
        WHEN gs % 5 = 0 THEN 'Transfer'
        WHEN gs % 3 = 0 THEN 'Withdrawal'
        ELSE 'Deposit'
    END AS transaction_type,
    CASE 
        WHEN gs % 7 = 0 THEN 'Failed'
        WHEN gs % 4 = 0 THEN 'Pending'
        ELSE 'Success'
    END AS status,
    (SELECT customer_id FROM customer ORDER BY random() LIMIT 1),
    (SELECT employee_id FROM employee ORDER BY random() LIMIT 1),
    (SELECT id FROM bank ORDER BY random() LIMIT 1)
FROM generate_series(1, 10000) gs;


SELECT * FROM transaction_log;
