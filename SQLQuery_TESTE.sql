uSE DBTeste

CREATE TABLE BikeStoreCustomers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    AddressID INT
);

INSERT INTO BikeStoreCustomers (CustomerID, FirstName, LastName, Email, Phone, AddressID)
VALUES
(1, 'Lucas', 'Almeida', 'lucas.almeida@email.com', '11988880001', 1001),
(2, 'Juliana', 'Mendes', 'juliana.mendes@email.com', '11988880002', 1002),
(3, 'Rafael', 'Costa', 'rafael.costa@email.com', '11988880003', 1003),
(4, 'Amanda', 'Silva', 'amanda.silva@email.com', '11988880004', 1004),
(5, 'Bruno', 'Oliveira', 'bruno.oliveira@email.com', '11988880005', 1005);
---------------------------------------------------------------------------------------------------------------


CREATE TABLE BikeStoreProducts (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    BrandID INT,
    CategoryID INT,
    ModelYear INT,
    ListPrice DECIMAL(10,2)
);

INSERT INTO BikeStoreProducts (ProductID, ProductName, BrandID, CategoryID, ModelYear, ListPrice)
VALUES
(101, 'SpeedX Road 500', 1, 1, 2023, 2999.90),
(102, 'Mountain King 700', 2, 2, 2022, 4599.00),
(103, 'City Cruiser 300', 3, 3, 2024, 1899.50),
(104, 'Trail Explorer 900', 1, 2, 2023, 3799.99),
(105, 'Eco Urban 100', 4, 3, 2021, 999.00);

--------------------------------------------------------------------------------------------------------------

CREATE TABLE BikeStoreSales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    StoreID INT,
    StaffID INT,
    Quantity INT,
    SaleDate DATE
);


INSERT INTO BikeStoreSales (SaleID, CustomerID, ProductID, StoreID, StaffID, Quantity, SaleDate)
VALUES
(1001, 1, 101, 1, 201, 1, '2024-01-15'),
(1002, 2, 102, 1, 202, 2, '2024-02-10'),
(1003, 3, 103, 2, 203, 1, '2024-03-05'),
(1004, 4, 104, 2, 204, 3, '2024-04-20'),
(1005, 5, 105, 3, 205, 1, '2024-05-12');
--------------------------------------------------------------------------------------------------------------




------ Total de vendas por loja  -----------------------------------------------
SELECT 
    StoreID,
    COUNT(*) AS TotalVendas,
    SUM(Quantity) AS TotalItensVendidos,
    SUM(Quantity * P.ListPrice) AS ReceitaTotal
FROM BikeStoreSales S
JOIN BikeStoreProducts P ON S.ProductID = P.ProductID
GROUP BY StoreID;

------------------ Top 5 clientes por valor total ----------------------------------------
SELECT TOP 5 
    C.CustomerID,
    C.FirstName + ' ' + C.LastName AS Cliente,
    SUM(S.Quantity * P.ListPrice) AS ValorTotal
FROM BikeStoreSales S
JOIN BikeStoreCustomers C ON S.CustomerID = C.CustomerID
JOIN BikeStoreProducts P ON S.ProductID = P.ProductID
GROUP BY C.CustomerID, C.FirstName, C.LastName
ORDER BY ValorTotal DESC;


------------- Consulta paginada de vendas----------------------------------------------------
DECLARE @PageNumber INT = 2;
DECLARE @PageSize INT = 10;

SELECT 
    ProductID,
    ProductName,
    ListPrice,
    ModelYear
FROM BikeStoreProducts
ORDER BY ProductName
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;
