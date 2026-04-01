SELECT
    snapshot_month,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN dpd > 0 THEN 1 ELSE 0 END) AS delinquent_loans,
    ROUND(
        SUM(CASE WHEN dpd > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS delinquency_rate_loan_pct,
	
	SUM(outstanding_balance) AS total_balance,
    SUM(CASE WHEN dpd > 0 THEN outstanding_balance ELSE 0 END) AS delinquent_balance,
    ROUND(
        SUM(CASE WHEN dpd > 0 THEN outstanding_balance ELSE 0 END)
        * 100.0 / SUM(outstanding_balance),
        2
    ) AS delinquency_rate_balance_pct
FROM loan_snapshot
GROUP BY snapshot_month
ORDER BY snapshot_month Desc;

