SELECT
    snapshot_date,
    CASE
        WHEN dpd = 0 THEN 'Current'
        WHEN dpd BETWEEN 1 AND 30 THEN '1-30'
        WHEN dpd BETWEEN 31 AND 60 THEN '31-60'
        WHEN dpd BETWEEN 61 AND 90 THEN '61-90'
        ELSE '90+'
    END AS dpd_bucket,
    COUNT(*) AS account_count,
    SUM(outstanding_balance) AS total_balance
FROM loan_snapshot
GROUP BY snapshot_date, dpd_bucket
ORDER BY snapshot_date, 
    CASE
        WHEN dpd_bucket = 'Current' THEN 1
        WHEN dpd_bucket = '1-30' THEN 2
        WHEN dpd_bucket = '31-60' THEN 3
        WHEN dpd_bucket = '61-90' THEN 4
        ELSE 5
    END 