SELECT
	c_count,
	count(*) AS custdist
FROM
	(
		SELECT
			c_custkey,
			count(o_orderkey) AS c_count
		FROM
			CUSTOMER
		LEFT OUTER JOIN ORDERS ON c_custkey = o_custkey
		AND o_comment NOT LIKE '%pending%deposits%'
		GROUP BY
			c_custkey
	) c_orders
GROUP BY
	c_count
ORDER BY
	custdist DESC,
	c_count DESC;

