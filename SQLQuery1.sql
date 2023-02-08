SELECT A.product_id, A.product_name, B.category_id, B.category_name
FROM production.products AS A
INNER JOIN production.categories AS B
ON A.category_id = B.category_id




 -- list employees of stores with their store information
 -- select employee name, surname, store names
SELECT TOP 20 A.first_name, A.last_name, B.store_name
FROM sales.staffs AS A
INNER JOIN sales.stores AS B 
ON A.store_id = B.store_id 

SELECT TOP 20 A.first_name, A.last_name, B.store_name
FROM sales.staffs A, sales.stores B 
WHERE A.store_id = B.store_id



-- LEFT JOIN

-- List products with category names 
-- Select product ID, product name, category ID and category names 
-- (Use left join)

SELECT TOP 20 A.product_id, A.product_name, A.category_id, B.category_name
FROM  production.products A
LEFT JOIN production.categories B
ON A.category_id = B.category_id

SELECT TOP 20 A.product_id, A.product_name, A.category_id, B.category_name
FROM production.products A, production.categories B
WHERE A.category_id = B.category_id 

-- NOT
-- bir tabloda pk varkend digerinde yoksa inner join de getirmezken left joinde null olarak getirecekti.
-- inner = kesiþim, left = left üzerinden birleþim.



-- Report the stock status of the products that product id greater than 310 in the stores.
-- Expected columns; product id, product name, store id, quantity

SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM production.products A
LEFT JOIN production.stocks B
ON A.product_id = B.product_id
WHERE A.product_id > 310 

-- inner joinle null larý göremeyecektim.
SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM production.products A
INNER JOIN production.stocks B
ON A.product_id = B.product_id
WHERE A.product_id > 310




-- RIGHT JOIN 
-- Report the stock status of the products that product id greater than 310 in the stores.
-- Expected columns; product id, product name, store id, quantity

SELECT *
FROM production.stocks A
RIGHT JOIN production.products B
ON A.product_id = B.product_id
WHERE B.product_id > 310 



-- Report the orders information made by all staffs.(STAFF TABLOSU ANA TABLOM)
-- Expcted columns staff id, first name, last name, all the information about orders

-- staff tablosunda kaç staff var > 10 tane
SELECT * FROM sales.staffs
-- orders tablosunda kaç adet unique satýcý idsi var > 6 adet 
SELECT COUNT(DISTINCT staff_id) FROM sales.orders
-- orders tablosu bütün staff id lerini kapsamýyor.

-- BU store id üzerinden birleþtirildi ama biz stafflarýn üzerinden istiyoruz
SELECT A.staff_id, A.first_name, A.last_name,  B.*
FROM sales.staffs A
LEFT JOIN sales.orders B
ON A.store_id = B.store_id

---
-- HÝÇ SÝPARÝÞ ALMAMIÞ STAFFLAR BELLÝ OLDU. 
SELECT *
FROM sales.orders A
RIGHT JOIN sales.staffs B
ON A.staff_id = B.staff_id


---
SELECT COUNT(DISTINCT A.staff_id)
FROM sales.staffs A
LEFT JOIN sales.orders B
ON A.store_id = B.store_id


SELECT COUNT(DISTINCT B.staff_id)
FROM sales.staffs A
RIGHT JOIN sales.orders B
ON A.store_id = B.store_id
---




-- Write a query that returns stock and order information together for all product.
-- Expected columns; product id, store id, order id, list price
SELECT *
FROM sales.order_items A
FULL OUTER JOIN production.stocks B
ON A.product_id = B.product_id
ORDER BY A.product_id 



SELECT	*
FROM	
		(SELECT	TOP 1 product_id, product_name , LEN(product_name) AS lenght_names
		FROM	production.products
		ORDER BY	
				LEN(product_name) ) AS A
FULL OUTER JOIN 
		() AS B
ON  A.product_id = B.product_id

select oldest.<some_field> as old, 
       newest.<some_field> as new  
from
  (select <some_column> from <some_table>
    order by <some_field> limit 1)        as oldest,
  (select <some_column> from <some_table> 
    order by <some_field> desc limit 1)   as newest
;

		(SELECT <some columns>
FROM mytable
<maybe some joins here>
WHERE <various conditions>
ORDER BY date DESC
LIMIT 1)

UNION ALL

(SELECT <some columns>
FROM mytable
<maybe some joins here>
WHERE <various conditions>
ORDER BY date ASC    
LIMIT 1)


SELECT *, A.lenght_names
FROM
	(
	SELECT	*, LEN(product_name) AS lenght_names
			FROM	production.products
	
	) AS A,

	(
	SELECT	*, LEN(product_name) AS lenght_names
			FROM	production.products

	
	) AS B
WHERE A.product_id = B.product_id
ORDER BY A.lenght_names


SELECT  TOP 1  LEN(product_name) AS lenght_names, *
			FROM	production.products
			ORDER BY LEN(product_name)
	
SELECT	product_name
FROM	production.products
WHERE	LEN(product_name) < ALL (
SELECT	LEN(product_name)
FROM	production.products ORDER BY LEN(product_name) AS A, production.categories AS B
WHERE	A.category_id = B.category_id
AND B.category_name = 'Electric Bikes' 
)

select city, length(min(city)) from station group by city order by length(min(city)),city limit 1;
select city, length(min(city)) from station group by city order by length(min(city)) desc,city  limit 1;


SELECT	TOP 1 product_name , LEN(product_name) AS lenght_names 
		FROM	production.products
		GROUP BY product_name
		ORDER BY	
				LEN(product_name)

SELECT	TOP 1  product_name, LEN(product_name) AS lenght_names
				FROM	production.products
				GROUP BY product_name
				ORDER BY	
						LEN(product_name) DESC


SELECT *
FROM production.products
WHERE LEFT(product_name,1) IN ('A','E','I','O','U') AND RIGHT(product_name,1) IN ('A','E','I','O','U')


SELECT *
FROM production.products
WHERE LEFT(product_name,1)  NOT IN ('A','E','I','O','U')