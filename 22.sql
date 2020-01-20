SELECT
	cntrycode,
	count(*) AS numcust,
	sum(c_acctbal) AS totacctbal
FROM
	(
		SELECT
			substring(c_phone FROM 1 FOR 2) AS cntrycode,
			c_acctbal
		FROM
			CUSTOMER
		WHERE
			substring(c_phone FROM 1 FOR 2) IN (
				'20',
				'40',
				'22',
				'30',
				'39',
				'42',
				'21'
			)
		AND c_acctbal > (
			SELECT
				avg(c_acctbal)
			FROM
				CUSTOMER
			WHERE
				c_acctbal > 0.00
			AND substring(c_phone FROM 1 FOR 2) IN (
				'20',
				'40',
				'22',
				'30',
				'39',
				'42',
				'21'
			)
		)
		AND NOT EXISTS (
			SELECT
				*
			FROM
				ORDERS
			WHERE
				o_custkey = c_custkey
		)
	) AS custsale
GROUP BY
	cntrycode
ORDER BY
	cntrycode;

