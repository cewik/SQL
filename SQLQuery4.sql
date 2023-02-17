--				 *************CTE's************* 
-- CTE olu�turduktan sonra hemen nerede kullanmak istedigimiz query yazmam�z gerekiyor. tek ba��na �al��maz 
-- i�erideki tablodan hangi sutunlar� kullanmak istedigimizi belirtirken hepsini kullan�caksak ekstradan
	-- yukar�da parantez i�erisinde column belirtmemize gerek yok.

-- CTE ile select ile se�tigimiz query bir tablo olarak (as) kullan �eklinde yorumlayabiliriz.

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
	-- bu queriyi temp table olarak kullan ve bana altta yazacag�m statementa baglayarak 
-- temp table bilgilerini kullanrak yeni sorguyu �al��t�r diyor 
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

-- 0 DAN 9 A KADAR herbir rakam bir sat�rda olacak �ekilde bir tablo olu�turun.
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

-- Yeni bir tablo olu�turur gibi baz� degerler girip CTE olu�turabiliriz.
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
-- Degerleri bir tablo gibi kullan�yoruz. onun haricinde a�ag�da oldugu gibi tablo olarak tek ba��na �ag�r�rsak hata verir.
SELECT	* FROM	Users




-- *************SET OPERATORS***********
-- Set operat�rleri bir queryde bu ve bu olsun (A da olup B de olmayan yada t�revleri) gibi i�lerde kullan�l�r.

-- union > birle�tirme(tekrar etmeden)  ASC OLARAK DA SIRALAMA YAPAR.
-- union all > birle�im(tekrar eden dahil)
-- intersect > kesi�im 
-- minus / except > fark�n� alma

-- Set operat�rler subquerilere yada cte lere g�re daha h�zl� �al���r.
-- union k�me mant�g�yla birle�im yapar lakin tekrar edenleri getirmez union all da hepsini getirir. bu y�zden union, union all a g�re daha efektiftir.
-- burada �nemli olan ayn� say�da sutun ve sutunlar�n ayn� veri tipinde olmas� gerekir
-- Not: butun sutunlardaki degerlerden sadece bir sutundaki farkl� olsa bile union bu iki degeri farkl� iki deger olarak nitelendirir. ve tutar.
	-- bu durum �zellikle intersect ve union i�in �nemlidir.
-- Sutun isimlerinin ayn� olmas� gerekmez. Lakin en �stteki querynin columnlar�n� esas al�r
-- order by yapmak istersek en son yazd�g�m�z select statement inde yazmam�z gerekir.

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
		-- IN veya diyor o y�zden kesi�imini alam�yoruz.

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

-- i�in i�ine first nameleri de dahil edersek asl�nda rasmussenlerin farkl� ki�iler oldugunu g�r�yoruz.
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
-- join ile yapmak bize b�y�k maliyet ��kar�r ��nk� bir�ok tabloyu joinlemek gerekecekti

-- multirow sub. ve intersect ile ��z�m�, BETWEEN KULLANIMI

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
-- brandlerin 2016 y�l�nda �retip de 2017 y�l�nda �retmedigi productlar� getir.
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

-- NOT BETWEEN kullanarak daha k�sa bi �ekilde de halledilebiliyor.
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
-- SELECT, ORDER BY, GROUP BY da kullan�labilir
-- 1- Simple Case 
	-- sadece e�itlik varm� yokmu kontrolu yapar�z.
	/*
	SELECT	dept_name
		CASE dept_name
			WHEN 'Computer Science' THEN 'IT'
			ELSE 'Others'
		END AS category
	FROM department;
	*/

-- 2- Search Case
	-- e�ittir in haricinde <, >, <=, >=, LIKE, IN vs kullanabiliriz. 
	/*
	-- case sadece bu �rnekte oldugu gibi salary �zerinden tek bir sutun yerine birden fazla sutunu da kullanabiliriz. 
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




-- order by i�erisinde case expression deneme 
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