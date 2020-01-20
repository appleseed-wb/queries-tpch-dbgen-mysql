SELECT
	o_year,
	sum(
		CASE
		WHEN nation = 'INDIA' THEN
			volume
		ELSE
			0
		END
	) / sum(volume) AS mkt_share
FROM
	(
		SELECT
			extract(YEAR FROM o_orderdate) AS o_year,
			l_extendedprice * (1 - l_discount) AS volume,
			n2.n_name AS nation
		FROM
			PART,
			SUPPLIER,
			LINEITEM,
			ORDERS,
			CUSTOMER,
			NATION n1,
			NATION n2,
			REGION
		WHERE
			p_partkey = l_partkey
		AND s_suppkey = l_suppkey
		AND l_orderkey = o_orderkey
		AND o_custkey = c_custkey
		AND c_nationkey = n1.n_nationkey
		AND n1.n_regionkey = r_regionkey
		AND r_name = 'ASIA'
		AND s_nationkey = n2.n_nationkey
		AND o_orderdate BETWEEN date '1995-01-01'
		AND date '1996-12-31'
		AND p_type = 'SMALL PLATED COPPER'
	) AS all_nations
GROUP BY
	o_year
ORDER BY
	o_year;

