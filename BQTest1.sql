-- Prompt: "For each customer, identify their total spending, average order value, and the number of distinct product categories 
-- they've purchased from. Then, categorize customers into loyalty tiers based on their total spending: 'Bronze' for spending 
-- less than $1000, 'Silver' for spending between $1000 and $5000, and 'Gold' for spending over $5000. 
-- Finally, show the top 5 product categories with the highest average order value across all customers."

WITH
  CustomerSpending AS (
  SELECT
    c.FirstName,
    c.LastName,
    SUM(o.TotalAmount) AS TotalSpending,
    AVG(o.TotalAmount) AS AverageOrderValue,
    COUNT(DISTINCT oi.ProductId) AS DistinctProductCategories
  FROM
    `data-coe-415810`.`teradatatobq`.`customer` AS c
  JOIN
    `data-coe-415810`.`teradatatobq`.`orders` AS o
  ON
    c.Id = o.CustomerId
  JOIN
    `data-coe-415810`.`teradatatobq`.`ORDERITEM` AS oi
  ON
    o.Id = oi.OrderId
  GROUP BY
    c.FirstName,
    c.LastName ),
  LoyaltyTiers AS (
  SELECT
    FirstName,
    LastName,
    CASE
      WHEN TotalSpending < 1000 THEN 'Bronze'
      WHEN TotalSpending >= 1000
    AND TotalSpending <= 5000 THEN 'Silver'
      ELSE 'Gold'
  END
    AS LoyaltyTier
  FROM
    `CustomerSpending` )
SELECT
  lt.FirstName,
  lt.LastName,
  lt.LoyaltyTier,
  cs.AverageOrderValue,
  cs.DistinctProductCategories
FROM
  `LoyaltyTiers` AS lt
JOIN
  `CustomerSpending` AS cs
ON
  lt.FirstName = cs.FirstName
  AND lt.LastName = cs.LastName
ORDER BY
  cs.AverageOrderValue DESC
LIMIT
  5;
