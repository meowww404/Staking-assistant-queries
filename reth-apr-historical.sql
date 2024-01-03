WITH LatestReadingsData AS (  -- Combine the latest readings ratio for each date
    SELECT
        toDate(timestamp) AS date,
        MAX(timestamp) AS exact_timestamp, 
        MAX(IF(name = 'rocketpool_reth/exchangerate', value, NULL)) AS reth_per_token
    FROM readings
    WHERE name = 'rocketpool_reth/exchangerate'
    GROUP BY date
    HAVING reth_per_token IS NOT NULL
),
DailyRatioChange AS (  -- Calculate the daily ratio change
    SELECT
        curr.date AS current_date,
        curr.exact_timestamp AS current_timestamp,
        prev.exact_timestamp AS previous_timestamp,
        ((CAST(curr.reth_per_token AS Float64) - CAST(prev.reth_per_token AS Float64)) / CAST(prev.reth_per_token AS Float64)) * 365 * 100 AS APR
    FROM LatestReadingsData curr
    JOIN LatestReadingsData prev ON curr.date = prev.date + 1
)
SELECT
    APR,
    current_timestamp,
    previous_timestamp
FROM DailyRatioChange
WHERE APR IS NOT NULL
ORDER BY current_date DESC;
