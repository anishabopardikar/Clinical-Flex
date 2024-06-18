-- Transaction 1: Add a new supplier, add a new product, and add a new drug from that supplier to the inventory
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
LOCK TABLES Suppliers WRITE, Products WRITE, Inventory WRITE;
START TRANSACTION;
INSERT INTO Suppliers (SupplierID, Name, Address, City, Province, PostalCode) 
VALUES (101, 'MediSupply', '123 Health St', 'New York', 'NY', '10001');
INSERT INTO Products (ProductID, Product_Name, Average_Price, Total_Quantity, Recent_date_of_expiry) 
VALUES (201, 'Aspirin', 10.99, 1000, '2025-12-31');
INSERT INTO Inventory (Inv_ID, ProductID, Drug_Name, Drug_Description, Quantity_on_Hand, Price, Supplier_ID, Recent_date_of_expiry) 
VALUES (301, 201, 'Aspirin', 'Pain reliever', 1000, 10.99, 101, '2025-12-31');
COMMIT;
UNLOCK TABLES;


-- Transaction 2: Add a new product and add it to the inventory with the price set by the supplier
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
LOCK TABLES Products WRITE, Inventory WRITE;
START TRANSACTION;
INSERT INTO Products (ProductID, Product_Name, Average_Price, Total_Quantity, Recent_date_of_expiry) 
VALUES (202, 'Ibuprofen', 1, 1, '2025-12-31'); -- Average_Price and Total_Quantity will be updated by a trigger
INSERT INTO Inventory (Inv_ID, ProductID, Drug_Name, Drug_Description, Quantity_on_Hand, Price, Supplier_ID, Recent_date_of_expiry) 
VALUES (302, 202, 'Ibuprofen', 'Pain reliever', 1000, 9.99, 101, '2025-12-31');
COMMIT;
UNLOCK TABLES;


-- Transaction 3: Add a new prescription, update inventory, add a new order, and place the order with the supplier
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
LOCK TABLES Prescription WRITE, Inventory WRITE, Orders WRITE, PlaceOrder WRITE;
START TRANSACTION;
INSERT INTO Prescription (Prescription_No, Date_of_Prescription, Patient_ID, Doctor_ID, Drug_Name, Dosage) 
VALUES (401, NOW(), 5, 6, 'Aspirin', 'Take one pill daily');
UPDATE Inventory SET Quantity_on_Hand = 400 WHERE ProductID = 201;
INSERT INTO Orders (OrderID, Prescription_ID, CustomerNumber, Date_of_order) 
VALUES (301, 401, 5, NOW());
INSERT INTO PlaceOrder (OrderID, SupplierID) 
VALUES (301, 101);
COMMIT;
UNLOCK TABLES;


-- Transaction 4: Add a new order, place the order with the supplier, and update the related customer's address
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
LOCK TABLES Orders WRITE, PlaceOrder WRITE, Customers WRITE;
START TRANSACTION;
INSERT INTO Orders (OrderID, Prescription_ID, CustomerNumber, Date_of_order) 
VALUES (302, 4, 5, NOW());
INSERT INTO PlaceOrder (OrderID, SupplierID) 
VALUES (302, 101);
UPDATE Customers SET AddressLine1 = '456 Wellness Ave' WHERE CustomerNumber = 5;
COMMIT;
UNLOCK TABLES;




-- Conflicting transactions


-- Transaction 5: Attempt to delete a supplier while updating their related inventory
START TRANSACTION;
DELETE FROM Suppliers WHERE SupplierID = 101;
-- Meanwhile, another transaction tries to update the inventory of the deleted supplier
START TRANSACTION;
UPDATE Inventory SET Quantity_on_Hand = 200 WHERE Supplier_ID = 101;
-- This will cause a conflict as one transaction is trying to delete a record while another is trying to update it
COMMIT;


-- Transaction 6: Attempt to read a supplier while another transaction is updating the same supplier
START TRANSACTION;
SELECT * FROM Suppliers WHERE SupplierID = 101;
-- Meanwhile, another transaction tries to update the same supplier
START TRANSACTION;
UPDATE Suppliers SET Name = 'NewSupplierName' WHERE SupplierID = 101;
-- This will cause a conflict as one transaction is trying to read a record while another is trying to update it
COMMIT;
