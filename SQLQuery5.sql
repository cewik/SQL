CREATE TABLE t_date_table (
	A_time time, 
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)
 

-- https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/

SELECT	* 
FROM	t_date_table


dddddINSERT t_date_table (A_time, A_date,A_smalldatetime,A_datetime, A_datetime2, A_datetimeoffset)
VALUES 
	('12:00:00','2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17')


-- Tablo adýndan sonraki parantez içerisinde yer alan sutuna(A_time a) veri girdik. 
INSERT t_date_table (A_time) VALUES (TIMEFROMPARTS(12,0,0, 0,0))


-- DATEFROMPARTS ile istedigimiz bi sutuna date oluþturabiliriz.
INSERT INTO t_date_table (A_date) VALUES (DATEFROMPARTS(2021,05,17))


-- Date lerin bazen formatýný degiþtirmek istersek aþagýdaki yazým þekliyle degiþtirebiliriz.
-- 6 burada kabul edilmiþ bi sýralanýþ þekli, diger dizilimleri yukarýdaki linkden bakabiliriz.
SELECT CONVERT(VARCHAR, GETDATE(), 6)


-- datetime formatýnde ekleme yapmak için
INSERT t_date_table (A_datetime) VALUES(DATETIMEFROMPARTS(2021,05,17, 20,0,0,0))


-- buda datetime a ek olarak saat diliminide eklemek için 
INSERT t_date_table (A_datetimeoffset) VALUES(DATETIMEOFFSETFROMPARTS(2021,05,17, 20,0,0,0, 2,0,0))

SELECT	* 
FROM	t_date_table


SELECT	A_date,
		-- 1. arg dateneme den hangi formatta, 2. arguman ise nereden istedigimizi söylüyoruz. 
		DATENAME(D, A_date) [DAYS]
FROM	t_date_table


SELECT	A_date,
		-- 1. arg dateneme den hangi formatta, 2. arguman ise nereden istedigimizi söylüyoruz. 
		DATENAME(DW, A_date) [DAYS]
FROM	t_date_table

SELECT	A_date,
		-- 1. arg dateneme den hangi formatta, 2. arguman ise nereden istedigimizi söylüyoruz. 
		DATENAME(D, A_date) [DAYS],
		DAY(A_date) [DAY2],
		MONTH(A_date) [MONTH],
		YEAR(A_date) [YEAR],
		A_time, 
		DATEPART(NANOSECOND, A_time) [NANOSECOND],
		DATEPART(M,A_date) [MONTH 2]
FROM	t_date_table



-- DATEDIFF tarihlerin istedigimiz türdeki (ay-ay gün-gün yýl-yýl vs) farkýný bize getirir.
	-- DATEDIFF(datepart, startdate, enddate) bize int sonuç döndürür.
		-- datepart dedigi gün mu ay mý yýl mý? hangisi bazýnda iþlem yapmak istedigimiz sorar.

SELECT	A_date,
		DATEDIFF(M, '2021-07-17','2021-05-17') ay_farki,
		DATEDIFF(YY, '2021-05-17','2028-07-17') yil_farki,
		DATEDIFF(WEEKDAY, '2021-07-17','2021-05-17') gun_farki,
		DATEDIFF(D, '2021-05-17','2021-07-17') gun_farki2,
		DATEDIFF(D, '2021-05-17',NULL) gun_farki3
		-- görüldügü üzere eger iki degerden biri null ise o zaman sonuçta null oluyor. 
FROM	t_date_table


-- Kargolama süresini, null degerlerden kargolama olmadýgýný, order status kontrolu, iptal edilenlerin masraf hesabý vs vs
SELECT	DATEDIFF(D, order_date, shipped_date) kargoya_verilme_suresi,
		order_date, shipped_date, order_status
FROM	sales.orders


-------------

-- DATEADD(DATEPART, NUMBER, DATE) the data type of the date argument
	-- bir güne bir tarihe; gün ay yýl saat saniye ekleyebilirsiniz. Þu kadar gün sonra nerede olacam gibi sorulara cevap vermemize yarar.

SELECT	order_date,
		DATEADD(DAY, 5, order_date) NEW_D_order_date,
		DATEADD(MONTH, 5, order_date) NEW_M_order_date,
		DATEADD(YEAR, 5, order_date) NEW_Y_order_date,
		DATEADD(YEAR, -5, order_date) NEW_Y_order_date
FROM	sales.orders


--EOMONTH(START_DATE,[MONTH_TO_ADD]) return type is the type of the start_date argument, or alternately, the date data type.
	-- end of month da içinde bulundugu ayýn en son gününü döndürür.

-- SUAN SUBAT AYINDAYIZ
SELECT EOMONTH(GETDATE(),2)

SELECT	order_date,
		EOMONTH(order_date) son_gün
FROM	sales.orders



-- ISDATE(EXPRESSION) --> INT(boolean) 1,0
	-- bir str ifadenin herhangi bir date formatýnda olup olmadýgýný kontrol etmek için kullanýrýz.
	-- uzun bi query yazýyorsunuz bi sutun var ve date olup olmadýgýna emin degilsiniz sorgu uzun zaman alacak belki performansý etkileyecek.
	-- burada bi hata aldýgýmzýda sistemin çalýþma maaliyeti artacak vs gibi durumlarda kontrol etmek için  
	-- validate func larýnýn amacý zaten uzun querylerde sorun yaþamamak için kullanýrýz.
	-- expression str bir deger olmalý, date tipinde degil varchar veri tipinde bir beri olmalý degilse hata verir.


