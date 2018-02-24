-- Problem 1.	One-To-One Relationship
CREATE TABLE Passports (
	PassportID INT PRIMARY KEY IDENTITY(101,1),
	PassportNumber CHAR(8)
)

CREATE TABLE Persons (
	PersonID INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30),
	Salary DECIMAL(10,2),
	PassportID INT NOT NULL FOREIGN KEY REFERENCES Passports(PassportID)
)

INSERT INTO Passports VALUES 
('N34FG21B'), ('K65LO4R7'), ('ZE657QP2')

INSERT INTO Persons VALUES 
('Roberto', 43300.00, 102),
('Tom',	56100.00, 103),
('Yana', 60200.00, 101)

-- Problem 2.	One-To-Many Relationship
CREATE TABLE Manufacturers (
	ManufacturerID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) NOT NULL,
	EstablishedOn DATE
)

CREATE TABLE Models (
	ModelID INT PRIMARY KEY IDENTITY(101,1),
	Name VARCHAR(30) NOT NULL,
	ManufacturerID INT NOT NULL FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers VALUES
('BMW', '1916-03-07'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01')

INSERT INTO Models VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)

-- Problem 3.	Many-To-Many Relationship
CREATE TABLE Students (
	StudentID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) NOT NULL
)

CREATE TABLE Exams (
	ExamID INT PRIMARY KEY IDENTITY(101,1),
	Name VARCHAR(30) NOT NULL
)

CREATE TABLE StudentsExams (
	StudentID INT NOT NULL FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT NOT NULL FOREIGN KEY REFERENCES Exams(ExamID),
	PRIMARY KEY (StudentID, ExamID)
)

INSERT INTO Students VALUES 
('Mila'), ('Toni'), ('Ron')

INSERT INTO Exams VALUES 
('SpringMVC'), ('Neo4j'), ('Oracle 11g')

INSERT INTO StudentsExams VALUES 
('1', '101'), ('1', '102'), ('2', '101'), ('3', '103'), ('2', '102'), ('2', '103')

SELECT * FROM StudentsExams

-- Problem 4.	Self-Referencing 
CREATE TABLE Teachers (
	TeacherID INT PRIMARY KEY IDENTITY(101,1),
	Name VARCHAR(30) NOT NULL,
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID),
)

SET IDENTITY_INSERT Teachers ON
INSERT INTO Teachers(TeacherID, Name, ManagerID) VALUES
('101', 'John', NULL),
('102', 'Maya', '106'),
('103', 'Silvia', '106'),
('104', 'Ted', '105'),
('105', 'Mark', '101'),
('106', 'Greta', '101')
SET IDENTITY_INSERT Teachers OFF

-- Problem 5.	Online Store Database
CREATE TABLE Cities (
	CityID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
)	

CREATE TABLE Customers (
	CustomerID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	Birthday DATE NOT NULL,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)	

CREATE TABLE Orders (
	OrderID INT PRIMARY KEY IDENTITY,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes (
	ItemTypeID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Items (
	ItemID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems (
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID),
	PRIMARY KEY (OrderID, ItemID)
)

-- Problem 6.	University Database
CREATE TABLE Majors (
	MajorID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) NOT NULL
)

CREATE TABLE Students (
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber INT UNIQUE,
	StudentName VARCHAR(50) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)	
)

CREATE TABLE Payments (
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATETIME2 NOT NULL,
	PaymentAmount DECIMAL (10, 2) NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Subjects (
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName VARCHAR(30) NOT NULL
)

CREATE TABLE Agenda (
	StudentID INT NOT NULL FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT NOT NULL FOREIGN KEY REFERENCES Subjects(SubjectID)
	CONSTRAINT PK_Subject PRIMARY KEY (StudentID, SubjectID)
)

-- Problem 9.	Peaks in Rila
  SELECT m.MountainRange, p.PeakName, p.Elevation
    FROM Peaks AS p
    JOIN Mountains AS m ON p.MountainID = m.id
   WHERE m.MountainRange = 'Rila'
ORDER BY Elevation DESC

















