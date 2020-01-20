SELECT
	s_name,
	s_address
FROM
	SUPPLIER,
	NATION
WHERE
	s_suppkey IN (
		SELECT
			ps_suppkey
		FROM
			PARTSUPP
		WHERE
			ps_partkey IN (
				SELECT
					p_partkey
				FROM
					PART
				WHERE
					p_name LIKE 'green%'
			)
		AND ps_availqty > (
			SELECT
				0.5 * sum(l_quantity)
			FROM
				LINEITEM
			WHERE
				l_partkey = ps_partkey
			AND l_suppkey = ps_suppkey
			AND l_shipdate >= date '1993-01-01'
			AND l_shipdate < date '1993-01-01' + INTERVAL '1' YEAR
		)
	)
AND s_nationkey = n_nationkey
AND n_name = 'ALGERIA'
ORDER BY
	s_name;

