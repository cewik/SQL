--				 *************CTE's************* 
-- CTE oluþturduktan sonra hemen nerede kullanmak istedigimiz query yazmamýz gerekiyor. tek baþýna çalýþmaz 
-- içerideki tablodan hangi sutunlarý kullanmak istedigimizi belirtirken hepsini kullanýcaksak ekstradan
	-- yukarýda parantez içerisinde column belirtmemize gerek yok.

-- CTE ile select ile seçtigimiz query bir tablo olarak (as) kullan þeklinde yorumlayabiliriz.

-- Question - 1
-- List customers who have an order prior to the last order of a customer named Sharyn Hopkins and are residents of city of San Diego.
-- Expected output; customer_id, first_name, last_name, city, order_date

SELECT	A.customer_id, A.first_name, A.last_name, A.city, B.order_date
FROM	sales.customers AS A, sales.orders AS B
WHERE	A.customer_id = B.customer_id
		AND B.order_date < (
SELECT	TOP 1 B.order_date
FROM	sales.customers AS A, sales.orders AS B
WHERE	A.customer_id = B.customer_id
		AND A.first_name = 'Sharyn' AND A.last_name = 'Hopkins'
ORDER BY 
		B.order_date DESC)


-- WITH CTE's
WITH temp_table (order_date) AS	
	(
	-- bu queriyi temp table olarak kullan ve bana altta yazacagým statementa baglayarak 
-- temp table bilgilerini kullanrak yeni sorguyu çalýþtýr diyor 
	SELECT	TOP 1 B.order_date  -- yada MAX(B.order_date)
	FROM	sales.customers AS A, sales.orders AS B
	WHERE	A.customer_id = B.customer_id
			AND A.first_name = 'Sharyn' AND A.last_name = 'Hopkins'
	ORDER BY 
			B.order_date DESC
	)
SELECT	A.customer_id, A.first_name, A.last_name, A.city, B.order_date
FROM	sales.customers AS A, sales.orders AS B, temp_table 
WHERE	A.customer_id = B.customer_id
		AND B.order_date <  temp_table.order_date
		AND A.city = 'San Diego'



-- *************RECURSIVE***********
SELECT 0

SELECT 0 NUMBER 
UNION ALL 
SELECT 1
UNION ALL 
SELECT 2

-- 0 DAN 9 A KADAR herbir rakam bir satýrda olacak þekilde bir tablo oluþturun.
WITH T1 AS (
SELECT 0 NUMBER 
UNION ALL 
SELECT 1
UNION ALL 
SELECT 2) 
SELECT * FROM T1
----

WITH T2 AS (
SELECT 0 NUMBER 
UNION ALL 
SELECT NUMBER+1
FROM T2
WHERE NUMBER < 9) 
SELECT * FROM T2

-- Yeni bir tablo oluþturur gibi bazý degerler girip CTE oluþturabiliriz.
WITH Users AS 
(
SELECT	*
FROM	(
		VALUES
			(1,'start', CAST('01-01-20' AS date)),
			(1,'cancel', CAST('01-01-20' AS date)),
			(2,'start', CAST('01-01-20' AS date)),
			(3,'publish', CAST('01-01-20' AS date)),
			(3,'cancel', CAST('01-01-20' AS date)),
			(1,'start', CAST('01-01-20' AS date)),
			(1,'publish', CAST('01-01-20' AS date))
		) AS table_1 ([user_id], [action],[date])
)
-- Degerleri bir tablo gibi kullanýyoruz. onun haricinde aþagýda oldugu gibi tablo olarak tek baþýna çagýrýrsak hata verir.
SELECT	* FROM	Users




-- *************SET OPERATORS***********
-- Set operatörleri bir queryde bu ve bu olsun (A da olup B de olmayan yada türevleri) gibi iþlerde kullanýlýr.

-- union > birleþtirme(tekrar etmeden)  ASC OLARAK DA SIRALAMA YAPAR.
-- union all > birleþim(tekrar eden dahil)
-- intersect > kesiþim 
-- minus / except > farkýný alma

-- Set operatörler subquerilere yada cte lere göre daha hýzlý çalýþýr.
-- union küme mantýgýyla birleþim yapar lakin tekrar edenleri getirmez union all da hepsini getirir. bu yüzden union, union all a göre daha efektiftir.
-- burada önemli olan ayný sayýda sutun ve sutunlarýn ayný veri tipinde olmasý gerekir
-- Not: butun sutunlardaki degerlerden sadece bir sutundaki farklý olsa bile union bu iki degeri farklý iki deger olarak nitelendirir. ve tutar.
	-- bu durum özellikle intersect ve union için önemlidir.
