-- Question 1 Achieving 1NF (First Normal Form)
SELECT OrderID, CustomerName, TRIM(Product) AS Product
FROM (
    SELECT OrderID, CustomerName, 
           SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1) AS Product
    FROM ProductDetail
    CROSS JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
                UNION ALL SELECT 5 UNION ALL SELECT 6) n
    WHERE n.n <= LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) + 1
) AS ProductsSplit;

-- Question 2 Achieving 2NF (Second Normal Form)

-- Step 1: Create a new table for OrderDetails
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Step 2: Insert distinct OrderID and CustomerName into Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create a new table for OrderItems 
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Insert OrderID, Product, and Quantity into OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
