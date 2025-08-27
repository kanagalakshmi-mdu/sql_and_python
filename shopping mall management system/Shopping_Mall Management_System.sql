create database mall_project;
USE Mall_project;

-- Mall Table
CREATE TABLE mall (
  id INT PRIMARY KEY AUTO_INCREMENT,
  mall_code VARCHAR(10) UNIQUE NOT NULL,
  mall_name VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL
);

-- Store Table
CREATE TABLE store (
  id INT PRIMARY KEY AUTO_INCREMENT,
  store_code VARCHAR(10) UNIQUE NOT NULL,
  store_name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  m_id INT NOT NULL,
  FOREIGN KEY (m_id) REFERENCES mall(id) ON DELETE CASCADE
);

-- Customer Table
CREATE TABLE customer (
  id INT PRIMARY KEY AUTO_INCREMENT,
  cust_code VARCHAR(10) UNIQUE NOT NULL,
  cust_name VARCHAR(100) NOT NULL,
  contact_no VARCHAR(15),
  s_id INT,
  FOREIGN KEY (s_id) REFERENCES store(id) ON DELETE CASCADE
);

-- Purchase Table
CREATE TABLE purchase (
  id INT PRIMARY KEY AUTO_INCREMENT,
  cust_id INT NOT NULL,
  s_id INT NOT NULL,
  purchase_date DATE NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (cust_id) REFERENCES customer(id) ON DELETE CASCADE,
  FOREIGN KEY (s_id) REFERENCES store(id) ON DELETE CASCADE
);

-- Mall Audit Table (for Triggers)
CREATE TABLE mall_audit(
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    mall_id INT,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_data JSON,
    new_data JSON,
    action_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100) NULL
);

INSERT INTO mall (mall_code, mall_name, city) VALUES 
('MAL001', 'Phoenix Marketcity', 'Chennai'),
('MAL002', 'Express Avenue', 'Chennai'), 
('MAL003', 'Lulu Mall', 'Kochi'),
('MAL004', 'VR Mall', 'Chennai'),
('MAL005', 'Vishaldee Mall', 'Madurai'), 
('MAL006', 'Brookefields Mall', 'Coimbatore'),
('MAL007', 'Gateway Mall', 'Tiruppur'), 
('MAL008', 'Prozone Mall', 'Coimbatore');

INSERT INTO store (store_code, store_name, category, m_id) VALUES
('ST001', 'Lifestyle', 'Fashion', 1),
('ST002', 'Croma', 'Electronics', 1), 
('ST003', 'PVR Cinemas', 'Entertainment', 1),
('ST004', 'Nike', 'Sports', 2),
('ST005', 'Zara', 'Fashion', 2),
('ST006', 'McDonald’s', 'Food', 2), 
('ST007', 'Zudio', 'Fashion', 3),
('ST008', 'Samsung Store', 'Electronics', 3),
('ST009', 'KFC', 'Food', 3), 
('ST010', 'Bata', 'Footwear', 4), 
('ST011', 'Chumbak', 'Accessories', 4),
('ST012', 'Pizza Hut', 'Food', 4), 
('ST013', 'Puma', 'Sports', 5), 
('ST014', 'Poorvika', 'Electronics', 5),
('ST015', 'Nykaa', 'Beauty', 5),
('ST016', 'Metro Shoes', 'Footwear', 6), 
('ST017', 'Adidas', 'Sports', 6),
('ST018', 'Louis Philippe', 'Fashion', 6),
('ST019', 'Lenovo', 'Electronics', 7), 
('ST020', 'Nykaa Luxe', 'Beauty', 7),
('ST021', 'Toni & Guy', 'Salon', 7), 
('ST022', 'Burger King', 'Food', 8), 
('ST023', 'Trends', 'Fashion', 8),
('ST024', 'Wildcraft', 'Sports', 8),
('ST025', 'Tanishq', 'Jewelry', 1),
('ST026', 'Kalyan Jewellers', 'Jewelry', 2),
('ST027', 'Malabar Gold & Diamonds', 'Jewelry', 3),
('ST028', 'PC Jeweller', 'Jewelry', 4),
('ST029', 'Joyalukkas', 'Jewelry', 5),
('ST030', 'Skechers', 'Footwear', 4),
('ST031', 'H&M', 'Fashion', 5),
('ST032', 'Gucci', 'Fashion', 6),
('ST033', 'Adidas', 'Fashion', 6),
('ST034', 'Levis', 'Fashion', 7),
('ST035', 'Skechers', 'sports', 7),
('ST036', 'Lakmé', 'beauty', 8),
('ST037', 'L’Oreal Paris', 'Beauty', 8),
('ST038', 'Maybelline', 'Beauty', 8),
('ST039', 'MAC Cosmetics', 'Beauty', 7),
('ST040', 'Sephora', 'Beauty', 8);

