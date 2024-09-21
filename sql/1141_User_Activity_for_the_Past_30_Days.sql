SELECT activity_date AS day,
       Count(DISTINCT(user_id)) AS active_users
FROM   activity
WHERE  activity_date BETWEEN Date_sub('2019-07-27', INTERVAL 29 day) AND '2019-07-27'
GROUP  BY day;