-- Sutun isimlerinin ayný olmasý gerekmez. Lakin en üstteki querynin columnlarýný esas alýr
-- order by yapmak istersek en son yazdýgýmýz select statement inde yazmamýz gerekir.

-- kotu ornek 
SELECT	state
FROM	sales.stores
UNION 
SELECT	city
FROM	sales.stores

SELECT	1
FROM	sales.stores
UNION 
SELECT	city
FROM	sales.stores

-- Question - 1
-- Write a query that returns brands that have products for both 2016 and 2017.
-- Expected output; 

SELECT	A.brand_id, A.brand_name
FROM	production.brands A, production.products B 
WHERE	A.brand_id = B.brand_id
		AND B.model_year = 2016
INTERSECT
SELECT	A.brand_id, A.brand_name
FROM	production.brands A, production.products B 
WHERE	A.brand_id = B.brand_id
		AND B.model_year = 2017


SELECT	DISTINCT A.brand_id, A.brand_name
FROM	production.brands A, production.products B 
WHERE	A.brand_id = B.brand_id
		AND B.model_year IN (2016,2017)
		-- IN veya diyor o yüzden kesiþimini alamýyoruz.

-- SUBQUERY ILE
SELECT	brand_name
FROM	production.brands
WHERE	brand_id IN 
	(
	SELECT	brand_id
	FROM	production.products 
	WHERE	model_year = 2016
	INTERSECT
	SELECT	brand_id
	FROM	production.products
	WHERE	model_year = 2017
	)


-- Question - 2
-- Write a query that return customer surnames where they live in Sacramento and Monroe.
-- Expected output; 

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Sacramento'
UNION
SELECT	last_name
FROM	sales.customers
WHERE	city = 'Monroe'

-- Rasmussen tekrar ediyor.
SELECT	last_name
FROM	sales.customers
WHERE	city = 'Sacramento'
UNION ALL
SELECT	last_name
FROM	sales.customers
WHERE	city = 'Monroe'

-- iþin içine first nameleri de dahil edersek aslýnda rasmussenlerin farklý kiþiler oldugunu görüyoruz.
SELECT	first_name, last_name
FROM	sales.customers
WHERE	city = 'Sacramento'
UNION
SELECT	first_name, last_name
FROM	sales.customers
WHERE	city = 'Monroe'

-- buda alternarif WHERE ile
SELECT	first_name, last_name
FROM	sales.customers
WHERE	city = 'Sacramento'
		OR city = 'Monroe'

-- MULTIROW SUBQUERIES ile
SELECT	first_name, last_name
FROM	sales.customers
WHERE	city IN ('Sacramento', 'Monroe')




-- Question - 3
-- Write a query that returns customers who have orders for both 2016, 2017 and 2018.
-- Expected output; 
-- join ile yapmak bize büyük maliyet çýkarýr çünkü birçok tabloyu joinlemek gerekecekti

-- multirow sub. ve intersect ile çözümü, BETWEEN KULLANIMI

SELECT	first_name, last_name
FROM	sales.customers
WHERE	customer_id IN 
	(
	SELECT	customer_id
	FROM	sales.orders
	WHERE	order_date BETWEEN '2016-01-01' AND '2016-12-31'
	INTERSECT
	SELECT	customer_id
	FROM	sales.orders
	WHERE	YEAR(order_date) = 2017
	INTERSECT
	SELECT	customer_id
	FROM	sales.orders
	WHERE	YEAR(order_date) = 2018
	)

	


-- Question - 4
-- brandlerin 2016 yýlýnda üretip de 2017 yýlýnda üretmedigi productlarý getir.
-- Expected output; 
SELECT	brand_id, brand_name
FROM	production.brands
WHERE	brand_id IN (
			SELECT	brand_id
			FROM	production.products
			WHERE	model_year = 2016
			EXCEPT
			SELECT	brand_id
			FROM	production.products
			WHERE	model_year = 2017
					)

-- Question - 5
-- Write a query that returns only products ordered in 2017 (not ordered in other years)
-- Expected output; 

SELECT	* 
FROM	production.products
WHERE	product_id IN (
					SELECT	B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	 A.order_id = B.order_id
							AND YEAR(order_date) = 2017
					EXCEPT
					SELECT	B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id = B.order_id
							AND YEAR(order_date) = 2016
					EXCEPT
					SELECT	B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id = B.order_id
							AND YEAR(order_date) = 2018
					)

