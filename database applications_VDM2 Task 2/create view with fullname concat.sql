CREATE VIEW `employee_full_name` AS
SELECT CONCAT(EMPLOYEE.first_name, ' ', EMPLOYEE.last_name)
AS `employee_full_name`
FROM sys.EMPLOYEE;
