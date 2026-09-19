-- Create Database
CREATE DATABASE jomato;
GO

-- Use Database
USE jomato;
GO

-- Create Table
CREATE TABLE restaurant (
    orderId INT,
    RestaurantName VARCHAR(255),
    RestaurantType VARCHAR(255),
    Rating FLOAT,
    No_of_Rating INT,
    AverageCost INT,
    OnlineOrder VARCHAR(255),
    TableBooking VARCHAR(255),
    CuisinesType VARCHAR(255),
    Area VARCHAR(255),
    LocalAddress VARCHAR(255),
    Deliverytime INT
);

-- View Table
SELECT * FROM restaurant;

-- Import CSV Data
BULK INSERT dbo.restaurant
FROM 'C:\Users\user\OneDrive\Attachments\jomato.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2
);

-- Function to Modify Restaurant Type
CREATE FUNCTION dbo.chicken (@restType VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
    RETURN REPLACE(@restType, 'Quick Bites', 'Quick Chicken Bites');
END;

-- Apply Function
SELECT 
    RestaurantName,
    CuisinesType,
    dbo.chicken(RestaurantType) AS Updated_Type,
    No_of_Rating
FROM restaurant
ORDER BY No_of_Rating DESC;

-- Rating Categorization
SELECT 
    RestaurantName,
    Rating,
    CASE
        WHEN Rating >= 4.0 THEN 'Excellent'
        WHEN Rating > 3.5 THEN 'Good'
        WHEN Rating > 3.0 THEN 'Average'
        ELSE 'Bad'
    END AS RatingStatus
FROM restaurant;

-- Mathematical & Date Functions
SELECT 
    RestaurantName,
    Rating,
    CEILING(Rating) AS CeilValue,
    FLOOR(Rating) AS FloorValue,
    ABS(Rating) AS AbsValue,
    GETDATE() AS CurrentDate,
    YEAR(GETDATE()) AS Year_,
    DATENAME(MONTH, GETDATE()) AS Month_Name,
    DATENAME(WEEKDAY, GETDATE()) AS Day_Name
FROM restaurant;

-- Aggregation with ROLLUP
SELECT 
    CASE 
        WHEN GROUPING(RestaurantType) = 1 THEN 'Grand Total'
        ELSE RestaurantType
    END AS RestaurantType,
    SUM(AverageCost) AS Total_AverageCost
FROM restaurant
GROUP BY ROLLUP(RestaurantType);