SELECT *
FROM roll_rate_table
WHERE 
    (from_bucket='DPD_1-30' AND to_bucket='DPD_31-60')
    OR
    (from_bucket='DPD_1-30' AND to_bucket='Current')
    OR
    (from_bucket='DPD_61-90' AND to_bucket='90+');