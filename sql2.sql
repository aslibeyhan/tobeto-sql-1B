--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT p.product_id,p.product_name,s.company_name,s.phone ,units_in_stock
FROM products p
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id
WHERE units_in_stock=0
----------------------------------------------------------------------------------------------------
--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT e.first_name || ' '|| e.last_name AS employee_name,o.ship_address,o.order_date
FROM orders o 
INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE o.order_date BETWEEN '1998-03-01' AND '1998-03-31'
GROUP BY  employee_name, o.order_date, o.ship_address 
ORDER BY o.order_date,o.ship_address,employee_name
----------------------------------------------------------------------------------------------------
--28. 1997 yılı şubat ayında kaç siparişim var?
SELECT COUNT(*) AS "Orders in February" FROM orders 
WHERE order_date BETWEEN '1997-02-01' AND '1997-02-28'
----------------------------------------------------------------------------------------------------
--29. London şehrinden 1998 yılında kaç siparişim var?
SELECT COUNT(*) AS "Orders in London" FROM orders 
WHERE order_date BETWEEN '1998-01-01' AND '1998-12-31' AND LOWER(ship_city)='london'
----------------------------------------------------------------------------------------------------
--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
SELECT c.contact_name,c.phone, o.order_date FROM orders o
INNER JOIN customers c ON o.customer_id=c.customer_id
WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY c.contact_name,c.phone,o.order_date
ORDER BY o.order_date
----------------------------------------------------------------------------------------------------
--31. Taşıma ücreti 40 üzeri olan siparişlerim
SELECT ship_name,freight FROM orders 
WHERE freight>40 ORDER BY freight
----------------------------------------------------------------------------------------------------
--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT o.ship_city,c.contact_name,o.freight FROM orders o
INNER JOIN customers c ON  o.customer_id=c.customer_id
WHERE freight>40 ORDER BY c.contact_name,o.freight
----------------------------------------------------------------------------------------------------
--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf)
SELECT o.order_date,o.ship_city,e.first_name || ' ' || e.last_name AS name_surname FROM orders o
INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31' 
ORDER BY o.order_date
----------------------------------------------------------------------------------------------------
--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
SELECT o.order_date,c.contact_name,regexp_replace(right(c.phone,8),'[^0-9]','','g') AS phone_number 
FROM orders o
INNER JOIN customers c ON o.customer_id=c.customer_id
WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31' 
ORDER BY o.order_date
----------------------------------------------------------------------------------------------------
--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
SELECT o.order_date,c.contact_name,e.first_name || ' ' || e.last_name AS name_surname
FROM orders o
INNER JOIN customers c ON o.customer_id=c.customer_id
INNER JOIN employees e ON o.employee_id=e.employee_id
ORDER BY o.order_date,c.contact_name
----------------------------------------------------------------------------------------------------
--36. Geciken siparişlerim?
SELECT order_id,required_date,shipped_date FROM orders
WHERE required_date<shipped_date
----------------------------------------------------------------------------------------------------
--37. Geciken siparişlerimin tarihi, müşterisinin adı
SELECT o.ship_name AS "delayed_orders",o.order_date,o.required_date,o.shipped_date,c.contact_name FROM orders o
INNER JOIN customers c ON o.customer_id=c.customer_id
WHERE o.required_date<o.shipped_date 
ORDER BY o.order_date 
----------------------------------------------------------------------------------------------------
--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name,c.category_name,od.quantity,od.order_id FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
WHERE od.order_id=10248
----------------------------------------------------------------------------------------------------
--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name , s.company_name ,od.order_id FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id
WHERE od.order_id=10248
----------------------------------------------------------------------------------------------------
--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT e.employee_id,o.order_date,p.product_name,od.quantity FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN orders o ON od.order_id=o.order_id
INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE e.employee_id=3 AND o.order_date BETWEEN '1997-01-01' AND '1997-12-31'
ORDER BY o.order_date
----------------------------------------------------------------------------------------------------
-- 41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT od.order_id,SUM(od.quantity) AS total_quantity,o.employee_id,e.first_name || ' ' || e.last_name AS name_surname
FROM order_details od
INNER JOIN orders o ON od.order_id=o.order_id
INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE EXTRACT (YEAR FROM o.order_date)=1997
GROUP BY od.order_id,o.employee_id,e.first_name,e.last_name
ORDER BY total_quantity DESC
LIMIT 1
----------------------------------------------------------------------------------------------------
--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT o.employee_id,e.first_name || ' ' || e.last_name  AS name_surname,SUM(od.quantity)AS total_price
FROM order_details od
INNER JOIN orders o ON od.order_id=o.order_id
INNER JOIN employees e ON o.employee_id=e.employee_id 
WHERE EXTRACT(YEAR FROM o.order_date)=1997
GROUP BY o.employee_id ,e.first_name, e.last_name
ORDER BY total_price DESC
LIMIT 1
----------------------------------------------------------------------------------------------------
--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name,p.unit_price,c.category_name FROM products p
INNER JOIN categories c ON p.category_id=c.category_id
ORDER BY p.unit_price DESC
LIMIT 1
----------------------------------------------------------------------------------------------------
--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name || ' ' || e.last_name AS name_surname,o.order_id,o.order_date FROM orders o
INNER JOIN employees e ON o.employee_id=e.employee_id
ORDER BY o.order_date
----------------------------------------------------------------------------------------------------
--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT AVG(od.unit_price * od.quantity) AS average_price, o.order_id,o.order_date
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;
----------------------------------------------------------------------------------------------------
--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name,c.category_name,SUM(od.quantity*od.unit_price) AS total_quantity,o.order_date
FROM order_details od
INNER JOIN products p ON p.product_id=od.product_id
INNER JOIN categories c ON p.category_id=c.category_id
INNER JOIN orders o ON od.order_id=o.order_id
WHERE EXTRACT(MONTH FROM o.order_date)=1
GROUP BY p.product_name,c.category_name
----------------------------------------------------------------------------------------------------
--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT order_id, SUM(quantity) AS total_quantity FROM order_details
GROUP BY order_id HAVING SUM(quantity) > (SELECT AVG(quantity) FROM order_details);
----------------------------------------------------------------------------------------------------
--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name,c.category_name,s.company_name,MAX(od.quantity) AS total_sales_quantity
FROM products p
INNER JOIN order_details od ON p.product_id=od.product_id
INNER JOIN categories c ON p.category_id=c.category_id
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id
GROUP BY  p.product_name,c.category_name,s.company_name
ORDER BY total_sales_quantity DESC 
LIMIT 1
----------------------------------------------------------------------------------------------------
--49. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT(country)) AS country_count FROM customers
--kaç ülkeden kaç müşterim var
SELECT country, COUNT(*) AS customers_number
FROM customers
GROUP BY country;
----------------------------------------------------------------------------------------------------
--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT e.employee_id,e.first_name || ' ' || e.last_name AS name_surname ,SUM(od.quantity*od.unit_price) AS total_sales 
FROM employees e
INNER JOIN orders o ON e.employee_id=o.employee_id
INNER JOIN order_details od ON o.order_id=od.order_id
WHERE e.employee_id=3 AND o.order_date>='1998-01-01'
GROUP BY e.employee_id,e.first_name,e.last_name
----------------------------------------------------------------------------------------------------
--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name,c.category_name,od.quantity FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
WHERE od.order_id=10248
----------------------------------------------------------------------------------------------------
--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name ,s.company_name FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id
WHERE od.order_id=10248
----------------------------------------------------------------------------------------------------
--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name,od.quantity FROM order_details od
INNER JOIN orders o ON od.order_id=o.order_id
INNER JOIN employees e ON o.employee_id=e.employee_id
INNER JOIN products p ON od.product_id=p.product_id
WHERE e.employee_id=3 AND EXTRACT(YEAR FROM o.order_date)=1997
----------------------------------------------------------------------------------------------------
--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id,e.first_name ||' ' || e.last_name AS name_surname, o.order_date, SUM(od.quantity) AS total_sales
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN employees e ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, e.first_name, e.last_name, o.order_date
ORDER BY total_sales DESC LIMIT 1
----------------------------------------------------------------------------------------------------
--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS name_surname, SUM(od.quantity) AS total_sales
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN employees e ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, name_surname
ORDER BY total_sales DESC LIMIT 1
----------------------------------------------------------------------------------------------------
--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name,p.unit_price,c.category_name FROM products p
INNER JOIN categories c ON p.category_id=c.category_id
ORDER BY p.unit_price DESC
LIMIT 1
----------------------------------------------------------------------------------------------------
--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name || ' ' || e.last_name AS name_surname,o.order_id,o.order_date FROM orders o
INNER JOIN employees e ON o.employee_id=e.employee_id
ORDER BY o.order_date
----------------------------------------------------------------------------------------------------
--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT AVG(od.unit_price * od.quantity) AS average_price, o.order_id,o.order_date
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;
----------------------------------------------------------------------------------------------------
--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name,c.category_name,SUM(od.quantity*od.unit_price) AS total_quantity,o.order_date
FROM order_details od
INNER JOIN products p ON p.product_id=od.product_id
INNER JOIN categories c ON p.category_id=c.category_id
INNER JOIN orders o ON od.order_id=o.order_id
WHERE EXTRACT(MONTH FROM o.order_date)=1
GROUP BY p.product_name,c.category_name
----------------------------------------------------------------------------------------------------
--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT order_id, SUM(quantity) AS total_quantity FROM order_details
GROUP BY order_id HAVING SUM(quantity) > (SELECT AVG(quantity) FROM order_details);
----------------------------------------------------------------------------------------------------
--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name,c.category_name,s.company_name,MAX(od.quantity) AS total_sales_quantity
FROM products p
INNER JOIN order_details od ON p.product_id=od.product_id
INNER JOIN categories c ON p.category_id=c.category_id
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id
GROUP BY  p.product_name,c.category_name,s.company_name
ORDER BY total_sales_quantity DESC 
LIMIT 1
----------------------------------------------------------------------------------------------------
--62. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT(country)) AS country_count FROM customers
----------------------------------------------------------------------------------------------------
--63. Hangi ülkeden kaç müşterimiz var
SELECT country, COUNT(*) AS customers_number
FROM customers
GROUP BY country;
----------------------------------------------------------------------------------------------------
--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT e.employee_id,e.first_name || ' ' || e.last_name AS name_surname ,SUM(od.quantity*od.unit_price) AS total_sales 
FROM employees e
INNER JOIN orders o ON e.employee_id=o.employee_id
INNER JOIN order_details od ON o.order_id=od.order_id
WHERE e.employee_id=3 AND o.order_date>='1998-01-01'
GROUP BY e.employee_id,e.first_name,e.last_name
----------------------------------------------------------------------------------------------------
--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT  o.order_date,p.product_id,  SUM(od.quantity*od.unit_price) AS total_revenue FROM products p
INNER JOIN order_details od ON od.product_id = p.product_id
INNER JOIN orders o ON o.order_id = od.order_id
WHERE p.product_id=10 AND  o.order_date > '1998-02-06'
GROUP BY o.order_date,p.product_id
ORDER BY total_revenue DESC
----------------------------------------------------------------------------------------------------
--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
SELECT e.first_name || ' ' || e.last_name AS name_surname,COUNT(o.order_id) AS total_order 
FROM employees e
LEFT JOIN orders o ON e.employee_id=o.employee_id
GROUP BY e.first_name,e.last_name
ORDER BY total_order DESC
----------------------------------------------------------------------------------------------------
--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT c.company_name,COUNT(o.order_id)AS total_order
FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.company_name
ORDER BY total_order DESC
--select c.company_name from customers c
--left join orders o on c.customer_id = o.customer_id
--where o.customer_id is null;
----------------------------------------------------------------------------------------------------
--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT company_name,contact_name,address,city,country FROM customers c
WHERE c.country='Brazil'
----------------------------------------------------------------------------------------------------
--69. Brezilya’da olmayan müşteriler
SELECT company_name,country FROM customers
WHERE country !='Brazil'
ORDER BY country;
----------------------------------------------------------------------------------------------------
--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT company_name,country FROM customers
WHERE country IN ('Spain','France','Germany')
ORDER BY country
----------------------------------------------------------------------------------------------------
--71. Faks numarasını bilmediğim müşteriler
SELECT company_name,fax FROM customers
WHERE fax IS null
----------------------------------------------------------------------------------------------------
--72. Londra’da ya da Paris’de bulunan müşterilerim
SELECT company_name,city FROM customers
WHERE city IN('London','Paris')
ORDER BY city
----------------------------------------------------------------------------------------------------
--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
SELECT company_name,city,contact_title FROM customers
WHERE city='México D.F.' AND contact_title='Owner'
ORDER BY company_name
----------------------------------------------------------------------------------------------------
--74. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name,unit_price FROM products
WHERE  product_name LIKE 'C%' OR product_name LIKE 'c%'
ORDER BY product_name
----------------------------------------------------------------------------------------------------
--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name,last_name,birth_date FROM employees
WHERE first_name LIKE 'A%' OR first_name LIKE 'a%'
----------------------------------------------------------------------------------------------------
--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name FROM customers
WHERE lower(company_name) LIKE '%restaurant%'
----------------------------------------------------------------------------------------------------
--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name,unit_price FROM products
WHERE unit_price BETWEEN 50 AND 100
ORDER BY unit_price
----------------------------------------------------------------------------------------------------
--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id,order_date FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31'
ORDER BY order_date
----------------------------------------------------------------------------------------------------
--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT company_name,country FROM customers
WHERE country IN('Spain','France','Germany')
ORDER BY country
----------------------------------------------------------------------------------------------------
--80. Faks numarasını bilmediğim müşteriler
SELECT company_name,fax FROM customers
WHERE fax IS NULL;
----------------------------------------------------------------------------------------------------
--81. Müşterilerimi ülkeye göre sıralıyorum:
SELECT company_name,country FROM customers
ORDER BY country
----------------------------------------------------------------------------------------------------
--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC
----------------------------------------------------------------------------------------------------
--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC ,units_in_stock 
----------------------------------------------------------------------------------------------------
--84. 1 Numaralı kategoride kaç ürün vardır..?
SELECT COUNT(*) AS product_count FROM products
WHERE category_id=1
----------------------------------------------------------------------------------------------------
--85. Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT ship_country) AS how_country FROM orders
