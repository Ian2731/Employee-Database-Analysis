-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/ehCCt5
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

DROP TABLE departments;
DROP TABLE dept_emp;
DROP TABLE dept_manager;
DROP TABLE employees;
DROP TABLE salaries;
DROP TABLE titles;

CREATE TABLE "departments" (
    "dep_num" varchar(30)  NOT NULL ,
    "dept_name" varchar(30)  NOT NULL ,
    PRIMARY KEY (
        "dep_num"
    )
);

CREATE TABLE "dept_emp" (
    "emp_num" int  NOT NULL ,
    "dept_no" varchar(50)  NOT NULL ,
    "from_date" date  NOT NULL ,
    "to_date" date  NOT NULL ,
    PRIMARY KEY (
        "from_date","to_date"
    )
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(30)  NOT NULL ,
    "emp_no" int  NOT NULL ,
    "from_date" date  NOT NULL ,
    "to_date" date  NOT NULL ,
    PRIMARY KEY (
        "emp_no"
    )
);

CREATE TABLE "employees" (
    "emp_no" int  NOT NULL ,
    "birth_date" date  NOT NULL ,
    "first_name" varchar(30)  NOT NULL ,
    "last_name" varchar(30)  NOT NULL ,
    "gender" varchar(5)  NOT NULL ,
    "hire_date" date  NOT NULL 
);

CREATE TABLE "salaries" (
    "emp_no" int  NOT NULL ,
    "salary" int  NOT NULL ,
    "from_date" date  NOT NULL ,
    "to_date" date  NOT NULL 
);

CREATE TABLE "titles" (
    "emp_no" int  NOT NULL ,
    "title" varchar(50)  NOT NULL ,
    "from_date" date  NOT NULL ,
    "to_date" date  NOT NULL 
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dep_num");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_from_date_to_date" FOREIGN KEY("from_date", "to_date")
REFERENCES "dept_emp" ("from_date", "to_date");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "dept_manager" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "dept_manager" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_from_date_to_date" FOREIGN KEY("from_date", "to_date")
REFERENCES "dept_emp" ("from_date", "to_date");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "dept_manager" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_from_date_to_date" FOREIGN KEY("from_date", "to_date")
REFERENCES "dept_emp" ("from_date", "to_date");

--     Query 1: find all emp numbers, names, genders, and salaries.
SELECT employees.emp_no, employees.last_name,
    employees.first_name, employees.gender, salaries.salary
FROM employees, salaries
WHERE employees.emp_no = salaries.emp_no;
--     Query 2: find all employees hired in 1986
SELECT employees.emp_no, employees.last_name,
    employees.first_name, employees.hire_date
FROM employees
WHERE date_part('year', employees.hire_date) = 1986;

-- Query 3: List the manager of each department with the following information:
-- department number, department name, the manager's employee number, last name,
-- first name, and start and end employment dates.
SELECT departments.dept_num, departments.dept_name, dept_manager.emp_no,
    employees.last_name, employees.first_name, dept_manager.from_date,
    dept_manager.to_date
FROM departments, dept_manager, employees
WHERE employees.emp_no = dept_manager.emp_no
AND departments.dept_num = dept_manager.dept_no;
    
-- Query 4: List the department of each employee with the following information:
-- employee number, last name, first name, and department name.
SELECT dept_emp.emp_num, employees.last_name,
    employees.first_name, departments.dept_name
FROM employees, departments, dept_emp
WHERE employees.emp_no = dept_emp.emp_num
AND departments.dept_num = dept_emp.dept_no;

-- Query 5: List all employees whose first name is "Hercules" and last names begin with "B."
SELECT employees.first_name, employees.last_name
FROM employees
WHERE employees.first_name = 'Hercules'
AND employees.last_name LIKE 'B%';
-- Query 6: List all employees in the Sales department, including their
-- employee number, last name, first name, and department name.
SELECT dept_emp.emp_num, employees.last_name,
    employees.first_name, departments.dept_name
FROM employees, departments, dept_emp
WHERE dept_emp.emp_num = employees.emp_no
AND departments.dept_num = dept_emp.dept_no
AND departments.dept_name = 'Sales'
-- Query 7: List all employees in the Sales and Development departments, including their
-- employee number, last name, first name, and department name.

SELECT dept_emp.emp_num, employees.last_name,
	employees.first_name, departments.dept_name
FROM departments
inner join dept_emp
on departments.dept_num = dept_emp.dept_no
inner join employees
on dept_emp.emp_num = employees.emp_no
WHERE departments.dept_name = 'Sales'
OR departments.dept_name = 'Development';
-- Query 8: In descending order, list the frequency count of employee last names,
-- i.e., how many employees share each last name.
SELECT last_name, COUNT(*)
FROM employees
GROUP BY last_name
ORDER BY count DESC;