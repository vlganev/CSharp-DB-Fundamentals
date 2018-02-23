-- Problem 1.	Records’ Count
SELECT COUNT(*)
  FROM WizzardDeposits 
  
-- Problem 2.	Longest Magic Wand
SELECT MAX(MagicWandSize) AS LongestMagicWand 
  FROM WizzardDeposits

-- Problem 3.	Longest Magic Wand per Deposit Groups
  SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand 
    FROM WizzardDeposits
GROUP BY DepositGroup

-- Problem 4.	Smallest Deposit Group per Magic Wand Size
  SELECT TOP 2 DepositGroup 
    FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

-- Problem 5.	Deposits Sum
  SELECT DepositGroup, SUM(DepositAmount) AS TotalSum 
    FROM WizzardDeposits
GROUP BY DepositGroup

-- Problem 6.	Deposits Sum for Ollivander Family
  SELECT DepositGroup, SUM(DepositAmount) 
    FROM WizzardDeposits
   WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

-- Problem 7.	Deposits Filter
  SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
    FROM WizzardDeposits
   WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
  HAVING SUM(DepositAmount) < 150000
ORDER BY SUM(DepositAmount) DESC

-- Problem 8.	 Deposit Charge
  SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
    FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

-- Problem 9.	Age Groups
SELECT *, COUNT(*) AS WizardCount FROM 
(
	SELECT 
		  CASE
			   WHEN Age <= 10 THEN '[0-10]'
			   WHEN Age between 11 and 20 THEN '[11-20]'
			   WHEN Age between 21 and 30 THEN '[21-30]'
			   WHEN Age between 31 and 40 THEN '[31-40]'
			   WHEN Age between 41 and 50 THEN '[41-50]'
			   WHEN Age between 51 and 60 THEN '[51-60]'
			   ELSE '[61+]'
		 END AS AgeGroup 
	FROM WizzardDeposits
) AS t
GROUP BY AgeGroup
ORDER BY AgeGroup

-- Problem 10.	First Letter
  SELECT LEFT(FirstName, 1) AS FirstLetter 
    FROM WizzardDeposits
   WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)

--Problem 11.	Average Interest 
  SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) 
    FROM WizzardDeposits
   WHERE DATEPART(YEAR, DepositStartDate) >= 1985
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

-- Problem 12.	* Rich Wizard, Poor Wizard
SELECT SUM(Difference) 
FROM (
    SELECT Wiz1.FirstName AS [Host Wizzard], 
    	   Wiz1.DepositAmount AS [Host Wizzard Deposit],
    	   Wiz2.FirstName AS [Guest Wizzard], 
    	   Wiz2.DepositAmount AS [Guest Wizzard Deposit],
           Wiz1.DepositAmount - Wiz2.DepositAmount AS Difference
      FROM WizzardDeposits AS Wiz1
INNER JOIN WizzardDeposits AS Wiz2
		ON Wiz1.Id = Wiz2.Id - 1) AS t

-- Problem 13.	Departments Total Salaries
  SELECT DepartmentID, SUM(Salary) AS TotalSalary 
    FROM Employees
GROUP BY DepartmentID

-- Problem 14.	Employees Minimum Salaries
  SELECT DepartmentID, MIN(Salary) AS MinSalary
    FROM Employees
   WHERE DepartmentID IN (2, 5, 7) AND DATEPART(YEAR, HireDate) > 2000
GROUP BY DepartmentID

-- Problem 15.	Employees Average Salaries
SELECT * 
INTO EmployeesWithHighSalary
FROM Employees
WHERE Salary > 30000

DELETE FROM EmployeesWithHighSalary
WHERE ManagerID = 42

UPDATE EmployeesWithHighSalary
SET Salary += 5000
WHERE DepartmentID = 1

  SELECT DepartmentID, AVG(Salary) AS AverageSalary 
    FROM EmployeesWithHighSalary
GROUP BY DepartmentID

-- Problem 16.	Employees Maximum Salaries
  SELECT DepartmentID, MAX(Salary) AS MaxSalary 
    FROM Employees
GROUP BY DepartmentID
  HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- Problem 17.	Employees Count Salaries
SELECT COUNT(*)
  FROM Employees
 WHERE ManagerID IS NULL

-- Problem 18.	3rd Highest Salary
SELECT DepartmentID, 
         Salary
  FROM (
		SELECT DepartmentID,
			   MAX(Salary) AS Salary,
			   DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
		  FROM Employees
	  GROUP BY DepartmentID, Salary
	    ) AS ThirdRank
  WHERE RANK = 3
  
-- Problem 19.	Salary Challenge
SELECT TOP 10 e1.FirstName, e1.LastName, e1.DepartmentID
  FROM Employees AS e1
 WHERE Salary > (SELECT AVG(Salary)
		  FROM Employees AS e2
		 WHERE e2.DepartmentID = e1.DepartmentID
	  GROUP BY DepartmentID)
