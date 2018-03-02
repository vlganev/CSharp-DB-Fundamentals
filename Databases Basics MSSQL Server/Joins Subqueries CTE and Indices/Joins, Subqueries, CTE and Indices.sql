-- Problem 1.	Employee Address
SELECT TOP (5)
           e.EmployeeID, 
		   e.JobTitle, 
		   e.AddressID, 
		   a.AddressText
      FROM Employees AS e
INNER JOIN Addresses AS a
        ON e.AddressID=a.AddressID
  ORDER BY e.AddressID

-- Problem 2.	Addresses with Towns
SELECT TOP 50
    	   e.FirstName,
    	   e.LastName,
    	   t.Name AS Town,
    	   a.AddressText
      FROM Employees AS e
      JOIN Addresses AS a
        ON a.AddressID = e.AddressID
      JOIN Towns as t
        ON t.TownID = a.TownID
  ORDER BY e.FirstName, e.Lastname
	
-- Problem 3.	Sales Employee
SELECT e.EmployeeID, 
       e.FirstName,
	   e.LastName,
	   d.Name AS DepartmentName
  FROM Employees AS e
  JOIN Departments AS d
    ON d.DepartmentID = e.DepartmentID
 WHERE d.Name = 'Sales'
 
-- Problem 4.	Employee Departments
SELECT TOP 5 e.EmployeeID,
           e.FirstName,
    	   e.Salary,
    	   d.Name AS DepartmentName
      FROM Employees AS e
      JOIN Departments AS d
        ON d.DepartmentID = e.DepartmentID
	 WHERE e.Salary > 15000
  ORDER BY e.DepartmentID

-- Problem 5.	Employees Without Project
  SELECT e.EmployeeID, 
         e.FirstName
    FROM Employees AS e
   WHERE EmployeeID NOT IN (SELECT DISTINCT EmployeeID FROM EmployeeProjects)
ORDER BY EmployeeID
 
-- Problem 6.	Employees Hired After
  SELECT e.FirstName,
  	     e.LastName,
  	     e.HireDate,
  	     d.Name AS DeptName
    FROM Employees AS e
    JOIN Departments AS d
      ON d.DepartmentId = e.DepartmentId
   WHERE d.Name IN ('Sales', 'Finance') 
     AND e.HireDate > '01/01/1999'
ORDER BY e.HireDate ASC

-- Problem 7.	Employees with Project
SELECT TOP 5 e.EmployeeID,
    	   e.FirstName,
    	   p.Name
	  FROM Employees AS e
      JOIN EmployeesProjects AS ep
        ON e.EmployeeID = ep.EmployeeID
      JOIN Projects AS p
        ON ep.ProjectID = p.ProjectID
     WHERE p.StartDate > '08.13.2002' AND p.EndDate IS NULL
    ORDER BY EmployeeID

-- Problem 8.	Employee 24
SELECT e.EmployeeID,
	   e.FirstName,
  CASE WHEN p.StartDate >= '2005' THEN NULL
  ELSE p.Name
  END ProjectName
  FROM Employees AS e
  JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
  JOIN Projects AS p
    ON p.ProjectID = ep.ProjectID
 WHERE e.EmployeeID = 24

-- Problem 9.	Employee Manager
  SELECT e.EmployeeID,
         e.FirstName,
  	     e.ManagerID,
  	     m.FirstName AS ManagerName
    FROM Employees AS e
    JOIN Employees AS m
      ON e.ManagerID = m.EmployeeID
   WHERE e.ManagerID IN (3,7) 
ORDER BY e.EmployeeID

-- Problem 10.	Employee Summary
SELECT TOP 50
           e1.EmployeeID,
           e1.FirstName + ' ' + e1.LastName AS [EmployeeName],
           e2.FirstName + ' ' + e2.LastName AS [ManagerName],
    	   d.Name as DepartmentName
      FROM Employees AS e1
      JOIN Employees AS e2
        ON e1.ManagerID = e2.EmployeeID
      JOIN Departments AS d
        ON d.DepartmentID = e1.DepartmentID
    ORDER BY e1.EmployeeID

