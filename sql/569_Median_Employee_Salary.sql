-- Write your PostgreSQL query statement below
WITH grouped_count_odd AS (
    SELECT company, count(*) as count
    FROM Employee
    GROUP BY company
    HAVING mod(count(*),2) = 1
),
grouped_count_even AS (
    SELECT company, count(*) as count
    FROM Employee
    GROUP BY company
    HAVING mod(count(*),2) = 0
    
),
salary_rank AS (
    SELECT id
         , company
         , salary 
         , ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary, id) AS rank
    FROM Employee
),
merged_rank_odd AS (
    SELECT sr.id, gc.company, sr.salary, sr.rank, gc.count
    FROM salary_rank sr LEFT JOIN grouped_count_odd gc
    ON sr.company = gc.company
    WHERE (gc.count/2) +1 = sr.rank
),
merged_rank_even AS (
    SELECT sr.id, gc.company, sr.salary, sr.rank, gc.count
    FROM salary_rank sr LEFT JOIN grouped_count_even gc
    ON sr.company = gc.company
    WHERE gc.count/2 = sr.rank 
       OR (gc.count/2) + 1 = sr.rank 
)
SELECT id, company, salary FROM merged_rank_odd
UNION 
SELECT id, company, salary FROM merged_rank_even