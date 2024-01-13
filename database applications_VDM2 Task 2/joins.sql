SELECT EMPLOYEE.employee_id, EMPLOYEE.first_name, EMPLOYEE.last_name, EMPLOYEE.hire_date, EMPLOYEE.job_title,EMPLOYEE.shop_id, COFFEE_SHOP.shop_name, 
COFFEE_SHOP.city, COFFEE_SHOP.state, COFFEE.coffee_id, COFFEE.supplier_id, COFFEE.coffee_name, COFFEE.price_per_pound
FROM sys.EMPLOYEE
JOIN sys.COFFEE_SHOP
ON EMPLOYEE.shop_id = COFFEE_SHOP.shop_id
JOIN COFFEE
ON EMPLOYEE.shop_id = COFFEE.shop_id;