-- NOT BETWEEN kullanarak daha kýsa bi þekilde de halledilebiliyor.
SELECT	* 
FROM	production.products
WHERE	product_id IN (
					SELECT	B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	 A.order_id = B.order_id
							AND order_date BETWEEN '2017-01-01' AND '2017-12-31'
					EXCEPT
					SELECT	B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	 A.order_id = B.order_id
							AND order_date NOT BETWEEN '2017-01-01' AND '2017-12-31'
					)




-- Question - 6
-- Write a query that returns State where 'Trek Remedy 9.8 - 2017' product is not ordered.
-- Expected output; 

SELECT	STATE
FROM	sales.customers
EXCEPT

SELECT	D.state
FROM	sales.orders A, sales.order_items B, production.products C, sales.customers D
WHERE	A.order_id = B.order_id 
		AND B.product_id = C.product_id
		AND A.customer_id = D.customer_id
		AND C.product_name = 'Trek Remedy 9.8 - 2017'







-- *************CASE EXPRESSION***********
-- case expression is similar to the if-then-else
-- SELECT, ORDER BY, GROUP BY da kullanýlabilir
-- 1- Simple Case 
	-- sadece eþitlik varmý yokmu kontrolu yaparýz.
	/*
	SELECT	dept_name
		CASE dept_name
			WHEN 'Computer Science' THEN 'IT'
			ELSE 'Others'
		END AS category
	FROM department;
	*/

-- 2- Search Case
	-- eþittir in haricinde <, >, <=, >=, LIKE, IN vs kullanabiliriz. 
	/*
	-- case sadece bu örnekte oldugu gibi salary üzerinden tek bir sutun yerine birden fazla sutunu da kullanabiliriz. 
	SELECT	first_name, last_name
		CASE 
			WHEN salary <= 55000 THEN 'Low'
			WHEN salary > 55000  AND salary < 80000 THEN 'Middle'
			WHEN salary >= 55000 THEN 'High'
		END AS category
	FROM department;
	*/



-- Question - 1
-- Generate a new column containing what the mean of the values in the Order_Status column.
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
-- Expected output; 
-- simple case
SELECT	order_id, order_status,
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Processing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completed'
	END AS Order_Status
FROM	sales.orders;

-- search case
SELECT	order_id, order_status,
	CASE 
		WHEN order_status = 1 THEN 'Pending'
		WHEN order_status = 2 THEN 'Processing'
		WHEN order_status = 3 THEN 'Rejected'
		WHEN order_status = 4 THEN 'Completed'
	END AS Order_Status
FROM	sales.orders;



-- Question - 2 
-- Create a new column containing the labels of the customers' email service providers ('Gmail','Hotmail','Yahoo'or 'Other')
-- Expected output; 


SELECT	email,
	CASE
		WHEN  email LIKE '%gmail%'  THEN 'Gmail'	
		WHEN  email LIKE '%hotmail%'  THEN 'Hotmail'	
		WHEN  email LIKE '%yahoo%'  THEN 'Yahoo'	
		ELSE 'Other'
	END AS Email_S_Provider

FROM	sales.customers
-- contains hata veriyor. 
SELECT	*
FROM	sales.customers
WHERE	CONTAINS(email, 'gmail') 




-- order by içerisinde case expression deneme 
SELECT	*
FROM	sales.customers
ORDER BY state,
	CASE state
		WHEN  'CA'  THEN city
		WHEN  'NY'  THEN city
		WHEN  'TX'  THEN city
		ELSE city
	END;




-- Question - Genel Tekrar
-- List customers who bought both 'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order.
-- Expected output; 
SELECT *
FROM	sales.customers A,sales.orders B
WHERE	A.customer_id = B.customer_id
		AND B.order_id IN
						(

						SELECT  B.order_id
						FROM	production.products A, sales.order_items B
						WHERE	A.product_id = B.product_id
								AND A.category_id = 
								(
								SELECT	 category_id
								FROM	production.categories
								WHERE	category_name = 'Electric Bikes'
								)
						INTERSECT

						SELECT  B.order_id
						FROM	production.products A, sales.order_items B
						WHERE	A.product_id = B.product_id
								AND A.category_id = 
								(
								SELECT	 category_id
								FROM	production.categories
								WHERE	category_name = 'Comfort Bicycles'
								)
						INTERSECT

						SELECT  B.order_id
						FROM	production.products A, sales.order_items B
						WHERE	A.product_id = B.product_id
								AND A.category_id = 
								(
								SELECT	 category_id
								FROM	production.categories
								WHERE	category_name = 'Children Bicycles'
								)
								)