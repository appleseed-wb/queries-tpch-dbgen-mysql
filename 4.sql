SELECT
	o_orderpriority,
	count(*) AS order_count
FROM
	ORDERS
WHERE
	o_orderdate >= date '1995-01-01'
AND o_orderdate < date '1995-01-01' + INTERVAL '3' MONTH
AND EXISTS (
	SELECT
		*
	FROM
		LINEITEM
	WHERE
		l_orderkey = o_orderkey
	AND l_commitdate < l_receiptdate
)
GROUP BY
	o_orderpriority
ORDER BY
	o_orderpriority;

