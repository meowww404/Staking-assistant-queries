WITH ShareRateData AS (
    SELECT
        toDate(timestamp) AS date,
        MAX(timestamp) AS exact_timestamp, 
        MAX(IF(name = 'lido_steth/totalsupply', value, NULL)) AS total_supply,
        MAX(IF(name = 'lido_steth/totalshares', value, NULL)) AS total_shares
    FROM readings
    WHERE name IN ('lido_steth/totalsupply', 'lido_steth/totalshares')
    GROUP BY date
    HAVING total_supply IS NOT NULL AND total_shares IS NOT NULL
),
DailyShareRate AS (
    SELECT
        date,
        exact_timestamp, 
        CAST(total_supply AS Float64) / CAST(total_shares AS Float64) AS share_rate
    FROM ShareRateData
),
APRCalculation AS (
    SELECT
        curr.date AS current_date,
        curr.exact_timestamp AS current_timestamp,
        prev.exact_timestamp AS previous_timestamp,
        ((curr.share_rate - prev.share_rate) / prev.share_rate) * 365 * 100 AS APR
    FROM DailyShareRate curr
    JOIN DailyShareRate prev ON curr.date = prev.date + 1
)
SELECT
    APR,
    current_timestamp,
    previous_timestamp
FROM APRCalculation
WHERE APR IS NOT NULL
ORDER BY current_date DESC
LIMIT 1;
