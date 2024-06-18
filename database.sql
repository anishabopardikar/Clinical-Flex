CREATE DATABASE IF NOT EXISTS dbms_deadline;
USE dbms_deadline;


-- Create Suppliers table
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Province VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Product_Name VARCHAR(50) NOT NULL,
    Average_Price DECIMAL(10,2) NOT NULL CHECK (Average_Price > 0),
    Recent_date_of_expiry DATE NOT NULL
);

-- Create PlaceOrder table
CREATE TABLE PlaceOrder (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE
);

-- Create Employees table
CREATE TABLE Employees (
   EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
   FirstName VARCHAR(50) NOT NULL,
   LastName VARCHAR(50) NOT NULL,
   CityOfBirth VARCHAR(50) NOT NULL
);

-- Create Orders table
CREATE TABLE Orders (
   OrderID INT AUTO_INCREMENT PRIMARY KEY,
   EmployeeID INT,
   FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);

-- Create Customers table
CREATE TABLE Customers (
  CustomerNumber INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  AddressLine1 VARCHAR(100) NOT NULL, 
  AddressLine2 VARCHAR(100), 
  City VARCHAR (100) NOT NULL, 
  StateProvince VARCHAR (100) NOT NULL, 
  Country VARCHAR (100) NOT NULL, 
  PostalCode VARCHAR (20) NOT NULL, 
  Phone VARCHAR (20) NOT NULL
);

-- Create Inventory table
CREATE TABLE Inventory (
    Inv_ID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    Drug_Name VARCHAR(255) NOT NULL,
    Quantity_on_Hand INT NOT NULL,
    Supplier_ID INT,
    Recent_date_of_expiry DATE NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(SupplierID)
);

-- Create Doctors table
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Registration_ID VARCHAR(10) NOT NULL,
    Specialty VARCHAR(50)
);

-- Create Prescription table
CREATE TABLE Prescription (
    Prescription_No INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE NOT NULL,
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Drug_Name VARCHAR(255) NOT NULL,
    Dosage VARCHAR(255) NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Customers(CustomerNumber),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(DoctorID)
);

-- Dummy entries for Suppliers
INSERT INTO Suppliers (Name, Address, City, Province, PostalCode) VALUES
('Supplier A', '123 Main St', 'Metropolis', 'Metro', '12345'),
('Supplier B', '456 Elm St', 'Gotham', 'Goth', '23456'),
('Supplier C', '789 Pine St', 'Star City', 'Star', '34567'),
('Supplier D', '101 Oak St', 'Central City', 'Central', '45678'),
('Supplier E', '102 Maple St', 'National City', 'National', '56789'),
('Supplier F', '103 Ash St', 'Jump City', 'Jump', '67890'),
('Supplier G', '104 Birch St', 'Blüdhaven', 'Blud', '78901'),
('Supplier H', '105 Cedar St', 'Coast City', 'Coast', '89012'),
('Supplier I', '106 Dogwood St', 'Midway City', 'Midway', '90123'),
('Supplier J', '107 Fir St', 'Ivy Town', 'Ivy', '01234');

-- Dummy entries for Products
INSERT INTO Products (Product_Name, Average_Price, Recent_date_of_expiry) VALUES
('Product 1', 10.99, '2024-12-31'),
('Product 2', 20.99, '2024-11-30'),
('Product 3', 30.99, '2024-10-31'),
('Product 4', 40.99, '2024-09-30'),
('Product 5', 50.99, '2024-08-31'),
('Product 6', 60.99, '2024-07-30'),
('Product 7', 70.99, '2024-06-30'),
('Product 8', 80.99, '2024-05-31'),
('Product 9', 90.99, '2024-04-30'),
('Product 10', 100.99, '2024-03-31');

-- Dummy entries for PlaceOrder
INSERT INTO PlaceOrder (SupplierID) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- Dummy entries for Employees
INSERT INTO Employees (FirstName, LastName, CityOfBirth) VALUES
('John', 'Doe', 'Metropolis'),
('Jane', 'Doe', 'Gotham'),
('Clark', 'Kent', 'Smallville'),
('Bruce', 'Wayne', 'Gotham'),
('Diana', 'Prince', 'Themyscira'),
('Barry', 'Allen', 'Central City'),
('Hal', 'Jordan', 'Coast City'),
('Arthur', 'Curry', 'Atlantis'),
('Victor', 'Stone', 'Detroit'),
('Oliver', 'Queen', 'Star City');

