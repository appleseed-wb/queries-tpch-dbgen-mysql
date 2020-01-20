SELECT
	100.00 * sum(
		CASE
		WHEN p_type LIKE 'PROMO%' THEN
			l_extendedprice * (1 - l_discount)
		ELSE
			0
		END
	) / sum(l_extendedprice *(1 - l_discount)) AS promo_revenue
FROM
	LINEITEM,
	PART
WHERE
	l_partkey = p_partkey
AND l_shipdate >= date '1996-12-01'
AND l_shipdate < date '1996-12-01' + INTERVAL '1' MONTH;

