-- Credit Risk Portfolio Analysis
-- Step 3: Calculate Roll Rate
-- Objective: Measure delinquency migration between months
-- Author: Sasawat
-- Dataset: loan_snapshot

DROP TABLE IF EXISTS roll_rate_table;
CREATE TABLE roll_rate_table AS
WITH base AS (
    SELECT
        loan_id,
        snapshot_date,
        CASE
            WHEN dpd = 0 THEN 'Current'
            WHEN dpd BETWEEN 1 AND 30 THEN 'DPD_1-30'
            WHEN dpd BETWEEN 31 AND 60 THEN 'DPD_31-60'
            WHEN dpd BETWEEN 61 AND 90 THEN 'DPD_61-90'
            ELSE '90+'
        END AS dpd_bucket
    FROM loan_snapshot
),

movement AS (
    SELECT
        a.snapshot_date AS prev_month,
        a.dpd_bucket AS from_bucket,
        b.dpd_bucket AS to_bucket,
        COUNT(*) AS account_movement
    FROM base a
    JOIN base b
        ON a.loan_id = b.loan_id
        AND date(a.snapshot_date, '+1 month') = b.snapshot_date
    GROUP BY prev_month, from_bucket, to_bucket
),

total_from AS (
    SELECT
        prev_month,
        from_bucket,
        SUM(account_movement) AS total_account
    FROM movement
    GROUP BY prev_month, from_bucket
)

SELECT
    m.prev_month,
    m.from_bucket,
    m.to_bucket,
    m.account_movement,
    t.total_account,
    ROUND(1.0*m.account_movement/t.total_account,4) AS roll_rate
FROM movement m
JOIN total_from t
ON m.prev_month=t.prev_month
AND m.from_bucket=t.from_bucket
ORDER BY m.prev_month, m.from_bucket, m.to_bucket;