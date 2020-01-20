SELECT
	ps_partkey,
	sum(ps_supplycost * ps_availqty) AS
VALUE

FROM
	PARTSUPP,
	SUPPLIER,
	NATION
WHERE
	ps_suppkey = s_suppkey
AND s_nationkey = n_nationkey
AND n_name = 'MOZAMBIQUE'
GROUP BY
	ps_partkey
HAVING
	sum(ps_supplycost * ps_availqty) > (
		SELECT
			sum(ps_supplycost * ps_availqty) * 0.0001000000
		FROM
			PARTSUPP,
			SUPPLIER,
			NATION
		WHERE
			ps_suppkey = s_suppkey
		AND s_nationkey = n_nationkey
		AND n_name = 'MOZAMBIQUE'
	)
ORDER BY

VALUE
	DESC;

