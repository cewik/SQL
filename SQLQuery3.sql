--				***	PIVOT TABLE ***
-- satýr bazlý analiz sonucunu sutun bazýnda göstermeye yarar.

SELECT	Category, SUM(Total_Net_Price)
FROM	sales.sales_summary
GROUP BY 
		Category



SELECT * 
FROM (
-- Model_year da iþin içine katarak faklý boyutlar ekleyebiliriz
	SELECT	Category, Model_Year, Total_Net_Price
	FROM	sales.sales_summary
	 ) A
PIVOT	(		
	SUM(Total_Net_Price)
	FOR	Category
	IN	(
		[Children Bicycles],
		[Comfort Bicycles],
		[Cruisers Bicycles],
		[Cyclocross Bicycles],
		[Electric Bikes],
		[Mountain Bikes],
		[Road Bikes])
) AS PIVOT_TABLE


--				***	ORGANIZE COMPLEX QUERIES ***
--				** SUBQUERIES **
--		**SINGLE ROW SUBQUERIES **

-- QUESTION - 1
-- Bring all the personnels from the store that Kali Vargas works.
-- Expected output; staff_id, first_name, last_name, email, phone, active, store_id, manager_id

SELECT	*
FROM	sales.staffs
WHERE	store_id = (
	SELECT	store_id
	FROM	sales.staffs
	WHERE	first_name = 'Kali' AND last_name =	'Vargas'
);


-- QUESTION - 2
-- List the staff that Venita Daniel is the manager of
-- Expected Output; *

SELECT	* 
FROM	sales.staffs
WHERE	manager_id = (
	SELECT	staff_id
	FROM	sales.staffs
	WHERE	first_name = 'Venita' AND last_name = 'Daniel'
)


SELECT	A.*
FROM	sales.staffs A, sales.staffs B
WHERE	A.manager_id = B.staff_id 
AND		B.first_name = 'Venita' AND B.last_name = 'Daniel'


-- QUESTION - 3
-- Write a query tahat returns customers in the city where the 'Rowlett Bikes' store is located
-- 
-- BU AKLIMA GELDI BIRDEN DENEME YAPTIM.
SELECT	*
FROM	sales.customers
WHERE	city = (
	SELECT	city
	FROM	sales.stores
	WHERE	store_name = 'Rowlett Bikes'
)


SELECT	DISTINCT C.*
	FROM	sales.stores AS A, sales.orders AS B, sales.customers AS C
	WHERE	A.store_id = B.store_id AND B.customer_id = C.customer_id AND C.city = 'ROWLETT'
	ORDER BY 
			C.customer_id


			
-- QUESTION - 4
-- List bikes that are more expensive than the 'Trek CossRip - 2018' bike
SELECT	A.product_id, A.product_name, A.model_year,A.list_price,B.brand_name,C.category_name
FROM	production.products AS A, production.brands AS B, production.categories AS C
WHERE	A.brand_id = B.brand_id 
AND		A.category_id = C.category_id
AND		A.list_price > (
	SELECT	list_price
	FROM	production.products
	WHERE	product_name = 'Trek CrossRip+ - 2018'
	)
	-- TEKRARLAYAN SATIRLAR OLURSA DISTINCT KULLANABILIRIZ.


			
-- QUESTION - 5
-- List customers who orders previous dates than Arla Ellis
-- Expected output; first_name, last_name, order_date



SELECT	B.first_name, B.last_name, A.order_date
FROM	sales.orders AS A, sales.customers AS B
WHERE	A.order_date < (
		SELECT	A.order_date
		FROM	sales.orders AS A, sales.customers AS B
		WHERE	A.customer_id = B.customer_id AND B.first_name = 'Arla' AND B.last_name = 'Ellis'
)


--		**MULTIPLE ROW SUBQUERIES **

-- QUESTION - 6
-- List order dates for customers residing in the Holbrook city.
-- Expected output; order_date
SELECT	B.order_date
FROM	sales.customers AS A, sales.orders AS B
WHERE	A.customer_id = B.customer_id AND  A.customer_id IN (
	SELECT	customer_id
	FROM	sales.customers
	WHERE	city = 'Holbrook'
)

