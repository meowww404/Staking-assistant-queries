SELECT
    toDate(timestamp) AS date,
    COUNT(DISTINCT address) AS totalStakers
FROM balances
WHERE
    name = 'balance/rocketpool_reth' AND 
    CAST(balance AS Float64) > 0 
GROUP BY date
ORDER BY date;