-- Problem 11.	Min Average Salary
SELECT MIN(AverageSalary)
  FROM
(
  SELECT DepartmentID,
         AVG(Salary) AS AverageSalary
    FROM Employees
GROUP BY DepartmentID
)     AS AverageSalariesByDepartment

-- Problem 11.	Min Average Salary
  SELECT TOP (1) AVG(e.Salary) AS 'MinAverageSalary'
    FROM Employees AS e
GROUP BY e.DepartmentID
ORDER BY AVG(e.Salary)

-- Problem 12.	Highest Peaks in Bulgaria
  SELECT mc.CountryCode, 
         m.MountainRange, 
         p.PeakName, 
  	     p.Elevation
    FROM MountainsCountries AS mc
    JOIN Mountains AS m
      ON mc.MountainId = m.Id
    JOIN Peaks AS p
      ON p.MountainId = m.Id
   WHERE mc.CountryCode IN 
(
	SELECT TOP (1) c.CountryCode 
	  FROM Countries AS c
	 WHERE c.CountryName = 'Bulgaria'
) 
     AND p.Elevation > 2835
ORDER BY p.Elevation DESC

-- Problem 13.	Count Mountain Ranges
  SELECT mc.CountryCode,
         COUNT(mc.MountainId) AS MountainRanges 
    FROM MountainsCountries AS mc
GROUP BY mc.CountryCode
  HAVING mc.CountryCode IN
(
	SELECT DISTINCT c.CountryCode 
	  FROM Countries AS c
	 WHERE c.CountryName IN ('Bulgaria', 'Russia', 'United States')
)

-- Problem 14.	Countries with Rivers
   SELECT TOP (5) 
          c.CountryName, 
          ri.RiverName
     FROM Countries AS c
LEFT JOIN CountriesRivers AS cr
       ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS ri
       ON cr.RiverId = ri.Id
    WHERE c.ContinentCode IN 
(
		SELECT DISTINCT co.ContinentCode 
		FROM Continents AS co
		WHERE co.ContinentName = 'Africa'
)
ORDER BY c.CountryName

-- Problem 15.	Continents and Currencies
SELECT ContinentCode,
       CurrencyCode,
	   CurrencyUsage 
  FROM
(
	SELECT ContinentCode, 
		   CurrencyCode, 
		   CurrencyUsage,
		   DENSE_RANK() OVER(PARTITION BY(ContinentCode)
		   ORDER BY CurrencyUsage DESC) AS [Rank]
	  FROM
		(
		  SELECT ContinentCode,
			     CurrencyCode,
				 COUNT(CurrencyCode) AS CurrencyUsage
			FROM Countries
		GROUP BY CurrencyCode, 
				 ContinentCode
		) AS Currencies 
) AS RankedCurrencies
   WHERE [RANK] = 1 AND CurrencyUsage > 1
ORDER BY ContinentCode;

-- Problem 16.	Countries without any Mountains
   SELECT COUNT(c.CountryCode) AS CountryCode
     FROM Countries AS c
LEFT JOIN MountainsCountries AS m ON c.CountryCode = m.CountryCode
    WHERE m.MountainId IS NULL

-- Problem 17.	Highest Peak and Longest River by Country
   SELECT TOP 5 c.CountryName,
          MAX(p.Elevation) AS HighestPeakElevation,
          MAX(r.Length) AS LongestRiverLength
     FROM Countries AS c
LEFT JOIN MountainsCountries AS mc 
       ON c.CountryCode = mc.CountryCode
LEFT JOIN Peaks AS p 
       ON p.MountainId = mc.MountainId
LEFT JOIN CountriesRivers AS cr 
       ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r 
       ON r.Id = cr.RiverId
 GROUP BY c.CountryName
 ORDER BY HighestPeakElevation DESC, 
          LongestRiverLength DESC, 
		  c.CountryName