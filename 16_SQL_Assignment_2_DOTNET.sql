--1. Create a nonclusterd index for the enter_date column of the works_on table. Sixty percent of each index leaf page should be filled.
CREATE UNIQUE NONCLUSTERED INDEX idx_enter_date 
  ON works_on (enter_date) 
  WITH FILLFACTOR = 60 
--2. Create a unique composite index for the l_name and f_name columns of the employee table.
CREATE UNIQUE INDEX unq_empl_fname_lname 
  ON employee(emp_fname, emp_lname); 
--3. Create a view that  comprises the data of all employees that work for the department d1.
CREATE VIEW [EMPLOYEE_D] 
AS 
  SELECT * 
  FROM   employee 
  WHERE  dept_no = 'd1' 
--4.For the project table, create a view that can be used by employees who are allowed to view all data of this table except the budget column
CREATE VIEW [Project_Budget] 
AS 
  SELECT project_no, 
         project_name 
  FROM   [project] 
--5,6.Create a vew that comprises the first and last names of all employees who entered their projects in the second half of the year 1988.
CREATE VIEW [Employees_Project] 
AS 
  SELECT emp_fname AS first, 
         emp_lname AS last 
  FROM   [dbo].[employee] 
         INNER JOIN [dbo].[works_on] 
                 ON [dbo].[works_on].emp_no = [dbo].[employee].[emp_no] 
  WHERE  [enter_date] BETWEEN '1988-07-01' AND '1988-12-31' 
--7. use the view in Exercise 3 to display full details of all employees whose last names begin with the letter M.
SELECT * 
FROM   [EMPLOYEE_D] 
WHERE  emp_lname LIKE 'M%' 
--8.Create a view which comprises full details of all projects on which the employee named smith works  . 
CREATE VIEW [FullDetails] 
AS 
  SELECT [project_name], 
         E.emp_no 
  FROM   [project] P 
         INNER JOIN [works_on] W 
                 ON p.project_no = W.project_no 
         INNER JOIN [employee] E 
                 ON E.emp_no = W.emp_no 
  WHERE  ( E.emp_fname = 'Smith' 
            OR E.emp_lname = 'Smith' ) 
--9. Using the ALTER VIEW statement, modify the condition in the view in Exercise-3. The modified view should comprise the data of all employees that work either for the department d1 or d2, or both	
ALTER VIEW [dbo].[EMPLOYEE_D] 
AS 
  SELECT * 
  FROM   dbo.employee 
  WHERE  dept_no IN ( 'd1', 'd2' ) 
--10.Using the view from Exercise 4, insert details of a new project with project no ‘p2’ and name ‘moon’ 
INSERT INTO [Project_Budget] 
VALUES      ('p2', 
             'moon') 
--11.Create a view( with the WITH CHECK OPTION clause) that comprises the first and last names of all employees whose employee number is less than 10,000. After that, use he view to insert data for a new employee named Kohn with the employee number 22123, who works for the department d3
CREATE VIEW employee_check 
AS 
  SELECT * 
  FROM   employee E 
  WHERE  ( emp_no <= 10000 ) 
WITH CHECK OPTION 

INSERT INTO employee_check 
VALUES     (22123, 
            'Kohn', 
            'Kohn', 
            'd3') 
--12.Create a view(with the WITH CHECK OPTION clause) with full etails from the works_ontable for all employees that entered their projects during the years 1998 and 1999. After that, modify the entering date of the employee with the employee number 19346. The new date is 06/01/1997
CREATE VIEW [Works_on_Check] 
AS 
  SELECT * 
  FROM   [works_on] W 
  WHERE  enter_date BETWEEN '1998' AND '1999' 
WITH CHECK OPTION 

UPDATE [works_on_check] 
SET    enter_date = '1997-06-01' 
WHERE  emp_no = 19346 
--13. Solve the above excersise without the WITH CHECK OPTION clause and find the differences in relation to the modification of the data .
CREATE VIEW [Works_on_withoutCheck] 
AS 
  SELECT * 
  FROM   [works_on] W 
  WHERE  enter_date BETWEEN '1998' AND '1999' 

UPDATE [works_on_withoutcheck] 
SET    enter_date = '1997-06-01' 
WHERE  emp_no = 19346 

