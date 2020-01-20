SELECT
	c_name,
	c_custkey,
	o_orderkey,
	o_orderdate,
	o_totalprice,
	sum(l_quantity)
FROM
	CUSTOMER,
	ORDERS,
	LINEITEM
WHERE
	o_orderkey IN (
		SELECT
			l_orderkey
		FROM
			LINEITEM
		GROUP BY
			l_orderkey
		HAVING
			sum(l_quantity) > 314
	)
AND c_custkey = o_custkey
AND o_orderkey = l_orderkey
GROUP BY
	c_name,
	c_custkey,
	o_orderkey,
	o_orderdate,
	o_totalprice
ORDER BY
	o_totalprice DESC,
	o_orderdate
LIMIT 100;

