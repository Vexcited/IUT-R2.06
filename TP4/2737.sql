WITH most_clients AS (
    SELECT name, customers_number
    FROM lawyers
    ORDER BY customers_number DESC
    LIMIT 1
),
fewest_clients AS (
    SELECT name, customers_number
    FROM lawyers
    ORDER BY customers_number
    LIMIT 1
),
average_clients AS (
    SELECT 'Average' AS name, ROUND(AVG(customers_number)) AS customers_number
    FROM lawyers
)
SELECT * FROM most_clients
UNION ALL
SELECT * FROM fewest_clients
UNION ALL
SELECT * FROM average_clients;
