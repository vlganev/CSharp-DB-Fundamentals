-- Problem 1.	Employees with Salary Above 35000
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary > 35000
END

-- Problem 2.	Employees with Salary Above Number
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@minSalary DECIMAL(18,4))
AS
BEGIN
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary >= @minSalary
END

-- Problem 3.	Town Names Starting With
CREATE PROCEDURE usp_GetTownsStartingWith(@startingChar VARCHAR(MAX))
AS 
BEGIN
	SELECT Name AS 'Town' 
	  FROM Towns
	 WHERE Name LIKE @startingChar + '%'
END

-- Problem 4.	Employees from Town
CREATE PROCEDURE usp_GetEmployeesFromTown(@TownName VARCHAR(MAX))
AS
BEGIN
	SELECT e.FirstName, e.LastName
	FROM Employees AS e
	JOIN Addresses AS a
	ON e.AddressID=a.AddressID
	JOIN Towns AS t
	ON a.TownID=t.TownID
	WHERE t.Name = @TownName
END

-- Problem 5.	Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @SalaryLevel VARCHAR(10);
	SET @SalaryLevel= CASE 
		WHEN @salary < 30000 THEN 'Low'
		WHEN @salary BETWEEN 30000 AND 50000 THEN 'Average'
		WHEN @salary > 50000 THEN 'High'
	END
	RETURN @SalaryLevel;
END

-- Problem 6.	Employees by Salary Level
CREATE PROCEDURE usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(MAX))
AS
BEGIN
	SELECT e.FirstName, e.LastName FROM Employees AS e
	WHERE @SalaryLevel = dbo.ufn_GetSalaryLevel(e.Salary)
END

-- Problem 7.	Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX)) 
RETURNS BIT
AS
BEGIN
	DECLARE @currentLetter CHAR;
	DECLARE @counter INT = 1;
	WHILE(LEN(@word) >= @counter)
	BEGIN
		SET @currentLetter = SUBSTRING(@word, @counter, 1);
		DECLARE @match INT = CHARINDEX(@currentLetter, @setOfLetters);
		IF (@match = 0)
		BEGIN
			RETURN 0;
		END
		
		SET @counter += 1;
	END
	RETURN 1;
END

SELECT ufn_IsWordComprised() ('oistmiahf', 'Sofia')

-- Problem 8.	* Delete Employees and Departments
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
    AS
 BEGIN
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN 
	(
		SELECT EmployeeID
		  FROM Employees
		 WHERE DepartmentID = @departmentId
	)
	
	ALTER TABLE Departments
	ALTER COLUMN ManagerId INT NULL;
	
	UPDATE Departments
	   SET ManagerID = NULL
	 WHERE ManagerID IN 
	(
		SELECT EmployeeID
		  FROM Employees
		 WHERE DepartmentID = @departmentId
	)
	
	UPDATE Employees 
	   SET ManagerID = NULL
	 WHERE ManagerID IN 
	(
		SELECT EmployeeID
		  FROM Employees
		 WHERE DepartmentID = @departmentId
	)
	
	DELETE 
	  FROM Employees
	 WHERE DepartmentID = @departmentId
	 
	 DELETE 
	  FROM Departments
	 WHERE DepartmentID = @departmentId	
	 
	 SELECT COUNT(*)
	   FROM Employees
	  WHERE DepartmentID = @departmentId
   END
  
-- Problem 9.	Find Full Name
CREATE PROCEDURE usp_GetHoldersFullName
AS
BEGIN
	SELECT CONCAT(a.FirstName, ' ', a.LastName) AS 'Full Name' 
	FROM AccountHolders AS a
END

-- Problem 10.	People with Balance Higher Than
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan(@TargetBalance MONEY)
AS
BEGIN
	SELECT a.FirstName AS 'First Name', 
		   a.LastName AS 'Last Name' 
      FROM AccountHolders AS a
	  JOIN Accounts AS ac
	    ON a.Id = ac.AccountHolderId
  GROUP BY a.FirstName, 
           a.LastName
HAVING SUM(ac.Balance) > @TargetBalance
END

-- Problem 11.	Future Value Function
CREATE FUNCTION ufn_CalculateFutureValue (@Sum MONEY, @InterestRate FLOAT, @NumberOfYears INT)
RETURNS MONEY
AS 
BEGIN
	RETURN @Sum * (POWER((1 + @InterestRate), @NumberOfYears)) 
END

-- Problem 12.	Calculating Interest
CREATE PROCEDURE usp_CalculateFutureValueForAccount (@AccountId INT, @InterestRate FLOAT)
RETURNS TABLE
AS
BEGIN
	SELECT @AccountId AS 'Account Id', 
	       a.FirstName, 
		   a.LastName, 
		   ac.Balance, 
		   dbo.ufn_CalculateFutureValue(ac.Balance, @YIR, 5) AS 'Balance in 5 years'
	FROM AccountHolders AS a
	JOIN Accounts AS ac
	  ON a.Id = ac.AccountHolderId
   WHERE ac.Id = @AccountId
END
  
-- Problem 13.	*Scalar Function: Cash in User Games Odd Rows
CREATE FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN SELECT SUM(Cash) AS SumCash
FROM
(
	SELECT ug.Cash,
		   ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNum
	  FROM UsersGames AS ug
	  JOIN Games AS g
		ON g.Id = ug.GameId
	 WHERE g.Name = @gameName
) AS CashList
WHERE RowNum % 2 = 1