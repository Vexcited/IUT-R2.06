-- https://judge.beecrowd.com/en/problems/view/2993
SELECT amount AS most_frequent_value
FROM value_table
GROUP BY amount
ORDER BY COUNT(*) DESC
LIMIT 1;
