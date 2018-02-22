-- Problem 1.	Create Database
CREATE DATABASE Minions

-- Problem 2.	Create Tables
USE Minions
CREATE TABLE Minions (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Age INT
)

CREATE TABLE Towns (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Name VARCHAR(50)
)

-- Problem 3.	Alter Minions Table
ALTER TABLE Minions 
ADD TownId INT

ALTER TABLE
ADD FOREIGN KEY (TownId) REFERENCES Towns(Id)

-- Problem 4.	Insert Records in Both Tables
INSERT INTO Towns (Id, Name) VALUES 
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions (Id, Name, Age, TownId) VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

-- Problem 5.	Truncate Table Minions
TRUNCATE TABLE Minions

-- Problem 6.	Drop All Tables
DROP TABLE Minions
DROP TABLE Towns

---- Problem 7.	Create Table People
CREATE TABLE People (
	Id INT UNIQUE IDENTITY,
	Name NVARCHAR(200) NOT NULL,
	Picture VARBINARY(MAX) CHECK (DATALENGTH(Picture) > 1024 * 1024 * 2),
	Height NUMERIC (3, 2),
	Weight NUMERIC (2, 2),
	Gender CHAR(1) CHECK (Gender = 'm' OR Gender = 'f') NOT NULL,
	Birthdate DATE NOT NULL,
	Biography NVARCHAR(MAX)	
)

ALTER TABLE People
ADD PRIMARY KEY (Id)

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography) VALUES 
('Ivan Ivanov', NULL, 1.55, 66.31, 'm', '10-01-1999', 'a nice guy'),
('Ivanka Milanova', NULL, 1.65, 46.31, 'f', '18-03-1990', NULL),
('Cvetana Kaloqnova', NULL, 1.75, 46.64, 'f', '02-05-1985', NULL),
('Georgi Mihailova', NULL, 1.81, 95.42, 'm', '12-10-1994', NULL),
('Pesho Ivanchev', NULL, 1.66, 82.26, 'm', '11-11-1998', NULL)

-- Problem 8.	Create Table Users
CREATE TABLE Users(
	Id BIGINT IDENTITY,
	Username VARCHAR(30) NOT NULL,
	Password VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX) CHECK (DATALENGTH(ProfilePicture) > 1024 * 900),
	LastLoginTime DATETIME,
	IsDeleted BIT NOT NULL DEFAULT (0),
	CONSTRAINT PK_Users PRIMARY KEY(Id)
)

INSERT INTO Users VALUES
('Ivan Ivanov', 'jaksdkj', NULL, NULL, 1),
('Ivanka Milanova', 'fasfxcv', NULL, NULL, 1),
('Stamat', 'hfghfg', NULL, NULL, 1),
('Cvetana Kaloqnova', '12345', NULL, NULL, 0),
('Pesho Ivanchev', 'sdgfdg', NULL, NULL, 0)

-- Problem 9.	Change Primary Key
ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id, Username)

-- Problem 10.	Add Check Constraint
ALTER TABLE Users
ADD CONSTRAINT PasswordLength CHECK (LEN(Password) >= 5)

-- Problem 11.	Set Default Value of a Field
ALTER TABLE Users
ADD DEFAULT GETDATE() FOR LastLoginTime

-- Problem 12.	Set Unique Field
ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Id PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT uq_Username UNIQUE(Username)

ALTER TABLE Users
ADD CONSTRAINT UsernameLength CHECK (LEN(Username) >= 3)

-- Problem 13.	Movies Database
CREATE DATABASE Movies
USE Movies

