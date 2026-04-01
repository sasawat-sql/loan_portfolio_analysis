SELECT
    prev_month,
    from_bucket,
    sum(CASE WHEN to_bucket='Current' THEN roll_rate ELSE 0 END) AS to_current,
    sum(CASE WHEN to_bucket='DPD_1-30' THEN roll_rate ELSE 0 END) AS to_1_30,
    sum(CASE WHEN to_bucket='DPD_31-60' THEN roll_rate ELSE 0 END) AS to_31_60,
    sum(CASE WHEN to_bucket='DPD_61-90' THEN roll_rate ELSE 0 END) AS to_61_90,
    sum(CASE WHEN to_bucket='90+' THEN roll_rate ELSE 0 END) AS to_90_plus

FROM roll_rate_table
GROUP BY
    prev_month,
    from_bucket
ORDER BY
    prev_month,
    from_bucket;