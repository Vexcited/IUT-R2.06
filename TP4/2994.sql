-- https://judge.beecrowd.com/en/problems/view/2994
WITH doctor_salaries AS (
    SELECT
        a.id_doctor,
        SUM((a.hours * 150) * (1 + w.bonus / 100.0)) AS total_salary
    FROM
        attendances a
    JOIN
        work_shifts w ON a.id_work_shift = w.id
    GROUP BY
        a.id_doctor
)

SELECT
    d.name AS name,
    ROUND(ds.total_salary, 1) AS salary
FROM
    doctors d
JOIN
    doctor_salaries ds ON d.id = ds.id_doctor
ORDER BY
    salary DESC;