CREATE TABLE Directors (
	Id INT PRIMARY KEY IDENTITY,
	DirectorName NVARCHAR(80) UNIQUE NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Genres (
	Id INT PRIMARY KEY IDENTITY,
	GenreName NVARCHAR(100) UNIQUE NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(120) UNIQUE NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Movies (
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(MAX) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear INT NOT NULL,
	Length TIME,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Rating DECIMAL(2,1),
	Notes NVARCHAR(MAX)
)

INSERT INTO Directors VALUES
('Georgi Petrov', 'Director 1'),
('Kaloian Mavrodiev', 'Director 2'),
('Boris Petrov', 'Director 3'),
('Koko Chokov', 'Director 4'),
('Hristo Ivanov', 'Director 5')

INSERT INTO Genres VALUES
('Comedy', 'Genre 1'),
('Action', 'Genre 2'),
('Triller', 'Genre 3'),
('Romantic', 'Genre 4'),
('Drama', 'Genre 5')

INSERT INTO Categories VALUES
('Over 3 Years', 'Over 3 Years'),
('Over 12 years', 'Over 12 years'),
('Over 16 years', 'Over 16 years'),
('Over 18 years', 'Over 18 years'),
('Below 60 year', 'Below 60 year')

INSERT INTO Movies VALUES 
('Die hard 1', 3, 1995, '1:12:20', 1, 3, 9.5, 'Top'),
('Die hard 2', 2, 1998, '1:45:54', 2, 2, 9.6, 'Top'),
('Die hard 3', 1, 2000, '1:32:12', 4, 1, 9.8, 'Top'),
('Die hard 4', 2, 2002, '1:31:31', 1, 2, 9.1, 'Top'),
('Die hard 5', 4, 2005, '1:28:44', 1, 5, 9.0, 'Top')

-- Problem 14.	Car Rental Database
CREATE DATABASE CarRental
USE CarRental

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(100) UNIQUE NOT NULL,
	DailyRate INT NOT NULL,
	WeeklyRate INT NOT NULL,
	MonthlyRate INT NOT NULL,
	WeekendRate INT NOT NULL
)

CREATE TABLE Cars(
	Id INT PRIMARY KEY IDENTITY,
	PlateNumber NVARCHAR(20) UNIQUE NOT NULL,
	Manufacturer NVARCHAR(80) NOT NULL,
	Model NVARCHAR(80) NOT NULL,
	CarYear INT NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Doors INT,
	Picture VARBINARY(MAX),
	Condition NVARCHAR(500),
	Available BIT NOT NULL	
)

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(80) NOT NULL,
	LastName NVARCHAR(80) NOT NULL,
	Title NVARCHAR(80) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Customers(
	Id INT PRIMARY KEY IDENTITY,
	DriverLicenceNumber NVARCHAR(20) UNIQUE NOT NULL,
	FullName NVARCHAR(80) NOT NULL,
	Address NVARCHAR(80) NOT NULL,
	City NVARCHAR(80) NOT NULL,
	ZIPCode NVARCHAR(80),
	Notes NVARCHAR(MAX)
)

CREATE TABLE RentalOrders(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
	CarId INT FOREIGN KEY REFERENCES Cars(Id) NOT NULL,
	TankLevel INT NOT NULL,
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage AS KilometrageEnd - KilometrageStart,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	TotalDays AS DATEDIFF(DAY, StartDate, EndDate),
	RateApplied INT NOT NULL,
	TaxRate AS RateApplied * 0.2,
	OrderStatus BIT NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO Categories VALUES
('Cabrio', 30, 180, 500, 160),
('Hatchback', 20, 440, 1800, 120),
('Sedan', 18, 80, 420, 110)

INSERT INTO Cars VALUES
('TX2022XT', 'BMW', '3', 2012, 2, 4, NULL, 'Perfect', 1),
('CA8291AT', 'Opel', 'Corsa', 2016, 3, 3, NULL, 'Perfect', 1),
('K7878CA', 'Fiat', 'Punto', 2015, 1, 5, NULL, 'Perfect', 0)

INSERT INTO Employees VALUES
('Ivan', 'Petkov', 'expert', NULL),
('Checho', 'Kirkov', 'expert', NULL),
('Liubo', 'Jelev', 'chief expert', NULL)

INSERT INTO Customers(DriverLicenceNumber, FullName, Address, City) VALUES
('A9F9S8DF8S9', 'Ivano Ivanov', 'address 1', 'Sofia'),
('SDF8SD789SD', 'Jivko Jivkov', 'address 2', 'Varna'),
('S8FD989SDFF', 'Pedro Mendosa', 'address 3', 'Plovdiv')

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, StartDate, EndDate, RateApplied, OrderStatus) VALUES
(1, 2, 3, 45, 10000, 1100, '2017-10-08', '2017-10-15', 350, 1),
(3, 2, 1, 50, 42666, 43626, '2018-02-12', '2018-02-20', 850, 0),
(2, 2, 1, 18, 31513, 32651, '2017-11-08', '2017-11-21', 153, 0)

-- Problem 15.	Hotel Database
CREATE DATABASE Hotel
USE Hotel

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(80) NOT NULL,
	LastName NVARCHAR(80) NOT NULL,
	Title NVARCHAR(80),
	Notes NVARCHAR(MAX)
)

CREATE TABLE Customers(
	AccountNumber INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(80) NOT NULL,
	LastName NVARCHAR(80) NOT NULL,
	PhoneNumber NVARCHAR(80),
	EmergencyName NVARCHAR(80),
	EmergencyNumber NVARCHAR(80),
	Notes NVARCHAR(MAX)
)

