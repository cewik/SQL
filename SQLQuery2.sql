-- CROSS JOIN 
--Hangi markada hangi kategoride kaçar ürün oldugu bilgisine ihtiyaç duyuluyor.
-- Ürün sayýsý hesaplamadan sadece marka * kategori ihtimallerinin hepsini içeren bir tablo oluþturun.
-- Çikan sonucu daha kolay yorumlamak için brand_id ve category_id alanrýna göre sýralayýn


SELECT *
FROM production.brands

SELECT *
FROM production.categories


SELECT *
FROM production.brands A
CROSS JOIN production.categories B
ORDER BY A.brand_id,B.category_id

-----//////////////------

-- SELF JOIN
-- inner join gibi tabloyu kendi kendine join etmeye yarar.

-- Write a query that returns the staffs with their managers.
-- Expected columns; staff first name and last name, manager name

SELECT * FROM sales.staffs


-- Managerler ayný zamanda bir staff  yani manager id ile 
SELECT A.first_name, A.last_name, A.manager_id
FROM sales.staffs A, sales.staffs B
WHERE A.manager_id = B.staff_id
ORDER BY B.manager_id 






-- Write a query that checks if any product id is repeated in more than one row in the products table.
-- Expected output; product_id, num_of_rows
SELECT TOP 20 * FROM production.products
                     ---- 

-- BENÝM ÇÖZÜMÜM (SORUYU DOGRU OKU YANLIS COZUM )
SELECT	product_id, COUNT(product_id) AS num_of_rows
FROM	production.stocks
GROUP BY product_id
ORDER BY product_id 

-- ISTENEN COZUM
SELECT	product_id, COUNT(*) AS num_of_rows
FROM	production.products
GROUP BY
		product_id
HAVING 
		COUNT(*) > 1

--ISTENEN COZUMUN PRODUCT NAME E GORE YAPILISI
SELECT	product_name, COUNT(*) AS num_of_rows
FROM	production.products
GROUP BY
		product_name
HAVING 
		COUNT(*) > 1

-- KOD CALISMAZ CUNKU 
		-- SELECT DE YAZDIKLARIMIZIN GROUP BY DA DA YAZMAMIZ GEREKIYOR 
SELECT	product_id, product_name, COUNT(*) AS num_of_rows
FROM	production.products
GROUP BY
		product_name
HAVING 
		COUNT(*) > 1

SELECT	product_id, product_name, COUNT(*) AS num_of_rows
FROM	production.products
GROUP BY
		product_id, product_name
HAVING 
		COUNT(*) > 1


----////// ESCAPE CHARACTER ///////--------
SELECT *
FROM   production.products
WHERE product_name = 'Ritchey Timberwolf Frameset - 2016'

-- '' DEFA KULLANILMASI
SELECT *
FROM   production.products
WHERE product_name = 'Electra Girl''s Hawaii 1 (16-inch) - 2015/2016'



-- COUNT(*) >> ROWLARI SAY



-- Write a query that returns category ids with a maximum list price above 
	-- 4000 or a minimum list price below 500.
-- Expected output; category_id, max_price and min_price
			
			-- Before the solution, you should analyze the problems.
SELECT *
FROM   production.products

ORDER BY category_id

------------- BU HATALI COZUM CUNKU HAVING YERINE ANA TABLODA OYNAMA YAPTIM
SELECT category_id, MAX(list_price) AS max_price, MIN(list_price) AS min_price
FROM   production.products
WHERE list_price > 4000  or list_price < 500 
GROUP BY category_id
------------


SELECT	 category_id, MAX(list_price) AS max_price, MIN(list_price) AS min_price
FROM	 production.products
GROUP BY category_id

SELECT	 category_id, MAX(list_price) AS max_price, MIN(list_price) AS min_price
FROM	 production.products
GROUP BY category_id
HAVING MAX(list_price) > 4000  or MIN(list_price) < 500 

