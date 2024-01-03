SELECT DISTINCT 
    name,
    value,
    MAX(timestamp) AS timestamp
FROM readings
WHERE name = 'rocketpool_reth/exchangerate'
GROUP BY 1, 2
ORDER BY timestamp DESC;