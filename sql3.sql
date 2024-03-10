--86. a.Bu ülkeler hangileri..?
SELECT DISTINCT country FROM customers
------------------------------------------------------------------------------------------------------------
--87. En Pahalı 5 ürün
SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC
LIMIT 5
------------------------------------------------------------------------------------------------------------
--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
SELECT COUNT(*) AS order_amount FROM orders
WHERE customer_id='ALFKI'
------------------------------------------------------------------------------------------------------------
--89. Ürünlerimin toplam maliyeti
SELECT SUM(unit_price*quantity*(1-discount)) FROM order_details;
------------------------------------------------------------------------------------------------------------
--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
SELECT SUM((od.unit_price * od.quantity) - (od.unit_price * od.quantity * od.discount)) AS total_revenue
FROM order_details od
------------------------------------------------------------------------------------------------------------
--91. Ortalama Ürün Fiyatım
SELECT AVG(unit_price) AS average_price FROM products
------------------------------------------------------------------------------------------------------------
--92. En Pahalı Ürünün Adı
SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC
LIMIT 1
------------------------------------------------------------------------------------------------------------
--93. En az kazandıran sipariş
SELECT order_id,SUM(unit_price*quantity*(1-discount)) AS low_earning FROM order_details
GROUP BY order_id
ORDER BY low_earning ASC 
LIMIT 1
------------------------------------------------------------------------------------------------------------
--94. Müşterilerimin içinde en uzun isimli müşteri
SELECT company_name FROM customers
ORDER BY LENGTH(company_name) DESC
LIMIT 1
------------------------------------------------------------------------------------------------------------
--95. Çalışanlarımın Ad, Soyad ve Yaşları
SELECT first_name || ' ' || last_name AS name_surname ,EXTRACT(YEAR FROM current_date)- EXTRACT(YEAR FROM birth_date) AS age
FROM employees
ORDER BY age DESC
-- extract(year from age(now(), birth_date)) as age from employees
--DATE_PART('year', CURRENT_DATE) - DATE_PART('year', birth_date)     diğer kullanım türü.
------------------------------------------------------------------------------------------------------------
--96. Hangi üründen toplam kaç adet alınmış..?
SELECT product_name,SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN products p ON od.product_id=p.product_id
GROUP BY product_name
ORDER BY total_quantity
------------------------------------------------------------------------------------------------------------
--97. Hangi siparişte toplam ne kadar kazanmışım..?
SELECT order_id,SUM(quantity*unit_price*(1*discount)) AS total_cost
FROM order_details
GROUP BY order_id
------------------------------------------------------------------------------------------------------------
--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
SELECT c.category_id,c.category_name, COUNT(p.units_in_stock) FROM products p
INNER JOIN categories c ON p.category_id=c.category_id
GROUP BY c.category_id,c.category_name
ORDER BY c.category_id
------------------------------------------------------------------------------------------------------------
--99. 1000 Adetten fazla satılan ürünler?
SELECT p.product_name,SUM(od.quantity) AS total_quantity FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
GROUP BY p.product_name
HAVING SUM(od.quantity)>1000
ORDER BY total_quantity DESC       --having group by ile birlikte kullanlır
------------------------------------------------------------------------------------------------------------
--100. Hangi Müşterilerim hiç sipariş vermemiş..?
SELECT c.company_name,o.order_id FROM orders o
RIGHT JOIN customers c ON o.customer_id=c.customer_id
WHERE order_id IS NULL
------------------------------------------------------------------------------------------------------------
--101. Hangi tedarikçi hangi ürünü sağlıyor ?

102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
103. Hangi siparişi hangi müşteri verir..?
104. Hangi çalışan, toplam kaç sipariş almış..?
105. En fazla siparişi kim almış..?
106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
109. Altında ürün bulunmayan kategoriler
110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
121. Konbu adlı üründen kaç adet satılmıştır.
122. Japonyadan kaç farklı ürün tedarik edilmektedir.
123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
124. Faks numarası olan tüm müşterileri listeleyiniz.
125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 