SELECT	order_date
FROM	sales.orders
WHERE	customer_id IN (
	SELECT	customer_id
	FROM	sales.customers
	WHERE	city = 'Holbrook'
)
-- NOT IN DIYEREK DE DEGILINI ALABILIRDIK. 



-- QUESTION - 7
-- List all customers who orders on the same dates as Arla Ellis
-- Expected output; first_name, last_name, order_date

SELECT	B.first_name, B.last_name, A.order_date
FROM	sales.orders AS A, sales.customers AS B
WHERE	A.order_date IN (
		SELECT	A.order_date
		FROM	sales.orders AS A, sales.customers AS B
		WHERE	A.customer_id = B.customer_id AND B.first_name = 'Kasha' AND B.last_name = 'Todd'
		)


-- QUESTION - 8
-- list products in categories other than Cruisers Bicycles, Mountain Bikes, or Road Bikes.
-- Expected output; product_name, list_price
SELECT	*
FROM	production.products
WHERE	category_id NOT IN (
	SELECT	category_id
	FROM	production.categories 
	WHERE	category_name = 'Mountain Bikes' OR
			category_name = 'Road Bikes' OR 
			category_name = 'Cruisers Bicycles'
)    

SELECT	*
FROM	production.products
WHERE	category_id NOT IN (
	SELECT	category_id
	FROM	production.categories 
	WHERE	category_name  IN ('Mountain Bikes', 'Road Bikes', 'Cruisers Bicycles')
)    
		AND model_year = 2016





-- QUESTION - 9
-- List bikes that cost more than electric bikes.
-- Expected output; product_name, model_year, list_price
SELECT	product_name, model_year, list_price 
FROM	production.products
WHERE	list_price > (
SELECT	MAX(A.list_price)
FROM	production.products AS A, production.categories AS B
WHERE	A.category_id = B.category_id
AND B.category_name = 'Electric Bikes' 
)

-- ALL bütün fiyatlardan daha yüksek olanlarý getir manasýnda kullanýlýyor.
SELECT	product_name, model_year, list_price 
FROM	production.products
WHERE	list_price > ALL (
SELECT	A.list_price
FROM	production.products AS A, production.categories AS B
WHERE	A.category_id = B.category_id
AND B.category_name = 'Electric Bikes' 
)

-- eger soru 
-- elektirikli bisikletlerin herhangi birinden daha pahalý olan bisikletleri listeleyin deseydim
SELECT	product_name, model_year, list_price 
FROM	production.products
WHERE	list_price > ANY (
SELECT	A.list_price
FROM	production.products AS A, production.categories AS B
WHERE	A.category_id = B.category_id
AND B.category_name = 'Electric Bikes' 
)

-- > ALL hepsinden büyük 
-- < ALL hepsinden küçük
-- > ANY en düþük olandan daha büyük olanlar
-- < ANY en büyük olandan küçükler gibi anlamlar çýkartabiliriz.






--		**CORRELATED SUBQUERIES **
-- Ana tablo ile subquery olarak kullandigimiz tablonun baglanmasi olayýna denir.

--		EXISTS / NOT EXISTS
-- EXISTS; Subquery calisirsa ana queryi calistir. NOT EXISTS; subquery calisirsa ana tabloyu calistirma demek.

-- QUESTION - 10
-- Write a query that returns state where 'Trek remedy 9.8 - 2017' product is not ordered.

--'Trek remedy 9.8 - 2017' urununun satildigi yerler 
SELECT	DISTINCT D.state
FROM	production.products AS A, sales.order_items AS B, sales.orders AS C, sales.customers AS D
WHERE	A.product_id = B.product_id AND B.order_id = C.order_id AND C.customer_id = D.customer_id
AND		A.product_name = 'Trek remedy 9.8 - 2017'


SELECT	* 
FROM	sales.customers
WHERE	state NOT IN (
			SELECT	DISTINCT D.state
			FROM	production.products AS A, sales.order_items AS B, sales.orders AS C, sales.customers AS D
			WHERE	A.product_id = B.product_id AND B.order_id = C.order_id AND C.customer_id = D.customer_id
			AND		A.product_name = 'Trek remedy 9.8 - 2017'
		)