SELECT	 category_id, MAX(list_price) AS max_price, MIN(list_price) AS min_price
FROM	 production.products
GROUP BY category_id
HAVING MAX(list_price) > 4000  AND MIN(list_price) < 500



-- Find the average product prices of the brands.
-- As a result of the query, the average prices should be displayed in descending order.
-- Expected output; brand_name and avg_list_price

SELECT	B.brand_name, AVG(A.list_price) AS avg_list_price
FROM	production.products AS A, production.brands AS B
WHERE	A.brand_id = B.brand_id
GROUP BY 
		B.brand_name
ORDER BY 
		AVG(A.list_price) DESC
		-- 2 (COLUMN SAYISINI DA BELÝRTEBÝLÝRÝZ) DESC




-- Write a query that returns Brands with an average product price of more than 1000.
-- Expected output; brand_name and avg_list_price
SELECT	A.brand_name, AVG(B.list_price) AS avg_list_price
FROM	production.brands AS A, production.products AS B
WHERE	A.brand_id = B.brand_id
GROUP BY
		A.brand_name
HAVING
		AVG(B.list_price) > 1000
ORDER BY 
		2 



-- Write a query that returns the net price paid by the customer for each order.
--(Don't neglect discounts and quantities)
-- Expected output; order_id and net_price

SELECT	order_id, SUM(quantity * (list_price - discount * list_price)) AS net_price
FROM	sales.order_items
GROUP BY 
		 order_id




--------------------------------------------------------------
---///////////////////////// SELECT INTO KAVRAMI \\\\\\\\\\\\
SELECT	
		C.brand_name AS Brand, D.category_name AS Category,
		B.model_year AS Model_Year,  ROUND(SUM(A.quantity * (A.list_price - A.discount * A.list_price)), 0) AS Total_Net_Price
INTO	sales.sales_summary
FROM	
		sales.order_items AS A,
		production.products AS B,
		production.brands AS C,
		production.categories AS D
WHERE	
		A.product_id = B.product_id 
		AND B.brand_id = C.brand_id 
		AND B.category_id = D.category_id
GROUP BY 
		C.brand_name, D.category_name, B.model_year
ORDER BY
		C.brand_name, D.category_name, B.model_year
		--- 1,2,3
	

	
SELECT * FROM sales.sales_summary

-- GROUPING SETS

--1. Toptal sales miktarini hesaplayiniz.
SELECT	SUM(Total_Net_Price) AS Total_Price
FROM	sales.sales_summary

--2. Markalarýn toplam sales miktarini hesaplayiniz.
SELECT	Brand, SUM(Total_Net_Price)
FROM	sales.sales_summary
GROUP BY 
		Brand

--3. Category bazinda yapilan toplam sales miktarini hesaplayiniz.
SELECT	Category, SUM(Total_Net_Price)
FROM	sales.sales_summary
GROUP BY 
		Category

--4. Marka ve category kirilimlarindaki toplam sales miktarini hesaplayiniz.
SELECT	Brand, Category, SUM(Total_Net_Price)
FROM	sales.sales_summary
GROUP BY 
		Brand, Category

-- NOT: Yukarýda yaptýgýmýz 4 farklý sorguyu tek bir sorguda yazmak için GROUPING SETS kullanýrýz.
SELECT	Brand, Category, SUM(Total_Net_Price)
FROM	sales.sales_summary
GROUP BY 
	GROUPING SETS(
		(),
		(Brand),
		(Category),
		(Brand, Category)
	)
ORDER BY 
		Brand, Category
		
--ROLLUP ***********
SELECT	Brand, Category, SUM(Total_Net_Price)
FROM	sales.sales_summary
GROUP BY 
	ROLLUP(Brand, Category)
ORDER BY 
		1,2

--CUBE ***********
SELECT	Brand, Category, SUM(Total_Net_Price)
FROM	sales.sales_summary
GROUP BY 
	CUBE(Brand, Category)
ORDER BY 
		1,2