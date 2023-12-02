--Exercise

--1
USE alfajedi;

--2
SELECT customer.CustomerName, customer.CustomerEmail, customer.CustomerPhone, transaction_header.TransactionDate
FROM customer join transaction_header
ON customer.CustomerID = transaction_header.CustomerID
WHERE LENGTH(customer.CustomerName) > 10;

--3
SELECT transaction_header.TransactionID, 
MONTHNAME(transaction_header.TransactionDate) AS 'Transaction Month', 
branch.BranchName 
FROM transaction_header JOIN branch
ON transaction_header.BranchID = branch.BranchID 
WHERE MONTH(transaction_header.TransactionDate) = '10'
UNION
SELECT transaction_header.TransactionID, 
MONTHNAME(transaction_header.TransactionDate) AS 'Transaction Month', 
branch.BranchName 
FROM transaction_header JOIN branch
ON transaction_header.BranchID = branch.BranchID 
WHERE MONTH(transaction_header.TransactionDate) = '7'

--4
SELECT transaction_detail.TransactionID, 
DAYNAME(transaction_header.TransactionDate) AS 'Transaction Day', 
staff.StaffName 
FROM transaction_detail JOIN transaction_header JOIN staff
ON transaction_detail.TransactionID = transaction_header.TransactionID and transaction_header.StaffID = staff.StaffID
WHERE CAST(RIGHT(transaction_detail.TransactionID, 4) AS INT) <= 5
UNION
SELECT transaction_detail.TransactionID, 
DAYNAME(transaction_header.TransactionDate) AS 'Transaction Day', 
staff.StaffName 
FROM transaction_detail JOIN transaction_header JOIN staff
ON transaction_detail.TransactionID = transaction_header.TransactionID and transaction_header.StaffID = staff.StaffID
WHERE transaction_detail.Quantity > 10;

--5
ALTER TABLE product
MODIFY COLUMN product.ProductName VARCHAR(60);

--6
DELETE product
FROM product JOIN transaction_detail 
ON product.ProductID = transaction_detail.ProductID
JOIN transaction_header
ON transaction_detail.TransactionID = transaction_header.TransactionID
WHERE MONTH(transaction_header.TransactionDate) = 10 AND DAY(transaction_header.TransactionDate) = 12;

--7
SELECT transaction_header.TransactionID, 
product.ProductName,
transaction_detail.Quantity,
CONCAT(product.ProductStock*transaction_detail.Quantity, '$') AS 'Total Price'
FROM transaction_header JOIN transaction_detail JOIN product
ON transaction_header.TransactionID = transaction_detail.TransactionID AND transaction_detail.ProductID = product.ProductID
WHERE transaction_detail.Quantity > 10 AND product.ProductStock < 200

--8
SELECT staff.StaffName,
MONTHNAME(transaction_header.TransactionDate) AS 'Active Month'
FROM staff JOIN transaction_header
ON staff.StaffID = transaction_header.StaffID
ORDER BY staff.StaffName DESC

--9
CREATE VIEW BranchStaffAllocationView AS
SELECT branch.BranchName, 
branch.BranchAddress,  
REPLACE(staff.StaffID, 'ST', 'Staff') AS 'Assigned Staff'
FROM branch JOIN transaction_header JOIN staff
ON branch.BranchID = transaction_header.BranchID AND transaction_header.StaffID = staff.StaffID
WHERE branch.BranchAddress LIKE '%Java';

--10
CREATE VIEW CustomerStaffBranchView AS

SELECT 
UPPER(customer.CustomerName) AS 'Customer Name',
branch.BranchName,
LOWER(staff.StaffName) AS 'Staff Name',
DATE_FORMAT(transaction_header.TransactionDate, '%M %D %Y') AS 'Transaction Date'
FROM customer JOIN branch JOIN staff JOIN transaction_header
ON branch.BranchID = transaction_header.BranchID AND staff.StaffID = transaction_header.StaffID AND customer.CustomerID = transaction_header.CustomerID;