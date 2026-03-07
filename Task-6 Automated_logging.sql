USE anjidb;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE employee_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    action_type VARCHAR(10),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(200)
);DELIMITER $$

CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_logs(emp_id, action_type, description)
    VALUES (NEW.emp_id, 'INSERT', 'New employee added');
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_logs(emp_id, action_type, description)
    VALUES (NEW.emp_id, 'UPDATE', 'Employee data updated');
END$$

DELIMITER ;

CREATE VIEW daily_activity_report AS
SELECT 
    DATE(action_time) AS activity_date,
    action_type,
    COUNT(*) AS total_actions
FROM employee_logs
GROUP BY DATE(action_time), action_type;

INSERT INTO employees(name, department, salary)
VALUES ('Rahul', 'IT', 45000);

UPDATE employees
SET salary = 50000
WHERE emp_id = 1;

SELECT * FROM employee_logs;

SELECT * FROM daily_activity_report;

