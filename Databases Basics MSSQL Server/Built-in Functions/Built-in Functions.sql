-- Problem 1.	Find Names of All Employees by First Name
SELECT FirstName, LastName FROM Employees
WHERE FirstName LIKE 'SA%'

-- Problem 2.	  Find Names of All employees by Last Name 
SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%ei%'

-- Problem 3.	Find First Names of All Employees
SELECT FirstName FROM Employees
WHERE DepartmentID IN(3, 10) AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

-- Problem 4.	Find All Employees Except Engineers
SELECT FirstName, LastName FROM Employees
WHERE NOT JobTitle LIKE '%engineer%'

-- Problem 5.	Find Towns with Name Length
  SELECT Name
    FROM Towns
   WHERE LEN(Name) IN (5,6)
ORDER BY Name ASC

-- Problem 6.	 Find Towns Starting With
  SELECT *
    FROM Towns
   WHERE Name LIKE '[MKBE]%'
ORDER BY Name ASC

-- Problem 7.	 Find Towns Not Starting With
  SELECT *
    FROM Towns
   WHERE Name LIKE '[^RBD]%'
ORDER BY Name ASC

-- Problem 8.	Create View Employees Hired After 2000 Year
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
  FROM Employees
 WHERE DATEPART(YEAR, HireDate) > 2000

-- Problem 9.	Length of Last Name
SELECT FirstName, LastName
  FROM Employees
 WHERE LEN(LastName) = 5
 
-- Problem 10.	Countries Holding ‘A’ 3 or More Times
  SELECT CountryName, IsoCode FROM Countries
   WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode

-- Problem 11.	Mix of Peak and River Names
  SELECT Peakname, 
         Rivername,
         LOWER(CONCAT(Peakname, SUBSTRING(Rivername, 2, LEN(Rivername)-1))) AS Mix
    FROM Peaks,
         Rivers
   WHERE RIGHT(Peakname, 1) = LEFT(Rivername, 1)	   
ORDER BY Mix

-- Problem 12.	Games from 2011 and 2012 year
  SELECT TOP 50 Name, 
   	     FORMAT(Start, 'yyyy-MM-dd') AS Start 
	FROM Games
   WHERE DATEPART(YEAR, Start) IN(2011, 2012)
ORDER BY Start, Name

-- Problem 13.	User Email Providers
  SELECT Username, 
		 SUBSTRING(Email, CHARINDEX('@', Email, 1) + 1, LEN(Email)) AS [Email Provider] 
	FROM Users
ORDER BY [Email Provider], Username

-- Problem 14.	 Get Users with IPAdress Like Pattern
   SELECT Username, IpAddress
     FROM Users
    WHERE IpAddress LIKE '___.1%.%.___'
 ORDER BY Username
 
-- Problem 15.	 Show All Games with Duration and Part of the Day
SELECT Name AS Game,
	[Part of the Day] = 
		CASE 
			WHEN DATEPART(HOUR, Start) < 12 
				THEN 'Morning'
			WHEN DATEPART(HOUR, Start) < 18
				THEN 'Afternoon'
			ELSE 'Evening'
		END,
	Duration =
		CASE
			WHEN Duration <= 3 THEN 'Extra Short'
			WHEN Duration <= 6 THEN 'Short'
			WHEN Duration > 6 THEN 'Long'
			ELSE 'Extra Long'
		END
FROM Games
ORDER BY Game, 
		 Duration, 
		 [Part of the Day]

-- Problem 16.	 Orders Table
SELECT ProductName, 
	   OrderDate, 
	   DATEADD(DAY, 3, OrderDate) AS [Pay Due], 
	   DATEADD(MONTH, 1, OrderDate) AS [Deliver Due] 
  FROM Orders
