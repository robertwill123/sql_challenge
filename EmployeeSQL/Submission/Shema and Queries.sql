-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/hioRiH
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" VARCHAR(5)   NOT NULL,
    "dept_name" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title" VARCHAR(5)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" VARCHAR(150)   NOT NULL,
    "last_name" VARCHAR(200)   NOT NULL,
    "sex" VARCHAR(5)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(5)   NOT NULL,
    "title" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" FLOAT   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(5)   NOT NULL,
    "emp_no" INTEGER   NOT NULL
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR(5)   NOT NULL
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

-- List the employee number, last name, first name, sex, and salary of each employee
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	e.sex,
	s.salary
FROM
	employees e
	join salaries s on e.emp_no = s.emp_no
ORDER BY
	e.last_name ASC,
	s.salary DESC;

-- List the first name, last name, and hire date for the employees who were hired in 1986
SELECT
	first_name,
	last_name,
	hire_date
FROM
	employees
WHERE
	hire_date BETWEEN '1986-01-01' AND '1986-12-31'

-- List the manager of each department along with their department number, 
-- department name, employee number, last name, and first name
SELECT
	m.dept_no,
	d.dept_name,
	m.emp_no,
	e.last_name,
	e.first_name
FROM
	dept_manager m
	join employees e on m.emp_no = e.emp_no
	join departments d on m.dept_no = d.dept_no

-- List the department number for each employee along with that employee’s employee number, 
-- last name, first name, and department name
SELECT
	de.dept_no,
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employees e
	join dept_emp de on e.emp_no = de.emp_no
	join departments d on de.dept_no = d.dept_no

-- List first name, last name, 
-- and sex of each employee whose first name is Hercules and whose last name begins with the letter B
SELECT
	first_name,
	last_name,
	sex
FROM
	employees
WHERE
	first_name = 'Hercules'
	AND last_name like 'B%'

-- List each employee in the Sales department, including their employee number, last name, and first name
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employees e
	join dept_emp de on e.emp_no = de.emp_no
	join departments d on de.dept_no = d.dept_no
WHERE
	d.dept_name = 'Sales'


-- List each employee in the Sales and Development departments, including their employee number, 
-- last name, first name, and department name (4 points)
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employees e
	join dept_emp de on e.emp_no = de.emp_no
	join departments d on de.dept_no = d.dept_no
WHERE
	d.dept_name = 'Sales'
	or d.dept_name = 'Development'

-- List the frequency counts, in descending order, of all the employee last names 
-- (that is, how many employees share each last name)
SELECT
	e.last_name,
	count(e.emp_no) as num_last_name
FROM
	employees e
GROUP BY
	e.last_name
ORDER BY
	num_last_name DESC