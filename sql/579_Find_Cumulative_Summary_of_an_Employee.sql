-- -- Write your PostgreSQL query statement below
WITH exclude_most_recent
     AS (SELECT *
         FROM   (SELECT id,
                        month,
                        salary,
                        Rank()
                          OVER(
                            partition BY id
                            ORDER BY month DESC) AS month_rk
                 --    LEAD(salary) OVER(PARTITION BY id ORDER BY month DESC) as prev_1,
                 --    LEAD(salary, 2) OVER(PARTITION BY id ORDER BY month DESC) as prev_2
                 FROM   employee) w
         WHERE  month_rk != 1),
     prev_first_month
     AS (SELECT a.id,
                ( a.month - 1 ) AS prev_first_month,
                b.salary        AS prev_first_salary
         FROM   exclude_most_recent a
                LEFT JOIN exclude_most_recent b
                       ON a.month - 1 = b.month
                          AND a.id = b.id),
     prev_second_month
     AS (SELECT a.id,
                ( a.month - 2 ) AS prev_second_month,
                b.salary        AS prev_second_salary
         FROM   exclude_most_recent a
                LEFT JOIN exclude_most_recent b
                       ON a.month - 2 = b.month
                          AND a.id = b.id)
SELECT e.id,
       e.month,
       ( e.salary + COALESCE(prevs.prev_salaries, 0) ) AS salary
FROM   exclude_most_recent e
       LEFT JOIN (SELECT p1.id                                 AS id,
                         p1.prev_first_month                   AS prev_month,
                         ( COALESCE(prev_first_salary, 0)
                           + COALESCE(prev_second_salary, 0) ) AS prev_salaries
                  FROM   prev_first_month p1
                         INNER JOIN prev_second_month p2
                                 ON p1.id = p2.id
                                    AND p1.prev_first_month =
                                        p2.prev_second_month + 1)
                                              prevs
              ON e.id = prevs.id
                 AND e.month = prevs.prev_month + 1
ORDER  BY e.id ASC,
          e.month DESC; 