-- Dummy entries for Orders
INSERT INTO Orders (EmployeeID) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- Dummy entries for Customers
INSERT INTO Customers (Name, AddressLine1, AddressLine2, City, StateProvince, Country, PostalCode, Phone) VALUES
('Customer 1', '123 Main St', '', 'Metropolis', 'Metro', 'USA', '12345', '555-1234'),
('Customer 2', '456 Elm St', 'Apt 2', 'Gotham', 'Goth', 'USA', '23456', '555-2345'),
('Customer 3', '789 Pine St', 'Suite 3', 'Star City', 'Star', 'USA', '34567', '555-3456'),
('Customer 4', '101 Oak St', '', 'Central City', 'Central', 'USA', '45678', '555-4567'),
('Customer 5', '102 Maple St', '', 'National City', 'National', 'USA', '56789', '555-5678'),
('Customer 6', '103 Ash St', 'Apt 6', 'Jump City', 'Jump', 'USA', '67890', '555-6789'),
('Customer 7', '104 Birch St', 'Suite 7', 'Blüdhaven', 'Blud', 'USA', '78901', '555-7890'),
('Customer 8', '105 Cedar St', '', 'Coast City', 'Coast', 'USA', '89012', '555-8901'),
('Customer 9', '106 Dogwood St', '', 'Midway City', 'Midway', 'USA', '90123', '555-9012'),
('Customer 10', '107 Fir St', 'Apt 10', 'Ivy Town', 'Ivy', 'USA', '01234', '555-0123');

-- Dummy entries for Inventory
INSERT INTO Inventory (ProductID, Drug_Name, Quantity_on_Hand, Supplier_ID, Recent_date_of_expiry) VALUES
(1, 'Drug A', 100, 1, '2024-12-31'),
(2, 'Drug B', 200, 2, '2024-11-30'),
(3, 'Drug C', 300, 3, '2024-10-31'),
(4, 'Drug D', 400, 4, '2024-09-30'),
(5, 'Drug E', 500, 5, '2024-08-31'),
(6, 'Drug F', 600, 6, '2024-07-30'),
(7, 'Drug G', 700, 7, '2024-06-30'),
(8, 'Drug H', 800, 8, '2024-05-31'),
(9, 'Drug I', 900, 9, '2024-04-30'),
(10, 'Drug J', 1000, 10, '2024-03-31');

-- Dummy entries for Doctors
INSERT INTO Doctors (FirstName, LastName, Registration_ID, Specialty) VALUES
('Doctor A', 'Who', 'R1234', 'General'),
('Doctor B', 'Strange', 'R2345', 'Surgery'),
('Doctor C', 'House', 'R3456', 'Diagnostic'),
('Doctor D', 'Watson', 'R4567', 'General'),
('Doctor E', 'Octopus', 'R5678', 'Neurology'),
('Doctor F', 'Fate', 'R6789', 'Cardiology'),
('Doctor G', 'Holliday', 'R7890', 'Dentistry'),
('Doctor H', 'Banner', 'R8901', 'Radiology'),
('Doctor I', 'Xavier', 'R9012', 'Psychiatry'),
('Doctor J', 'Jekyll', 'R0123', 'Pharmacology');

-- Dummy entries for Prescription
INSERT INTO Prescription (Date, Patient_ID, Doctor_ID, Drug_Name, Dosage) VALUES
('2023-01-01', 1, 1, 'Drug A', '2 pills daily'),
('2023-02-01', 2, 2, 'Drug B', '1 pill daily'),
('2023-03-01', 3, 3, 'Drug C', '3 pills daily'),
('2023-04-01', 4, 4, 'Drug D', '2 pills daily'),
('2023-05-01', 5, 5, 'Drug E', '1 pill daily'),
('2023-06-01', 6, 6, 'Drug F', '3 pills daily'),
('2023-07-01', 7, 7, 'Drug G', '2 pills daily'),
('2023-08-01', 8, 8, 'Drug H', '1 pill daily'),
('2023-09-01', 9, 9, 'Drug I', '3 pills daily'),
('2023-10-01', 10, 10, 'Drug J', '2 pills daily');







