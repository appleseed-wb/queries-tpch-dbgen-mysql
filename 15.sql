CREATE VIEW REVENUE0 (supplier_no, total_revenue) AS SELECT
	l_suppkey,
	sum(l_extendedprice *(1 - l_discount))
FROM
	LINEITEM
WHERE
	l_shipdate >= date '1997-07-01'
AND l_shipdate < date '1997-07-01' + INTERVAL '3' MONTH
GROUP BY
	l_suppkey;

SELECT
	s_suppkey,
	s_name,
	s_address,
	s_phone,
	total_revenue
FROM
	SUPPLIER,
	REVENUE0
WHERE
	s_suppkey = supplier_no
AND total_revenue = (
	SELECT
		max(total_revenue)
	FROM
		REVENUE0
)
ORDER BY
	s_suppkey;

DROP VIEW REVENUE0;

