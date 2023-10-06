----Percent of search sessions :

WITH SessionizedActivities AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    LAG(occurred_at) OVER (PARTITION BY user_id ORDER BY occurred_at) AS prev_event_time
  FROM
    users_activity_log
),
Sessions AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    CASE
      WHEN prev_event_time IS NULL OR occurred_at - prev_event_time > INTERVAL '10' MINUTE THEN 1
      ELSE 0
    END AS new_session_flag
  FROM
    SessionizedActivities
)
SELECT
  COUNT(DISTINCT CASE WHEN event_name not IN ('home','login','watchlists','settings','library') THEN user_id END) * 100.0 / COUNT(DISTINCT CASE WHEN new_session_flag = 1 THEN user_id END) AS search_usage_percentage
FROM
  Sessions;




------Percent of search_sessions having query_result_0:

WITH SessionizedActivities AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    LAG(occurred_at) OVER (PARTITION BY user_id ORDER BY occurred_at) AS prev_event_time
  FROM
    users_activity_log
),
Sessions AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    CASE
      WHEN prev_event_time IS NULL OR occurred_at - prev_event_time > INTERVAL '10' MINUTE THEN 1
      ELSE 0
    END AS new_session_flag
  FROM
    SessionizedActivities
)
SELECT
  count(distinct case when event_name= 'query_result_0' then user_id end) as sessions_haiving_query_result_0,
  count(distinct case when event_name= 'query_result_0' then user_id end) * 100.0/COUNT(DISTINCT CASE WHEN event_name not IN ('home','login','watchlists','settings','library') THEN user_id END) as q_0_perc,
  COUNT(DISTINCT CASE WHEN event_name not IN ('home','login','watchlists','settings','library') THEN user_id END) as search_sessions,  COUNT(DISTINCT CASE WHEN new_session_flag = 1 THEN user_id END) as total_sessions
FROM
  Sessions;


-----Percent of search_sessions having autocomplete_engine activity:

WITH SessionizedActivities AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    LAG(occurred_at) OVER (PARTITION BY user_id ORDER BY occurred_at) AS prev_event_time
  FROM
    users_activity_log
),
Sessions AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    CASE
      WHEN prev_event_time IS NULL OR occurred_at - prev_event_time > INTERVAL '10' MINUTE THEN 1
      ELSE 0
    END AS new_session_flag
  FROM
    SessionizedActivities
)
SELECT
  count(distinct case when event_name= 'autocomplete_engine' then user_id end) as sessions_haiving_query_result_0,
  count(distinct case when event_name= 'autocomplete_engine' then user_id end) * 100.0/COUNT(DISTINCT CASE WHEN event_name not IN ('home','login','watchlists','settings','library') THEN user_id END) as autocomplete_perc,
  COUNT(DISTINCT CASE WHEN event_name not IN ('home','login','watchlists','settings','library') THEN user_id END) as search_sessions,  COUNT(DISTINCT CASE WHEN new_session_flag = 1 THEN user_id END) as total_sessions
FROM
  Sessions;


----- Percent of search_sessions where users clicked on the first five or top results of search


WITH SessionizedActivities AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    LAG(occurred_at) OVER (PARTITION BY user_id ORDER BY occurred_at) AS prev_event_time
  FROM
    users_activity_log
),
Sessions AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    CASE
      WHEN prev_event_time IS NULL OR occurred_at - prev_event_time > INTERVAL '10' MINUTE THEN 1
      ELSE 0
    END AS new_session_flag
  FROM
    SessionizedActivities
)
SELECT
  count(distinct case when event_name in ('query_result_1','query_result_2','query_result_3','query_result_4','query_result_5') then user_id end) as sessions_having_first_five_query_results,
  count(distinct case when event_name in ('query_result_1','query_result_2','query_result_3','query_result_4','query_result_5') then user_id end) * 100.0/COUNT(DISTINCT CASE WHEN event_name not IN ('home','login','watchlists','settings','library') THEN user_id END) as top_results_perc,
  COUNT(DISTINCT CASE WHEN event_name not IN ('home','login','watchlists','settings','library') THEN user_id END) as search_sessions,  COUNT(DISTINCT CASE WHEN new_session_flag = 1 THEN user_id END) as total_sessions
FROM
  Sessions;


----- Percent of search_sessions where users clicked on the lower results (from 6 to 10)


WITH SessionizedActivities AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    LAG(occurred_at) OVER (PARTITION BY user_id ORDER BY occurred_at) AS prev_event_time
  FROM
    users_activity_log
),
Sessions AS (
  SELECT
    user_id,
    event_name,
    occurred_at,
    CASE
      WHEN prev_event_time IS NULL OR occurred_at - prev_event_time > INTERVAL '10' MINUTE THEN 1
      ELSE 0
    END AS new_session_flag
  FROM
    SessionizedActivities
)
SELECT
  count(distinct case when event_name in ('query_result_6','query_result_7','query_result_8','query_result_9','query_result_10') then user_id end) as sessions_having_first_five_query_results,
  count(distinct case when event_name in ('query_result_6','query_result_7','query_result_8','query_result_9','query_result_10') then user_id end) * 100.0/COUNT(DISTINCT CASE WHEN event_name not IN ('home','login','watchlists','settings','library') THEN user_id END) as top_results_perc,
  COUNT(DISTINCT CASE WHEN event_name not IN ('home','login','watchlists','settings','library') THEN user_id END) as search_sessions,  COUNT(DISTINCT CASE WHEN new_session_flag = 1 THEN user_id END) as total_sessions
FROM
  Sessions;


-----Which OS faced the frequent unresponsive search :

select os,count(distinct user_id)
from users_activity_log
where event_name = 'query_result_0'
group by 1

-----OS wise number of clicks on query results (1-10) 


select os,count(distinct(case when event_name = 'query_result_0' then user_id end)) as count_query_rslt_0,
count(distinct(case when event_name = 'query_result_1' then user_id end)) as count_query_rslt_1,
count(distinct(case when event_name = 'query_result_2' then user_id end)) as count_query_rslt_2,
count(distinct(case when event_name = 'query_result_3' then user_id end)) as count_query_rslt_3,
count(distinct(case when event_name = 'query_result_4' then user_id end)) as count_query_rslt_4,
count(distinct(case when event_name = 'query_result_5' then user_id end)) as count_query_rslt_5,
count(distinct(case when event_name = 'query_result_6' then user_id end)) as count_query_rslt_6,
count(distinct(case when event_name = 'query_result_7' then user_id end)) as count_query_rslt_7,
count(distinct(case when event_name = 'query_result_8' then user_id end)) as count_query_rslt_8,
count(distinct(case when event_name = 'query_result_9' then user_id end)) as count_query_rslt_9,
count(distinct(case when event_name = 'query_result_10' then user_id end)) as count_query_rslt_10
from users_activity_log
group by 1

----- is the problem with the search RAM specific too?

with joined_table 
as
(select u.user_id,u.occurred_at,u.event_name,u.os,d.os_version,d.device_id,d.name as device_name,d.ram,d.chipset
from users_activity_log u
join device_details d
on u.device_id=d.device_id)
select os_version,device_name,ram,count(distinct user_id)
from joined_table
where event_name='query_result_0'
group by 1,2,3
order by 4 desc



