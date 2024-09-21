SELECT CASE
         WHEN Mod(id, 2) = 0 THEN id - 1
         WHEN id = (SELECT Max(id)
                    FROM   seat)
              AND Mod(id, 2) = 1 THEN id
         ELSE id + 1
       END AS id,
       student
FROM   seat
ORDER  BY id; 