INSERT INTO customer (cust_code, cust_name, contact_no, s_id) VALUES 
('C001', 'Arjun R', '9876543210', 1), 
('C002', 'Sneha P', '9876543211', 1), 
('C003', 'Manoj D', '9876543212', 2),
('C004', 'Lavanya S', '9876543213', 3),
('C005', 'Karthik N', '9876543214', 4), 
('C006', 'Divya R', '9876543215', 4),
('C007', 'Shiva M', '9876543216', 5), 
('C008', 'Nandhini A', '9876543217', 7),
('C009', 'Ravi T', '9876543218', 8),
('C010', 'Anusha K', '9876543219', 9),
('C011', 'Nandha M', '9999569817', 2), 
('C012', 'Rathika T', '9876346588', 11),
('C013', 'Babu O', '9856239995', 12), 
('C014', 'Yasin A', '9888452378', 6), 
('C015', 'Logesh G', '9899911239', 8),
('C016', 'Sathya S', '9888811119', 5),
('C017', 'Divya B', '9885672345', 10), 
('C018', 'Sam A', '9257491129', 10), 
('C019', 'Santhosh S', '9800034559', 12), 
('C020', 'Afzal A', '9845322875', 13),
('C021', 'Ganesh K', '9234455662', 12), 
('C022', 'Vicky S', '9834587759', 14),
('C023', 'Priya S', '9876512340', 14),
('C024', 'Aravind R', '9876512341', 7),
('C025', 'Meena K', '9876512342', 18),
('C026', 'Harish V', '9876512343', 13),
('C027', 'Swetha M', '9876512344', 2),
('C028', 'Kavin P', '9876512345', 35),
('C029', 'Deepa R', '9876512346', 31),
('C030', 'Suresh B', '9876512347', 40),
('C031', 'Anjali N', '9876512348', 29),
('C032', 'Vishal S', '9876512349', 10),
('C033', 'Manisha T', '9876512350', 11),
('C034', 'Arjun K', '9876512351', 12),
('C035', 'Divakar S', '9876512352', 13),
('C036', 'Krithika V', '9876512353', 14),
('C037', 'Balaji R', '9876512354', 21),
('C038', 'Koushik N', '9876512355', 15),
('C039', 'Sharmila P', '9876512356', 16),
('C040', 'Ajay G', '9876512357', 29);

INSERT INTO purchase (cust_id, s_id, purchase_date, amount) VALUES
(1, 1, '2025-07-01', 2500.00),
(2, 1, '2025-06-02', 1800.00),
(3, 2, '2025-05-21', 12000.00),
(5, 4, '2025-04-25', 1500.00),
(7, 5, '2025-08-06', 22000.00),
(9, 8, '2025-01-14', 800.00),
(10, 9, '2025-05-11', 600.00),
(13, 12, '2025-05-29', 950.00),
(15, 23, '2025-04-10', 3500.00),
(16, 27, '2025-03-24', 4200.00),
(18, 36, '2025-02-12', 1100.00),
(20, 40, '2025-06-16', 5600.00),
(21, 14, '2025-08-27', 2750.00),
(22, 35, '2025-07-15', 8900.00),
(8, 29, '2025-03-29', 1500.00),
(12, 12, '2025-06-19', 3200.00),
(14, 38, '2025-01-15', 1250.00),
(17, 10, '2025-03-26', 4800.00);

-- trigger
-- After Insert
DELIMITER $$

CREATE TRIGGER mall_after_insert
AFTER INSERT ON mall
FOR EACH ROW
BEGIN
  INSERT INTO mall_audit (mall_id, action_type, old_data, new_data, action_time, changed_by)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
    JSON_OBJECT('mall_code', NEW.mall_code, 'mall_name', NEW.mall_name, 'city', NEW.city),
    NOW(),
    USER()
  );
END$$

-- After Update
CREATE TRIGGER mall_after_update
AFTER UPDATE ON mall
FOR EACH ROW
BEGIN
  INSERT INTO mall_audit (mall_id, action_type, old_data, new_data, action_time, changed_by)
  VALUES (
    NEW.id,
    'UPDATE',
    JSON_OBJECT('mall_code', OLD.mall_code, 'mall_name', OLD.mall_name, 'city', OLD.city),
    JSON_OBJECT('mall_code', NEW.mall_code, 'mall_name', NEW.mall_name, 'city', NEW.city),
    NOW(),
    USER()
  );
END$$

-- After Delete
CREATE TRIGGER mall_after_delete
AFTER DELETE ON mall
FOR EACH ROW
BEGIN
  INSERT INTO mall_audit (mall_id, action_type, old_data, new_data, action_time, changed_by)
  VALUES (
    OLD.id,
    'DELETE',
    JSON_OBJECT('mall_code', OLD.mall_code, 'mall_name', OLD.mall_name, 'city', OLD.city),
    NULL,
    NOW(),
    USER()
  );
END$$

DELIMITER ;

