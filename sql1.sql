---1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
SELECT product_name, quantity_per_unit 
FROM products;
--2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
SELECT product_id, product_name FROM products
WHERE discontinued=0;
--3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
SELECT product_id,product_name FROM products
WHERE Discontinued=1;
--4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT product_id,product_name,unit_price FROM products
WHERE unit_price<20;
--5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT product_id,product_name,unit_price 
FROM products 
WHERE unit_price BETWEEN 15 AND 25;
--6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
SELECT product_name,units_on_order,units_in_stock
FROM products
WHERE units_in_stock<units_on_order;
--7. İsmi `a` ile başlayan ürünleri listeleyeniz.
SELECT product_name
FROM products
WHERE product_name like 'a%';
--8. İsmi `i` ile biten ürünleri listeleyeniz.
SELECT product_name
FROM products 
WHERE product_name like '%i';
--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
SELECT product_name,unit_price,unit_price*1.18 AS unit_price_kdv 
FROM products;
--10. Fiyatı 30 dan büyük kaç ürün var?
SELECT COUNT(*) FROM products
WHERE unit_price>30;
--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
SELECT LOWER( product_name),unit_price FROM products
ORDER BY  unit_price DESC;
--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
SELECT first_name || last_name AS adsoyad FROM employees;
--13. Region alanı NULL olan kaç tedarikçim var?
SELECT COUNT(*) FROM suppliers
WHERE region IS NULL;
--14. a.Null olmayanlar?
SELECT COUNT(*) FROM suppliers 
WHERE region IS NOT NULL;
--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
SELECT 'TR'|| UPPER(product_name) AS new_product_name FROM products;
--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
SELECT 'TR' || product_name,unit_price AS new_product_name FROM products
WHERE unit_price<20;
--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name ,unit_price FROM products 
ORDER BY unit_price DESC;
--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC LIMIT 10;
--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products
WHERE unit_price>(SELECT AVG(unit_price) FROM products); 
--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
SELECT SUM(units_in_stock*unit_price) AS revenue FROM products 
WHERE units_in_stock>0;
--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
SELECT*FROM products
WHERE discontinued=1 AND units_in_stock>0;
--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
SELECT products.product_name,categories.category_name FROM products 
JOIN categories ON products.category_id=categories.category_id;
--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT categories.category_name ,AVG(unit_price) AS avg_price FROM products 
JOIN categories ON products.category_id=categories.category_id 
GROUP BY  category_name;
--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
SELECT products.product_name ,products.unit_price ,categories.category_name FROM products
INNER JOIN categories ON products.category_id=categories.category_id 
ORDER BY products.unit_price DESC LIMIT 1;
--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
SELECT products.product_name , categories.category_name,suppliers.company_name ,products.units_on_order FROM products 
JOIN categories ON products.category_id=categories.category_id 
JOIN suppliers ON products.supplier_id=suppliers.supplier_id 
ORDER BY units_on_order DESC LIMIT 1;
