CREATE TABLE loans (
    id INT,
    address_state VARCHAR(2),
    application_type VARCHAR(20),
    emp_length VARCHAR(20),
    emp_title VARCHAR(100),
    grade CHAR(1),
    home_ownership VARCHAR(20),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(20),
    next_payment_date DATE,
    member_id INT,
    purpose VARCHAR(50),
    sub_grade VARCHAR(4),
    term VARCHAR(20),
    verification_status VARCHAR(30),
    annual_income FLOAT,
    dti FLOAT,
    installment FLOAT,
    int_rate FLOAT,
    loan_amount FLOAT,
    total_acc INT,
    total_payment FLOAT
);

-- Total Loan Applications
SELECT 
    COUNT(*) AS total_loan_applications
FROM
    loans;
    
-- Total Amount Funded
SELECT 
    SUM(loan_amount) AS total_funded_amount
FROM
    loans;
    
-- Total Payment Received
SELECT 
    SUM(total_payment) AS total_payment_received
FROM
    loans;
    
-- Average Interest Rate
SELECT 
    AVG(int_rate) AS average_interest_rate
FROM
    loans;
    
-- Average DTI Rate
SELECT 
    AVG(dti) AS average_dti_rate
FROM
    loans;
    
-- Total Funded Amount by Month
SELECT
    DATE_FORMAT(issue_date, '%Y-%m') AS month,
    SUM(loan_amount) AS total_funded_amount
FROM loans
GROUP BY DATE_FORMAT(issue_date, '%Y-%m')
ORDER BY month
LIMIT 50000;

-- Count of Loans by Status 
SELECT 
    loan_status, COUNT(*) AS num_loans
FROM
    loans
GROUP BY loan_status;

-- Loan Applications by State
SELECT 
    address_state, COUNT(*) AS total_loan_applications
FROM
    loans
GROUP BY address_state
ORDER BY total_loan_applications DESC;

-- Total & Average Payments by Term
 SELECT 
    term,
    COUNT(*) AS num_loans,
    AVG(total_payment) AS avg_payment
FROM
    loans
GROUP BY term;

-- Funded Amount by Employee Title (Top 25)
SELECT 
    emp_title, SUM(loan_amount) AS total_funded
FROM
    loans
GROUP BY emp_title
ORDER BY total_funded DESC
LIMIT 25;

-- Funded Amount by Purpose
SELECT 
    purpose, SUM(loan_amount) AS total_funded
FROM
    loans
GROUP BY purpose
ORDER BY total_funded DESC;

-- Funded Amount by Home Ownership
SELECT 
    home_ownership, SUM(loan_amount) AS total_funded
FROM
    loans
GROUP BY home_ownership
ORDER BY total_funded DESC;

-- Status Breakdown (Good vs. Bad Loans)
SELECT 
    CASE
        WHEN loan_status IN ('Fully Paid' , 'Current') THEN 'Good'
        ELSE 'Bad'
    END AS loan_type,
    COUNT(*) AS num_loans,
    SUM(loan_amount) AS total_funded,
    SUM(total_payment) AS total_received
FROM
    loans
GROUP BY loan_type;

-- Loan Status Table
SELECT
    loan_status,
    COUNT(*) AS num_loans,
    SUM(loan_amount) AS total_funded,
    SUM(total_payment) AS total_received,
    AVG(int_rate) AS avg_interest,
    SUM(
        CASE
            WHEN DATE_FORMAT(issue_date, '%Y-%m') = DATE_FORMAT(CURRENT_DATE, '%Y-%m')
            THEN loan_amount
            ELSE 0
        END
    ) AS mtd_funded
FROM loans
GROUP BY loan_status;

-- Loan Performance Percentages
SELECT 
    ROUND(100.0 * SUM(CASE
                WHEN loan_status IN ('Current' , 'Fully Paid') THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS good_loan_pct,
    ROUND(100.0 * SUM(CASE
                WHEN loan_status = 'Charged Off' THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS bad_loan_pct
FROM
    loans;

-- Monthly Funded and Received Amounts
SELECT
    DATE_FORMAT(issue_date, '%Y-%m') AS month,
    SUM(loan_amount) AS funded,
    SUM(total_payment) AS received
FROM loans
GROUP BY DATE_FORMAT(issue_date, '%Y-%m')
ORDER BY month
LIMIT 50000;

-- Top Purposes for Bad Loans (Charged Off)
SELECT 
    purpose,
    COUNT(*) AS bad_loan_count,
    SUM(total_payment) AS bad_loan_funded
FROM
    loans
WHERE
    loan_status = 'Charged Off'
GROUP BY purpose
ORDER BY bad_loan_funded DESC;




