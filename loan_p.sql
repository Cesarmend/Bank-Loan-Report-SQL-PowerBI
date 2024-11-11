USE `BANK LOAN`;

/*DROP TABLE IF exists `loan_data`;*/

CREATE TABLE loan_data (
    id INT PRIMARY KEY,
    address_state VARCHAR(50),
    application_type VARCHAR(50),
    emp_length VARCHAR(50),
    emp_title VARCHAR(100),
    grade VARCHAR(50),
    home_ownership VARCHAR(50),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(50),
    next_payment_date DATE,
    member_id INT,  -- Use BIGINT if values are large
    purpose VARCHAR(50),
    sub_grade VARCHAR(50),
    term VARCHAR(50),
    verification_status VARCHAR(50),
    annual_income FLOAT,
    dti FLOAT,
    installment FLOAT,
    int_rate FLOAT,
    loan_amount INT,
    total_acc INT,
    total_payment INT
);




/*LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\financial_loan.csv'
INTO TABLE loan_data
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, address_state, application_type, emp_length, emp_title, grade, home_ownership, 
 @issue_date, @last_credit_pull_date, @last_payment_date, loan_status, 
 @next_payment_date, member_id, purpose, sub_grade, term, verification_status, 
 annual_income, dti, installment, int_rate, loan_amount, total_acc, total_payment)
SET 
    issue_date = STR_TO_DATE(@issue_date, '%d/%m/%Y'),
    last_credit_pull_date = STR_TO_DATE(@last_credit_pull_date, '%d/%m/%Y'),
    last_payment_date = STR_TO_DATE(@last_payment_date, '%d/%m/%Y'),
    next_payment_date = STR_TO_DATE(@next_payment_date, '%d/%m/%Y'); */

SELECT *
FROM loan_data;

-- B. Number of total applications or total loan requests --
SELECT COUNT(id) AS 'Total applications'
FROM loan_data;

-- C. Month-to-date applications (current month applications) -- 
SELECT COUNT(id) AS 'Current applications'
from loan_data
WHERE MONTH(issue_date)= 12 AND YEAR(issue_date)= 2021;

-- D. Previous to month --
SELECT COUNT(id) AS 'Current applications'
from loan_data
WHERE MONTH(issue_date)= 11 AND YEAR(issue_date)= 2021;

-- E. Total disbursed amount current month (last month available) --
SELECT SUM(loan_amount) AS "MTD Funded amount"
FROM loan_data
WHERE MONTH(issue_date)=12 AND YEAR(issue_date) = 2021;

-- F. Disbursed amount in the previous month --
SELECT SUM(loan_amount) AS "PMTD Funded amount"
FROM loan_data
WHERE MONTH(issue_date)=11 AND YEAR(issue_date) = 2021;

-- G. Amount received from cx's moth-to-date -- 
SELECT SUM(total_payment) AS "MTD Total Amount Received" FROM loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- G. Amount received from cx's previous month -- 
SELECT SUM(total_payment) AS "PMTD Total Amount Received" FROM loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- H. Average interest rate --
SELECT ROUND(AVG(int_rate) * 100, 2) AS "Average interest rate" FROM loan_data;

-- I. Average interest rate Month-to-date (MTD) --
SELECT ROUND(AVG(int_rate) * 100, 2) AS "Average interest rate" FROM loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- J. Average interest rate Past Month-to-date (PMTD) --
SELECT ROUND(AVG(int_rate) * 100, 2) AS "Average interest rate" FROM loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- K. Average DTI Month-to-date -- 
SELECT ROUND(AVG(DTI)*100, 2) AS AVG_DTI FROM loan_data
WHERE MONTH (issue_date) = 12 and YEAR(issue_date) = 2021;

-- I. Average DTI Past Month to date -- 
SELECT ROUND(AVG(DTI)*100, 2) AS AVG_DTI FROM loan_data
WHERE MONTH (issue_date) = 11 and YEAR(issue_date) = 2021;

-- Numer of Unique values in a column -- 
SELECT COUNT(distinct loan_status) AS "Unique loan status"
FROM loan_data;

-- Count for those unique values --
SELECT loan_status, COUNT(*) AS "Count of occurences" 
FROM loan_data
GROUP BY loan_status
ORDER BY 2 DESC;

-- J. Good loan percentage --
SELECT* FROM loan_data;
SELECT
	ROUND((COUNT(CASE WHEN loan_status = "Fully Paid" OR loan_status = 'Current' THEN id END)*100)
    /
    COUNT(id),2) AS "Good loan percentage"
FROM loan_data;

-- Number Good loan applications --
SELECT COUNT(id) AS "Good Loan Applications" FROM loan_data
WHERE loan_status= "fully Paid" OR loan_status= "Fully Paid";
