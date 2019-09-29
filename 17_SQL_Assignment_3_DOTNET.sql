
--1.Re-create the Customersand Orderstables, enhancing their definition with all primary and foreign keys constraints
CREATE TABLE [dbo].[Customers](
	[Customerid] [char](5) NOT NULL PRIMARY KEY,
	[CompanyName] [varchar](40) NOT NULL,
	[contactName] [char](30) NULL,
	[Address] [varchar](60) NULL,
	[Town] [char](15) NULL,
	[Phone] [char](24) NULL,
	[Fax] [char](24) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[Orders](
	[OrderId] [int] NOT NULL PRIMARY KEY,
	[customerId] [char](5) FOREIGN KEY REFERENCES [Customers]([Customerid]),
	[Orderdate] [datetime] NULL,
	[Shippeddate] [datetime] NULL,
	[Freight] [money] NULL,
	[Shipname] [varchar](40) NULL,
	[Shipaddres] [varchar](60) NULL,
	[Quantity] [int] NULL
) ON [PRIMARY]

--2.Using the ALTER TABLE statement, create an integrity constraint that limits the possible values of the quantity column in the Orderstable to values between 1 and 30
ALTER TABLE [Orders]  ADD CONSTRAINT [Orders_Check] CHECK ([Quantity] between 1 and 30)
--3.With the help of the corresponding system procedures and the Transact-SQL statements CREATE DEFAULT and CREATE RULE, create the alias data type “Western Countries”. The possible values for the new data type are CA(for California), WA( for Washington), OR( for Oregon), and NM( for New Mexico). The default value is CA. Finally, create a table called Regions with the columns City and Country using the new data type for the later.
CREATE TYPE [Western Countries] FROM varchar(2) NOT NULL ;
CREATE RULE LIST_Rule AS @list IN ('CA','WA','OR','NM');  
CREATE DEFAULT Country AS 'CA';  
sp_bindrule LIST_Rule, 'Western Countries' 
CREATE TABLE Regions (City varchar(50),Country [Western Countries])
EXEC sp_bindefault 'Country', 'Regions.Country';  
--4.Display all integrity constraints for the Orders table.
select * from information_schema.table_constraints  where table_name = 'Orders'
--5.Delete the primary key of the Customerstable. Why isn’t that working?
ALTER TABLE [Customers] DROP [PRIMARY KEY]
--Note:'PRIMARY KEY' is not a constraint.
--6 Delete the integrity constraint defined in Step-2..
ALTER TABLE [Orders] DROP CONSTRAINT [Orders_Check]
--7.Write a function that will return the age of the person given his or her date of birth.
CREATE FUNCTION [dbo].[FuncFindAge] (@DateofBirth Date)
Returns int WITH EXECUTE AS CALLER
As
Begin
DECLARE @date datetime, @tmpdate datetime, @years int, @months int, @days int
SELECT @date = @DateofBirth
SELECT @tmpdate = @date
SELECT @years = DATEDIFF(yy, @tmpdate, GETDATE()) - CASE WHEN (MONTH(@date) > MONTH(GETDATE())) OR (MONTH(@date) = MONTH(GETDATE()) AND DAY(@date) > DAY(GETDATE())) THEN 1 ELSE 0 END
SELECT @tmpdate = DATEADD(yy, @years, @tmpdate)
SELECT @months = DATEDIFF(m, @tmpdate, GETDATE()) - CASE WHEN DAY(@date) > DAY(GETDATE()) THEN 1 ELSE 0 END
SELECT @tmpdate = DATEADD(m, @months, @tmpdate)
SELECT @days = DATEDIFF(d, @tmpdate, GETDATE())
return @years
End
--To Execute select dbo.FnFindAge('1981-05-09') --YYYY-MM-DD
--8.Write a procedure that accepts name and data of birth of the student and inserts the data in the student table with the date computed. The SID should be largest sid in the table +1.
CREATE TABLE student 
  ( 
     [studentid]   INT IDENTITY(1, 1), 
     [NAME]          VARCHAR(50), 
     [DateOfBirth] DATE, 
     [Age]           INT 
  ) 

CREATE PROCEDURE Sp_InsertStudentdata(@DateofBirth DATE, @Name VARCHAR(50)) 
AS 
  BEGIN 
      INSERT INTO student 
                  (NAME, 
                   dateofbirth, 
                   age) 
      VALUES     (@Name, 
                  @dateofBirth, 
                  dbo.FuncFindAge(@DateofBirth)) 
  END 
EXEC Sp_InsertStudentdata '1991-08-08','Naresh' 
SELECT * FROM   student 