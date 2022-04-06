USE employees;

-- WHat is the overall average salary?
SELECT avg(salary) FROM salaries;

-- find all employees whose current salary > overall average salry

SELECT * FROM salaries
JOIN employees useing USING(emp_no)
WHERE salary > (SELECT AVG(salary) FROM salaries)
AND salaries.to_date > NOW();

-- Find all the deparment managers and their date of birth. 
 ## Get emp_no for dept managers
 SELECT emp_no FROM dept_manager
 WHERE to_date > NOW();
 
 ## Use these emp_no to find their date of birth
 SELECT first_name, last_name, birth_date
 FROM employees
 WHERE emp_no IN (SELECT emp_no FROM dept_manager 
 WHERE to_date > NOW());
 
 -- Example where Table Subqueries return an entire table
 
 -- Find all employees wiht first name starting with 'geor'.
 -- Then join wiht salary table and list first_name, last_name, and salary. 
 
 SELECT * from employees
 WHERE first_name like 'geor%';
 
 SELECT table1.first_name, table1.last_name, salary
 FROM (SELECT * from employees
 WHERE first_name like 'geor%') as table1
 JOIN salaries USING (emp_no); 
 
 ## Every derived table has to have its own alias
 
 -- There are also times that you can use subqueries in a "SELECT" statement
 SELECT *, (SELECT avg(salary) FROM salaries WHERE to_date > now())
 from salaries;