-- triggersSELECT s.store_name, SUM(p.amount) AS total_sales
SELECT s.store_name, SUM(p.amount) AS total_sales
FROM purchase p
JOIN store s ON p.s_id = s.id
GROUP BY s.store_name
ORDER BY total_sales DESC;

SELECT c.cust_name, SUM(p.amount) AS total_spent
FROM purchase p
JOIN customer c ON p.cust_id = c.id
GROUP BY c.cust_name
ORDER BY total_spent DESC
LIMIT 5;

SELECT m.mall_name, SUM(p.amount) AS total_revenue
FROM purchase p
JOIN store s ON p.s_id = s.id
JOIN mall m ON s.m_id = m.id
GROUP BY m.mall_name
ORDER BY total_revenue DESC;

SELECT s.category, SUM(p.amount) AS total_sales
FROM purchase p
JOIN store s ON p.s_id = s.id
GROUP BY s.category;

SELECT id, cust_code, cust_name FROM customer;
SELECT id, store_code, store_name, m_id FROM store;
select id from store; 
SELECT * FROM Customer;
SELECT * FROM mall;
SELECT * FROM store;
select * from purchase;

SELECT cu.cust_code, cu.cust_name, cu.contact_no,
       s.store_name, s.category,
       m.mall_name, m.city
FROM customer cu
JOIN store s ON s.id = cu.s_id
JOIN mall m ON m.id = s.m_id;
-- aggregate 
SELECT COUNT(cu.id) AS total_customers, m.mall_name
FROM customer cu
JOIN store s ON s.id = cu.s_id
JOIN mall m ON m.id = s.m_id
GROUP BY m.mall_name;
-- having
SELECT COUNT(cu.id) AS total_customers, m.mall_name
FROM customer cu
JOIN store s ON s.id = cu.s_id
JOIN mall m ON m.id = s.m_id
GROUP BY m.mall_name
HAVING COUNT(cu.id) > 3;
-- union
SELECT mall_code AS code, mall_name AS name FROM mall
UNION
SELECT store_code AS code, store_name AS name FROM store WHERE category = 'Fashion';

SELECT mall_code AS code, mall_name AS name 
FROM mall
UNION ALL
SELECT store_code AS code, store_name AS name 
FROM store 
WHERE category = 'Fashion';

SELECT cust_code AS code, cust_name AS name FROM customer
UNION
SELECT store_code AS code, store_name AS name FROM store;

SELECT cu.cust_code AS code, cu.cust_name AS name 
FROM customer cu
JOIN store s ON s.id = cu.s_id
WHERE s.category = 'Fashion'
UNION
SELECT store_code AS code, store_name AS name 
FROM store 
WHERE category = 'Fashion';                              

select * from mall m inner join store s on m.id = m_id;
select * from store s right join customer c on s.id = s_id;
select * from customer c left join store s on s.id = s_id;

select mall_code,mall_name,
(case when city='chennai' then 'madras'
      when city='madurai' then 'madurai city'
      when city='Coimbatore' then 'kovai' end ) as city_name from mall ;

create view mall_store_customer_details as
(select m.mall_code, m.mall_name ,m.city,s.store_name, s.store_code, c.cust_code,c.cust_name from customer c
join store s on s.id = c.s_id
join mall m on m.id = s.m_id);


select * from mall_store_customer_details where city = 'Chennai';

-- Sub Query
select 
(select s.store_name from store s where s.id = c.s_id) as store_name, 
(select s.store_code from store s where s.id = c.s_id) as store_code, 
c.cust_code, c.cust_name 
from customer c;

INSERT INTO mall (mall_code, mall_name, city) VALUES ('MAL100', 'Test Insert Mall', 'Salem');
SELECT * FROM mall_audit;

UPDATE mall SET mall_name = 'Test Mall' WHERE mall_code = 'MAL100';
DELETE FROM store WHERE m_id = 3;
DELETE FROM mall WHERE id = 3;

update mall set city = 'Madurai' where id = 1;
update mall set mall_name = 'Lulus Mall' where id =3;
delete from mall where mall_code = 'MAL001';
update mall
set mall_name = 'VRR Mall'
where mall_code = 'MAL004';

-- Customers per Category
SELECT s.category, COUNT(c.id) AS total_customers
FROM customer c
JOIN store s ON s.id = c.s_id
GROUP BY s.category;

-- Malls with Most Stores
SELECT m.mall_name, COUNT(s.id) AS store_count
FROM mall m
JOIN store s ON m.id = s.m_id
GROUP BY m.mall_name
ORDER BY store_count DESC
LIMIT 1;

-- Customers Who Shopped in “Fashion” Stores Only
SELECT c.cust_name, s.store_name, m.mall_name
FROM customer c
JOIN store s ON c.s_id = s.id
JOIN mall m ON m.id = s.m_id
WHERE s.category = 'Fashion';

-- Stores with No Customers
SELECT s.store_name, m.mall_name
FROM store s
LEFT JOIN customer c ON s.id = c.s_id
JOIN mall m ON m.id = s.m_id
WHERE c.id IS NULL;



