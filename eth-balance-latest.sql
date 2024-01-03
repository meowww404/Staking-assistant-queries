SELECT 
    name,
    address, 
    blocknumber, 
    toFloat64(balance) / 1e18 AS balance, 
    timestamp
FROM "balances"
WHERE address = '0x02528938C78201f19AC4178d13CCabf4B4F180DF' -- Change to other wallet address here
ORDER BY blocknumber DESC
LIMIT 1;