-- zaten date formatýnda diye bize kýzdý
SELECT	order_date,
		ISDATE(order_date) date_formatýndami
FROM	sales.orders



/*
The SQL CAST function converts the data type of an expression to the specified data type.
For a list of the data types supported by InterSystems SQL, see Data Types. 
CAST is similar to CONVERT, with these differences: CONVERT is more flexible than CAST.
*/
SELECT	order_date,
		ISDATE(CAST(order_date AS nvarchar)) date_formatýndami
FROM	sales.orders


SELECT	
		ISDATE('2021,05,18') yanlis_formaT,
		ISDATE('2021.05.18') dogru_format,	
		ISDATE('2021-05-18') dogru_format
FROM	sales.orders





-- ************* SYSTEM DATE and TIME VALUES ***********
/*
	CURRENT_TIMESTAMP  --> Return the current system date and time without the time zone part  --> datetime
	GETDATE() --> Returns the current system date and time of the operating system on which the SQL Server is runnig. --> datetime
	GETUTCDATE()  -->  Returns a date part of a date as an integer number  --> datetime
*/


SELECT	GETDATE()

SELECT	CURRENT_TIMESTAMP

SELECT	GETUTCDATE()

--------------------------------------------------------

SELECT	*
FROM	t_date_table

-- Yeni ekledigimiz deger ile tabloya tekrardan baktýgýmýzda herbir veri türünde nasýl yer aldýgýný görebiliriz.
INSERT t_date_table
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

SELECT	*
FROM	t_date_table


-- Question - 1
-- Create a new column that contains labels of the shipping speed of products.
	-- 1- If the product has not been shipped yet, it will be markes as 'Not Shipped'
	-- 2- If the product was shipped on the day of order, it will be labeled as 'Fast'
	-- 3- If the product is shipped no later than two days after the order day, it will be labeled as 'Normal'
	-- 4- If the product was shipped three of more days after the day of order, it will be labeled as 'Slow'
-- Expected output; 


SELECT	order_date, shipped_date, 
		DATEDIFF(DAY, order_date,shipped_date) AS shipping_speed,
		CASE
			WHEN DATEDIFF(DAY, order_date,shipped_date) = 0 THEN 'Fast'
			WHEN DATEDIFF(DAY, order_date,shipped_date) IN (1,2) THEN 'Normal'
			WHEN DATEDIFF(DAY, order_date,shipped_date) > 2 THEN 'Slow'
			ELSE 'Not Shipped'
		END AS Shipping_speed

FROM	sales.orders



-- Question - 2
-- Write a query returns orders that are shipped more than two days after the ordered date.
-- Expected output; 


SELECT	*, DATEDIFF(DAY, order_date, shipped_date) shipped_date_diff
FROM	SALES.ORDERS
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2




-- Question - 3
-- Write a query that returns the number distributions of the orders in the prebious query result, accoding to the days of the week.
-- Expected output;
-- tatilmi girdi acaba araya yoksa baþka biþey mi sebeb oldu onu görmeye çalýþýyorum

SELECT	
		DATENAME(WEEKDAY, order_date), COUNT(DATENAME(WEEKDAY, order_date)) 
FROM	SALES.ORDERS
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2
GROUP BY DATENAME(WEEKDAY, order_date)


-- ikinci yol. 
-- CASE KULLANARAK UZUN UZUN VIEW KULLANARAK YAPTIGIMIZ ISLEMLERI KISA YOLDAN HALLEDEBILIYORUZ.
SELECT	SUM(CASE WHEN DATENAME(DW, order_date) = 'Monday' THEN 1 ELSE 0 END) AS MONDAY,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END) AS TUESDAY,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS WEDNESDAY,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) AS THURSDAY,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS FRIDAY,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) AS SATURDAY,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) AS SUNDAY
FROM	SALES.ORDERS
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2


-- PIVOT ILE KENDIN DENE
	-- HENUZ YAPAMADIM
SELECT * 
FROM (
		SELECT	order_id,
				DATENAME(WEEKDAY, order_date) dw
		FROM	SALES.ORDERS
		WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2

	 ) AS TABLO
PIVOT
(	
	COUNT(order_id)
	FOR	dw
	IN	(
		[Monday],
		[Tuesday],
		[Wednesday],
		[Thursday],
		[Friday],
		[Saturday],
		[Sunday])
) AS PIVOT_TABLE




-- Question - 4
-- Write a query that returns the order numbers of states by months. 
-- Expected output;

SELECT	B.state,
		YEAR(A.order_date) YEARS,
		MONTH(A.order_date) MONTHS,
		COUNT(*) num_of_orders
		-- COUNT(DISTINCT order_id)
FROM	sales.orders A, sales.customers B
WHERE	A.customer_id = B.customer_id
GROUP BY	
		B.state,YEAR(A.order_date) ,MONTH(A.order_date)
ORDER BY 
		B.state, YEARS, MONTHS




SELECT  *
FROM	(
		SELECT	B.state,
				YEAR(A.order_date) YEARS,
				MONTH(A.order_date) MONTHS,
				A.order_id
				--COUNT(*) num_of_orders
				-- COUNT(DISTINCT order_id)
		FROM	sales.orders A, sales.customers B
		WHERE	A.customer_id = B.customer_id
		) AS C

PIVOT
		(
			COUNT(order_id)
			FOR state
			IN ([CA],[NY],[TX])
		) AS X
ORDER BY 
		X.YEARS,X.MONTHS
