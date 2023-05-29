--Create a table schema for each of the six CSV files
CREATE TABLE "departments" (
    "dept_no" varchar(10)   NOT NULL,
    "dept_name" varchar(20)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar(10)   NOT NULL,
	 CONSTRAINT pk_dept_emp PRIMARY KEY ("emp_no", "dept_no"),
	 CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY ("dept_no") REFERENCES "departments" ("dept_no")
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(10)   NOT NULL,
    "emp_no" int   NOT NULL,
	CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY ("dept_no") REFERENCES "departments" ("dept_no"),
    CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY ("emp_no") REFERENCES "employees" ("emp_no")
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar(15)   NOT NULL,
    "birth_date" varchar(15)   NOT NULL,
    "first_name" varchar(30)   NOT NULL,
    "last_name" varchar(30)   NOT NULL,
    "sex" varchar(3)   NOT NULL,
    "hire_date" varchar(15)   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
	CONSTRAINT fk_salaries_emp_no FOREIGN KEY ("emp_no") REFERENCES "employees" ("emp_no")
);

CREATE TABLE "titles" (
    "title_id" varchar(15)   NOT NULL,
    "title" varchar(20)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE SUBSTRING(hire_date, length(hire_date) - 3)::integer = 1986;

--List the manager of each department, their department number, department name, employee number, last name, and first name.
SELECT dept_manager.emp_no, dept_manager.dept_no, departments.dept_name, employees.last_name, employees.first_name
FROM dept_manager
JOIN departments ON dept_manager.dept_no = departments.dept_no
JOIN employees on dept_manager.emp_no = employees.emp_no;

--List the department number for each employee, employee number, last name, first name, and department name.
CREATE VIEW employee_data AS
SELECT dept_emp.dept_no, employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees on dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no;

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT emp_no, last_name, first_name
FROM employee_data
WHERE dept_name = 'Sales';

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT emp_no, last_name, first_name, dept_name
FROM employee_data
WHERE dept_name IN ('Sales', 'Developement');

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT (*) AS counts
FROM employees
GROUP BY last_name
ORDER BY counts DESC;
