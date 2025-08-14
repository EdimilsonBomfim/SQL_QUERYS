

CREATE TABLE BikeStoreCustomers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    AddressID INT
);


CREATE TABLE BikeStoreProducts (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    BrandID INT,
    CategoryID INT,
    ModelYear INT,
    ListPrice DECIMAL(10,2)
);


CREATE TABLE BikeStoreSales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    StoreID INT,
    StaffID INT,
    Quantity INT,
    SaleDate DATE,
    TotalAmount AS (Quantity * (SELECT ListPrice FROM BikeStoreProducts WHERE BikeStoreProducts.ProductID = BikeStoreSales.ProductID))
);



SELECT 
    StoreID,
    COUNT(*) AS TotalVendas,
    SUM(Quantity) AS TotalItensVendidos,
    SUM(Quantity * P.ListPrice) AS ReceitaTotal
FROM BikeStoreSales S
JOIN BikeStoreProducts P ON S.ProductID = P.ProductID
GROUP BY StoreID;


SELECT TOP 5 
    C.CustomerID,
    C.FirstName + ' ' + C.LastName AS Cliente,
    SUM(S.Quantity * P.ListPrice) AS ValorTotal
FROM BikeStoreSales S
JOIN BikeStoreCustomers C ON S.CustomerID = C.CustomerID
JOIN BikeStoreProducts P ON S.ProductID = P.ProductID
GROUP BY C.CustomerID, C.FirstName, C.LastName
ORDER BY ValorTotal DESC;
