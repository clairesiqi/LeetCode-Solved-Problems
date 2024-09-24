-- Write your PostgreSQL query statement below
WITH requester AS
(
         SELECT   requester_id AS id,
                  Count(*)     AS num_friends
         FROM     requestaccepted
         GROUP BY requester_id ), accepter AS
(
         SELECT   accepter_id AS id,
                  Count(*)    AS num_friends
         FROM     requestaccepted
         GROUP BY accepter_id )
SELECT   id,
         Sum(num_friends) AS num
FROM     (
                SELECT *
                FROM   requester
                UNION ALL
                SELECT *
                FROM   accepter) all_friends
GROUP BY id
ORDER BY num DESC limit 1