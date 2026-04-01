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
    GROUP BY
        prev_month, from_bucket, to_bucket
)
SELECT *
FROM movement
ORDER BY prev_month, from_bucket, to_bucket;