-- Transaction 1: Add a new supplier, product, and drug from that supplier to the inventory
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
INSERT INTO Suppliers (Name, Address, City, Province, PostalCode) 
VALUES ('MediSupply', '123 Health St', 'New York', 'NY', '10001');
INSERT INTO Products (Product_Name, Average_Price, Recent_date_of_expiry) 
VALUES ('Aspirin', 10.99, '2025-12-31');
INSERT INTO Inventory (ProductID, Drug_Name, Quantity_on_Hand, Supplier_ID, Recent_date_of_expiry) 
VALUES (LAST_INSERT_ID(), 'Aspirin', 1000, (SELECT SupplierID FROM Suppliers WHERE Name = 'MediSupply'), '2025-12-31');
COMMIT;

-- Transaction 2: Add a new product and add it to the inventory with the price set by the supplier
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
INSERT INTO Products (Product_Name, Average_Price, Recent_date_of_expiry) 
VALUES ('Ibuprofen', 1.00, '2025-12-31');
INSERT INTO Inventory (ProductID, Drug_Name, Quantity_on_Hand, Supplier_ID, Recent_date_of_expiry) 
VALUES (LAST_INSERT_ID(), 'Ibuprofen', 1000, (SELECT SupplierID FROM Suppliers WHERE Name='MediSupply'), '2025-12-31');
COMMIT;

-- Transaction 3: Add a new prescription, update inventory, add a new order, and place the order with the supplier
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
INSERT INTO Prescription (Date, Patient_ID, Doctor_ID, Drug_Name, Dosage) 
VALUES (NOW(), 5, 6, 'Aspirin', 'Take one pill daily');
UPDATE Inventory SET Quantity_on_Hand = Quantity_on_Hand - 600 WHERE ProductID = (SELECT ProductID FROM Products WHERE Product_Name='Aspirin');
INSERT INTO Orders (EmployeeID) VALUES (1); -- Assuming EmployeeID 1 exists
INSERT INTO PlaceOrder (OrderID, SupplierID) 
VALUES (LAST_INSERT_ID(), (SELECT SupplierID FROM Suppliers WHERE Name='MediSupply'));
COMMIT;

-- Transaction 4: Add a new order, place the order with the supplier, and update the related customer's address
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
INSERT INTO Orders (EmployeeID) VALUES (1); -- Assuming EmployeeID 1 exists
INSERT INTO PlaceOrder (OrderID, SupplierID) 
VALUES (LAST_INSERT_ID(), (SELECT SupplierID FROM Suppliers WHERE Name='MediSupply'));
UPDATE Customers SET AddressLine1 = '456 Wellness Ave' WHERE CustomerNumber = 5;
COMMIT;

-- Conflicting transactions

-- Transaction 5: Attempt to delete a supplier while updating their related inventory
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
DROP TEMPORARY TABLE IF EXISTS TempSuppliers;
CREATE TEMPORARY TABLE TempSuppliers AS
SELECT SupplierID FROM Suppliers WHERE Name = 'MediSupply';
DELETE FROM Inventory WHERE Supplier_ID = (SELECT SupplierID FROM TempSuppliers); -- Remove related inventory records first
DELETE FROM Suppliers WHERE SupplierID = (SELECT SupplierID FROM TempSuppliers);
DROP TEMPORARY TABLE TempSuppliers;
COMMIT;

-- Meanwhile, another transaction tries to update the inventory of the deleted supplier
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE Inventory SET Quantity_on_Hand = 200 WHERE Supplier_ID = (SELECT SupplierID FROM (SELECT SupplierID FROM Suppliers WHERE Name='MediSupply') AS subquery);
COMMIT;

-- Transaction 6: Attempt to read a supplier while another transaction is updating the same supplier
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
DROP TEMPORARY TABLE IF EXISTS TempSuppliers;
CREATE TEMPORARY TABLE TempSuppliers AS
SELECT SupplierID FROM Suppliers WHERE Name = 'MediSupply';
SELECT * FROM Suppliers WHERE SupplierID = (SELECT SupplierID FROM TempSuppliers);
DROP TEMPORARY TABLE TempSuppliers;
COMMIT;

-- Meanwhile, another transaction tries to update the same supplier
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE Suppliers SET Name = 'NewSupplierName' WHERE SupplierID = (SELECT SupplierID FROM (SELECT SupplierID FROM Suppliers WHERE Name='MediSupply') AS subquery);
COMMIT;

CREATE TABLE users(
id SERIAL PRIMARY KEY,
email VARCHAR(100) NOT NULL UNIQUE,
password VARCHAR(100)
)

GRANT ALL PRIVILEGES ON dbms_deadline.* TO 'root'@'localhost' IDENTIFIED BY 'your_mysql_password';
FLUSH PRIVILEGES;

SELECT * FROM Inventory;
