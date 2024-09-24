SELECT NAME
FROM   (SELECT DISTINCT w.managerid AS id,
                        e.NAME      AS NAME
        FROM   (SELECT managerid,
                       Row_number()
                         OVER(
                           partition BY managerid) AS count
                FROM   employee
                WHERE  managerid IS NOT NULL) w
               INNER JOIN employee e
                       ON w.managerid = e.id
        WHERE  w.count >= 5) x 