CREATE TABLE RoomStatus(
	RoomStatus NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE RoomTypes(
	RoomType NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE BedTypes(
	BedType NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Rooms(
	RoomNumber INT PRIMARY KEY NOT NULL,
	RoomType NVARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType) NOT NULL,
	BedType NVARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType) NOT NULL,
	Rate DECIMAL(6,2) NOT NULL,
	RoomStatus NVARCHAR(50) FOREIGN KEY REFERENCES RoomStatus(RoomStatus) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Payments(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	PaymentDate DATETIME NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays AS DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied),
	AmountCharged DECIMAL(7, 2) NOT NULL,
	TaxRate DECIMAL(6,2) NOT NULL,
	TaxAmount AS AmountCharged * TaxRate,
	PaymentTotal AS AmountCharged + AmountCharged * TaxRate,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Occupancies(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATE NOT NULL,
	PaymentDate DATETIME,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,	
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
	RateApplied DECIMAL(7, 2) NOT NULL,
	PhoneCharge DECIMAL(8, 2) NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO Employees (FirstName, LastName) VALUES
('Georgi', 'Petrov'),
('Ivan', 'Penchev'),
('Ivo', 'Lashkov')

INSERT INTO Customers(FirstName, LastName) VALUES
('Petko', 'Iordanov'),
('Pavel', 'Kirov'),
('Ivan', 'Petkov')

INSERT INTO RoomStatus (RoomStatus) VALUES
('occupied'),
('not occupied'),
('busy')

INSERT INTO RoomTypes (RoomType) VALUES
('single'),
('double'),
('apartment')

INSERT INTO BedTypes (BedType) VALUES
('single'),
('double'),
('king')

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus) VALUES
(102, 'single', 'single', 50.0, 'occupied'),
(205, 'double', 'king', 50.0, 'busy'),
(307, 'double', 'double', 50.0, 'not occupied')

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, AmountCharged, TaxRate) VALUES
(1, '2011-05-15', 2, '2011-05-25', '2011-05-30', 300.0, 0.2),
(3, '2016-10-03', 1, '2016-10-10', '2016-10-20', 650.0, 0.2),
(1, '2016-04-05', 2, '2016-04-12', '2016-04-21', 800.0, 0.2)

INSERT INTO Occupancies (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge) VALUES
(1, '2011-05-15', 2, 102, 40.0, 6.35),
(3, '2016-10-03', 1, 205, 53.0, 11.22),
(1, '2016-04-05', 2, 307, 65.0, 22.33)

-- Problem 16.	Create SoftUni Database
CREATE DATABASE SoftUni 
USE SoftUni

CREATE TABLE Towns (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Name NVARCHAR(90) UNIQUE NOT NULL
)

CREATE TABLE Adresses (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	AdressText NVARCHAR(100) UNIQUE NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
)

CREATE TABLE Departments (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Name NVARCHAR(60) UNIQUE NOT NULL
)

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(80) NOT NULL,
	MiddleName NVARCHAR(80) NOT NULL,
	LastName NVARCHAR(80) NOT NULL,
	JobTitle NVARCHAR(80)  NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)  NOT NULL,
	HireDate DATE,
	Salary INT,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

-- Problem 17.	Backup Database

BACKUP DATABASE Softuni TO DISK = 'D:\backups\softuni-backup.bak'
RESTORE DATABASE Softuni FROM DISK = 'D:\backups\softuni-backup.bak'

USE Softuni

-- Problem 18.	Basic Insert
INSERT INTO Towns VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO Departments VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary) VALUES
('Ivan', 'Ivanov', 'Ivanov',	'.NET Developer',	'Software Development',	'01/02/2013',	'3500.00'),
('Petar', 'Petrov', 'Petrov',	'Senior Engineer',	'Engineering'	'02/03/2004',	'4000.00'),
('Maria', 'Petrova', 'Ivanova',	'Intern',	'Quality Assurance',	'28/08/2016',	'525.25'),
('Georgi', 'Teziev', 'Ivanov',	'CEO',	'Sales',	'09/12/2007',	'3000.00'),
('Peter', 'Pan', 'Pan',	'Intern',	'Marketing',	'28/08/2016',	'599.88')

-- Problem 19.	Basic Select All Fields
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

-- Problem 20.	Basic Select All Fields and Order Them
SELECT * FROM Towns ORDER BY Name
SELECT * FROM Departments ORDER BY Name
SELECT * FROM Employees ORDER BY Salary DESC

-- Problem 21.	Basic Select Some Fields
SELECT Name FROM Towns ORDER BY Name
SELECT Name FROM Departments ORDER BY Name
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

-- Problem 22.	Increase Employees Salary
UPDATE Employees
SET Salary = Salary * 1.1

SELECT Salary FROM Employees

-- Problem 23.	Decrease Tax Rate
UPDATE Payments
SET TaxRate = TaxRate * 0.97

SELECT TaxRate FROM Payments

-- Problem 24.	Delete All Records
TRUNCATE TABLE Occupancies