SELECT	* 
FROM	sales.customers
WHERE	state NOT EXISTS (
			SELECT	DISTINCT D.state
			FROM	production.products AS A, sales.order_items AS B, sales.orders AS C, sales.customers AS D
			WHERE	A.product_id = B.product_id AND B.order_id = C.order_id AND C.customer_id = D.customer_id
			AND		A.product_name = 'Trek remedy 9.8 - 2017'
		)
		
-- YUKARIDAKI SORGU CALISMAZ. Cunku ana tablo ile subqueryi joinlememiz gerekecek. Bunuda
SELECT	DISTINCT state
FROM	sales.customers AS X
WHERE	NOT EXISTS (
			SELECT	DISTINCT D.state
			FROM	production.products AS A, sales.order_items AS B, sales.orders AS C, sales.customers AS D
			WHERE	A.product_id = B.product_id AND B.order_id = C.order_id AND C.customer_id = D.customer_id
			AND		A.product_name = 'Trek remedy 9.8 - 2017'
			AND X.state = D.state
		)
-- Goruldugu gibi join yaptýktan sonra exists veya not exists tek baslarýna whereden sonra kullanilir.
-- exist, eger eslesme olursa calistir, not exists; eslesme olursa calistirma anlamina gelir.


--				**VIEW**

-- sipariþ detaylarý ile ilgili bir view oluþturun birkaç sorgu içerisinde kullanýn.
SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
		C.quantity, C.list_price, C.list_price * (1 - C.discount) AS final_price
FROM	sales.customers AS A, sales.orders AS B, sales.order_items AS C, production.products AS D
WHERE	A.customer_id = B.customer_id
		AND B.order_id = C.order_id
		AND C.product_id = D.product_id

-- bu tabloyu çok sýk kullanýyorum ve sürekli çalýþtýrmam gerekiyor, tablodaki degiþiklikleri görmek için.
-- bu tarz sýrasý geldiginde yazýlan ve çalýþan sorgulara EPOCH QUERY'de denilmektedir.
-- büyük verilerle çalýþtýgýmda buradaki join iþlemlerinin sürekli yeniden çalýþmasý maliyetli bir iþlem, sisteme her çalýþtýgýnda yük bindirir.

-- biz bu epoch query i view formatýnda bakmaya çalýþalým.
CREATE VIEW SUMMARY_VIEW AS 
SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
		C.quantity, C.list_price, C.list_price * (1 - C.discount) AS final_price
FROM	sales.customers AS A, sales.orders AS B, sales.order_items AS C, production.products AS D
WHERE	A.customer_id = B.customer_id
		AND B.order_id = C.order_id
		AND C.product_id = D.product_id

SELECT	*
FROM	SUMMARY_VIEW
-- oluþturmuþ oldugumuz viewler ile istedigimiz zaman istedigimiz yerden çagýrabiliriz.
-- en büyük artýlarýndan birisi ise ana tabloda herhangi bir degiþiklik oldugunda view de otomatik olarak güncellenir.


-- view oluþturmayýp tablo create etseydik her seferinde ana tablodaki degiþiklikleri tabloya eklemek için yine maaliyetli bir ton iþ yapacaktýk.
-- geçici tablolar üzerinde çalýþmak istiyorsak en iyi çözüm view


-- viewler program kapansa bile hafýzada kalýr.
-- biz tek seferlik query çalýþtýgýnda çalýþsýn kapandýgýnda silinsin gibi birþey istiyorsak bunu da #table ile 
	-- CREATE TABLE #SUMMARY_TABLE AS  seklinde geçici bir tablo oluþturur.(HATALI SYNTAX)

SELECT	first_name, last_name, order_date, product_name, model_year,
		quantity, list_price,  final_price
INTO	#SUMMARY_TABLE
FROM	
		(
		SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
				C.quantity, C.list_price, C.list_price * (1 - C.discount) AS final_price
		FROM	sales.customers AS A, sales.orders AS B, sales.order_items AS C, production.products AS D
		WHERE	A.customer_id = B.customer_id
				AND B.order_id = C.order_id
				AND C.product_id = D.product_id
		) AS A

-- TABLO OLUÞTU AMA TEMPDB NÝN ALTINDA OLUÞTU.
-- NOT :geçici olan tablolar tempdb nin altýna kaydolur. create ettigimiz db nin altýna degil.