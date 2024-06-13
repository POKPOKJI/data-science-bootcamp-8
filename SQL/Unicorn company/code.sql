-- แบบแรก ใช้ limit ในการหา top industries
WITH top3 AS (SELECT
		indus.industry,
		COUNT(*)
	FROM industries indus
	JOIN dates da
	ON da.company_id = indus.company_id
	WHERE EXTRACT (year from da.date_joined) BETWEEN 2019 AND 2021
	GROUP BY industry
	ORDER BY count DESC
	LIMIT 3)

SELECT
	industry,
	EXTRACT (year from da.date_joined) as year,
	COUNT(*) as num_unicorns,
	ROUND(AVG(valuation)/1000000000,2) as average_valuation_billions
FROM industries indus
JOIN funding fund
ON indus.company_id = fund.company_id
JOIN dates da
ON da.company_id = indus.company_id
WHERE indus.industry IN (SELECT industry from top3)
GROUP BY industry , year
HAVING EXTRACT (year from da.date_joined) BETWEEN 2019 AND 2021
ORDER BY year DESC, average_valuation_billions DESC;

-- แบบ 2 ใช้ rank() ในการหา top industries
WITH top3 AS (SELECT
		indus.industry,
		COUNT(*),
		RANK() OVER (ORDER BY COUNT(*) DESC)
	FROM industries indus
	JOIN dates da
	ON da.company_id = indus.company_id
	WHERE EXTRACT (year from da.date_joined) BETWEEN 2019 AND 2021
	GROUP BY industry)

SELECT
	industry,
	EXTRACT (year from da.date_joined) as year,
	COUNT(*) as num_unicorns,
	ROUND(AVG(valuation)/1000000000,2) as average_valuation_billions
FROM industries indus
JOIN funding fund
ON indus.company_id = fund.company_id
JOIN dates da
ON da.company_id = indus.company_id
WHERE indus.industry IN (SELECT industry from top3 WHERE rank BETWEEN 1 AND 3)
GROUP BY industry , year
HAVING EXTRACT (year from da.date_joined) BETWEEN 2019 AND 2021
ORDER BY year DESC, average_valuation_billions DESC;
