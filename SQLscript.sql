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


