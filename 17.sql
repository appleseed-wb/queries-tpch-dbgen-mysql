SELECT
	sum(l_extendedprice) / 7.0 AS avg_yearly
FROM
	LINEITEM,
	PART
WHERE
	p_partkey = l_partkey
AND p_brand = 'Brand#44'
AND p_container = 'WRAP PKG'
AND l_quantity < (
	SELECT
		0.2 * avg(l_quantity)
	FROM
		LINEITEM
	WHERE
		l_partkey = p_partkey
);

