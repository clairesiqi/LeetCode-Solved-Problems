SELECT employee_id
FROM 
    (SELECT a.employee_id AS employee_id
          , b.name as manager_name
          , a.salary as salary
     FROM employees a 
            LEFT JOIN employees b 
                   ON a.manager_id = b.employee_id
     WHERE a.manager_id IS NOT NULL) joined
                 
WHERE salary < 30000 AND manager_name IS NULL
ORDER BY employee_id;
