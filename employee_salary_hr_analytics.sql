CREATE DATABASE HR_Analytics;
USE HR_Analytics;
CREATE TABLE Departments(
   Dept_ID INT PRIMARY KEY,
   Dept_Name VARCHAR(50)
);
CREATE TABLE Employees(
   Emp_ID INT PRIMARY KEY,
   Name VARCHAR(100),
   Dept_ID INT,
   Join_Date DATE,
   FOREIGN KEY(Dept_ID) REFERENCES
   Departments(Dept_ID)
);
CREATE TABLE Salary(
   Emp_ID INT,
   Basic DECIMAL(10,2),
   HRA DECIMAL(10,2),
   PF DECIMAL(10,2),
   Tax DECIMAL(10,2),
   FOREIGN KEY(Emp_ID) REFERENCES
Employees(Emp_ID)
);
CREATE TABLE Attendance(
   Emp_ID INT,
   Att_Date DATE,
Status VARCHAR(10)  
);
CREATE TABLE Performance(
   Emp_ID INT,
   MONTH VARCHAR (20),
   Rating INT,
   Bonus DECIMAL (10,2)
);
INSERT INTO Departments VALUES
(1,'IT'),
(2,'HR'),
(3,'Finance');
SELECT * FROM Departments
INSERT INTO Employees VALUES
(101, 'Arjun', 1, '2023-06-01'),
(102, 'Vindhya', 2, '2022-05-02'),
(103, 'Lahari', 3, '2021-07-10');
SELECT * FROM Employees
INSERT INTO Attendance VALUES
(101, '2026-06-26', 'Present'),
(101, '2026-06-09', 'Absent'),
(102, '2026-06-01', 'Present'),
(103, '2026-06-01', 'Present');
SELECT * FROM Attendance
INSERT INTO Performance VALUES
(101, 'July-2026', 4, 5000),
(102, 'July-2026', 5, 8000),
(103, 'july-2026', 3, 3000);
SELECT * FROM Performance
INSERT INTO Salary VALUES
(101,30000,10000,2000,1500),
(102,40000,12000,2500,2000),
(103,25000,8000,1500,1000);
SELECT * FROM Salary


SELECT
    e.Emp_ID,
    e.Name,
    (s.Basic + s.HRA - s.PF - s.Tax + p.Bonus) AS Net_Salary
FROM Employees e
JOIN Salary s ON e.Emp_ID = s.Emp_ID
JOIN Performance p ON e.Emp_ID = p.Emp_ID;
SELECT 
    d.Dept_Name,
    AVG(s.Basic + s.HRA) AS Avg_Salary
FROM Employees e
JOIN Departments d ON e.Dept_ID = d.Dept_ID
JOIN Salary s ON e.Emp_ID = s.Emp_ID
GROUP BY d.Dept_Name;

SELECT 
    Emp_ID,
    (SUM(CASE WHEN Status='Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Attendance_Percentage
FROM Attendance
GROUP BY Emp_ID;

SELECT 
    e.Name,
    (s.Basic + s.HRA - s.PF - s.Tax) AS Salary
FROM Employees e
JOIN Salary s ON e.Emp_ID = s.Emp_ID
ORDER BY Salary DESC
LIMIT 1;

SELECT 
    d.Dept_Name,
    SUM(s.Basic + s.HRA) AS Total_Salary
FROM Employees e
JOIN Departments d ON e.Dept_ID = d.Dept_ID
JOIN Salary s ON e.Emp_ID = s.Emp_ID
GROUP BY d.Dept_Name
ORDER BY Total_Salary DESC;


SELECT * FROM Salary;
SELECT * FROM Performance;
SELECT * FROM Departments;
SELECT * FROM Attendance;

CREATE VIEW Employee_Report AS
SELECT e.Name, d.Dept_Name, s.Basic
FROM Employees e
JOIN Departments d ON e.Dept_ID = d.Dept_ID
JOIN Salary s ON e.Emp_ID = s.Emp_ID;
 
 
SELECT * FROM Employee_Report;

DELIMITER $$

CREATE PROCEDURE GetEmployeeSalary()
BEGIN
    SELECT
        e.Emp_ID,
        e.Name,
        (s.Basic + s.HRA - s.PF - s.Tax) AS Net_Salary
    FROM Employees e
    JOIN Salary s ON e.Emp_ID = s.Emp_ID;
END $$

DELIMITER ;

CALL GetEmployeeSalary();


DELIMITER $$

CREATE TRIGGER Bonus_Trigger
BEFORE INSERT ON Performance
FOR EACH ROW
BEGIN
    IF NEW.Rating = 5 THEN
        SET NEW.Bonus = 10000;
    ELSEIF NEW.Rating = 4 THEN
        SET NEW.Bonus = 7000;
    ELSEIF NEW.Rating = 3 THEN
        SET NEW.Bonus = 5000;
    ELSE
        SET NEW.Bonus = 2000;
    END IF;
END $$

DELIMITER ;

INSERT INTO Employees
VALUES (104,'Rahul',1,'2024-02-15');
INSERT INTO Salary
VALUES (104,35000,12000,2000,1500);

INSERT INTO Performance
VALUES (104,'July-2026',5,0);
SELECT * FROM Performance;




