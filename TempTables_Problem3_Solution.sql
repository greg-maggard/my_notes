Use jemison_1757;

-- These are the class notes on how to work through the create table exervises. 

-- PROBLEM 3: Find out how the current average pay in each department compares to the overall, historical average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department right now to work for? The worst?
# This will need some chopping up. 

SELECT AVG(salary), stddev(salary) from employees.salaries;

# Sacing my values for later.. that's what variables do (with a name). Use temp table
CREATE TEMPORARY TABLE historical_aggregates AS (
SELECT AVG(salary), stddev(salary) from employees.salaries);
#select avg(salary) gives us one single avg for everybody

SELECT dept_name, avg(salary) AS department_current_average
FROM employees.salaries
JOIN employees.dept_emp USING(emp_no)
JOIN employees.departments USING (dept_no)
WHERE employees.dept_emp.to_date > curdate()
AND employees.salaries.to_date > CURDATE()
group by dept_name;

CREATE TEMPORARY TABLE current_info AS (
SELECT dept_name, avg(salary) AS department_current_average
FROM employees.salaries
JOIN employees.dept_emp USING(emp_no)
JOIN employees.departments USING (dept_no)
WHERE employees.dept_emp.to_date > curdate()
AND employees.salaries.to_date > CURDATE()
group by dept_name);

SELECT * FROM current_info;

-- Add on all the columns we'll end up needing:
ALTER TABLE current_info add historic_avg FLOAT(10,2);
ALTER TABLE current_info ADD historic_std FLOAT(10,2);
ALTER TABLE current_info ADD zscore FLOAT(10,2);

SELECT * FROM current_info;

-- Set the avg and std
UPDATE current_info SET historic_avg = (SELECT avg_salary FROM historic_aggregates);
UPDATE current_info SET historic_avg = (SELECT std_salary FROM historic_aggregates);

SELECT * FROM current_info;

-- Update the zscore to hold the calculated z scores
UPDATE current_info 
set zscore = (department_current_average - historic_avg) / historic_std;

SELECT * FROM current_info
ORDER BY zscore DESC;

-- If this has you feeling like you want to scream (it does) then don't feel bad. This was a very difficult challenge. 
-- Ryan added some links to places where you can go to practice SQL stuff.




