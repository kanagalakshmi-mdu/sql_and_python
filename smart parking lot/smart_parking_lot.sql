-- Create Database
DROP DATABASE IF EXISTS smart_parking_lot;
CREATE DATABASE smart_parking_lot;
USE smart_parking_lot;

-- Customers (Vehicle Owners)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(50) NOT NULL,
    phone       VARCHAR(20),
    city        VARCHAR(50)
);

-- Vehicles
CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    plate_no    VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type ENUM('car', 'bike', 'truck') NOT NULL,
    color       VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Parking Spots
CREATE TABLE parking_spots (
    spot_id     INT PRIMARY KEY,
    spot_type   ENUM('car', 'bike', 'truck') NOT NULL,
    is_occupied BOOLEAN DEFAULT FALSE
);

-- Parking Records
CREATE TABLE parking_records (
    record_id   INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id  INT,
    spot_id     INT,
    entry_time  DATETIME NOT NULL,
    exit_time   DATETIME,
    fee         DECIMAL(10,2),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (spot_id) REFERENCES parking_spots(spot_id),
    UNIQUE(vehicle_id, spot_id)  -- prevent same vehicle in same spot simultaneously
);

-- Parking Fees
CREATE TABLE parking_fees (
    vehicle_type ENUM('car','bike','truck') PRIMARY KEY,
    hourly_rate DECIMAL(10,2) NOT NULL
);

-- Audit Log
CREATE TABLE parking_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    record_id INT,
    action_type ENUM('INSERT','UPDATE','DELETE'),
    old_data JSON,
    new_data JSON,
    action_time DATETIME DEFAULT NOW(),
    changed_by VARCHAR(100)
);

-- TRIGGERS
-- Drop old triggers if exist
DROP TRIGGER IF EXISTS mark_spot_occupied;
DROP TRIGGER IF EXISTS mark_spot_free;
DROP TRIGGER IF EXISTS audit_on_delete;
DROP TRIGGER IF EXISTS calculate_fee_on_exit;

-- Mark spot occupied & audit after insert
DELIMITER $$
CREATE TRIGGER mark_spot_occupied
AFTER INSERT ON parking_records
FOR EACH ROW
BEGIN
    UPDATE parking_spots
    SET is_occupied = TRUE
    WHERE spot_id = NEW.spot_id;

    INSERT INTO parking_audit(record_id, action_type, old_data, new_data, changed_by)
    VALUES (
        NEW.record_id,
        'INSERT',
        NULL,
        JSON_OBJECT(
            'vehicle_id', NEW.vehicle_id,
            'spot_id', NEW.spot_id,
            'entry_time', NEW.entry_time
        ),
        USER()
    );
END$$

-- Mark spot free & audit after update
CREATE TRIGGER mark_spot_free
AFTER UPDATE ON parking_records
FOR EACH ROW
BEGIN
    IF NEW.exit_time IS NOT NULL AND OLD.exit_time IS NULL THEN
        UPDATE parking_spots
        SET is_occupied = FALSE
        WHERE spot_id = NEW.spot_id;
    END IF;

    INSERT INTO parking_audit(record_id, action_type, old_data, new_data, changed_by)
    VALUES (
        NEW.record_id,
        'UPDATE',
        JSON_OBJECT(
            'vehicle_id', OLD.vehicle_id,
            'spot_id', OLD.spot_id,
            'entry_time', OLD.entry_time,
            'exit_time', IFNULL(OLD.exit_time,''),
            'fee', IFNULL(OLD.fee,0)
        ),
        JSON_OBJECT(
            'vehicle_id', NEW.vehicle_id,
            'spot_id', NEW.spot_id,
            'entry_time', NEW.entry_time,
            'exit_time', IFNULL(NEW.exit_time,''),
            'fee', IFNULL(NEW.fee,0)
        ),
        USER()
    );
END$$

-- Audit on delete
CREATE TRIGGER audit_on_delete
AFTER DELETE ON parking_records
FOR EACH ROW
BEGIN
    INSERT INTO parking_audit(record_id, action_type, old_data, new_data, changed_by)
    VALUES (
        OLD.record_id,
        'DELETE',
        JSON_OBJECT(
            'vehicle_id', OLD.vehicle_id,
            'spot_id', OLD.spot_id,
            'entry_time', OLD.entry_time,
            'exit_time', IFNULL(OLD.exit_time,''),
            'fee', IFNULL(OLD.fee,0)
        ),
        NULL,
        USER()
    );
END$$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE calculate_fee(IN rec_id INT)
BEGIN
    UPDATE parking_records pr
    JOIN vehicles v ON pr.vehicle_id = v.vehicle_id
    JOIN parking_fees pf ON v.vehicle_type = pf.vehicle_type
    SET pr.fee = TIMESTAMPDIFF(HOUR, pr.entry_time, pr.exit_time) * pf.hourly_rate
    WHERE pr.record_id = rec_id
      AND pr.exit_time IS NOT NULL;
END$$
DELIMITER ;

-- VIEWS
CREATE OR REPLACE VIEW current_occupancy AS
SELECT  
    p.spot_id,  
    p.spot_type,  
    v.plate_no,
    v.vehicle_type,
    pr.entry_time
FROM parking_spots p
LEFT JOIN parking_records pr  
    ON p.spot_id = pr.spot_id AND pr.exit_time IS NULL
LEFT JOIN vehicles v  
    ON pr.vehicle_id = v.vehicle_id;
-- Customers
INSERT INTO customers (name, phone, city) VALUES
('Amit Sharma', '9876543210', 'Delhi'),
('Priya Verma', '9123456780', 'Mumbai'),
('John Doe', '9998887777', 'Bangalore'),
('Vikram',  '9876543210', 'Chennai'),
('Lakshmi', '9123456789', 'Bangalore'),
('Ravi',    '9012345678', 'Hyderabad'),
('Deepak',  '9067921678', 'Madurai'),
('Rathika', '8845397652', 'Tirpur'),
('Rithika', '9999547281', 'Madurai'),
('Susy',    '8873645241', 'Chennai'),
('Dhanush', '9999655678', 'Tirpur'),
('Vicky',   '9988554121', 'Ooty'),
('Vignesh', '9966324198', 'Sivagangai'),
('Sweety',  '9173562031', 'Thiruchi'),
('Dhibagar','9886556781', 'Ariyalur'),
('Sunitha', '8881293610', 'Madurai'),
('Arun',    '9428437678', 'Viruthunagar'),
('Arjun',   '8889992277', 'Madurai'),
('Anurag',  '9111004522', 'Tirpur'),
('Sarath',  '9988882192', 'Chennai'),
( 'sugi', '9002166601', 'Chennai'),
('viji', '9829993661', 'Bangalore'),
('Karthik', '9066622422', 'Coimbatore'),
('Meena',   '9999481037', 'Chennai'),
('Rajesh',  '9833392461', 'Bangalore'),
('Shalini', '9111690336', 'Hyderabad'),
('Suresh',  '8883021946', 'Madurai'),
('Divya',   '8100432772', 'Trichy'),
('Prakash', '8821823001', 'Salem'),
('Anitha',  '9915389275', 'Kochi'),
('Mohan',   '9001218846', 'Chennai'),
('Geetha',  '9994357822', 'Erode'),
('Ramesh',  '9578387229', 'Bangalore'),
('Kavitha', '9772906438', 'Madurai'),
('Balaji',  '9888210564', 'Chennai');


-- Vehicles
INSERT INTO vehicles (customer_id, plate_no, vehicle_type, color) VALUES
(1,'DL01AB1234', 'car', 'Red'),
(2,'MH12XY9876', 'bike', 'Gray'),
(3,'KA09TR4321', 'truck', 'Blue'),
(4,'KA01AB1234', 'car',   'Blue'),
(5,'KA02XY9876', 'bike',  'Red'),
(6,'KA03CD4567', 'truck', 'White'),
(7,'KA04EF7654', 'car',   'Black'),
(8,'KA05GH3456', 'bike',  'Green'),
(9,'KA06IJ8765', 'car',   'Grey'),
(10,'KA07KL1235', 'truck', 'Blue'),
(11,'KA08MN6543', 'car',   'White'),
(12,'KA09OP2345', 'bike',  'Black'),
(13,'KA10QR9876', 'truck', 'Yellow'),
(14,'KA32QK3647', 'car',   'Silver'),
(15, 'KA11ST5678', 'car',   'Maroon'),
(16, 'KA12UV3456', 'bike',  'Blue'),
(17, 'KA13WX9876', 'truck', 'Green'),
(18, 'KA14YZ6543', 'car',   'White'),
(19, 'KA15AB8765', 'bike',  'Orange'),
(20, 'KA16CD2345', 'truck', 'Red'),
(21, 'KA17EF7654', 'car',   'Brown'),
(22, 'KA18GH5432', 'bike',  'Silver'),
(23, 'KA19IJ3210', 'car',   'Black'),
(24, 'KA20KL0987', 'truck', 'Blue'),
(25, 'KA21MN7654', 'car',   'White'),
(26, 'KA22OP4321', 'bike',  'Green'),
(27, 'KA23QR8765', 'truck', 'Yellow'),
(28, 'KA24ST2345', 'car',   'Grey'),
(29, 'KA25UV5432', 'bike',  'Blue'),
(30, 'KA26WX7654', 'truck', 'Black'),
(31, 'KA27YZ8765', 'car',   'Silver'),
(32, 'KA28AB2345', 'bike',  'White'),
(33, 'KA29CD9876', 'truck', 'Orange'),
(34, 'KA30EF5432', 'car',   'Red');


-- Parking Spots
INSERT INTO parking_spots (spot_id, spot_type, is_occupied) VALUES
(1, 'car', FALSE),
(2, 'bike', FALSE),
(3, 'truck', FALSE),
(4, 'car', FALSE),
(5, 'bike', FALSE),
(6,  'car',   TRUE),
(7,  'bike',  TRUE),
(8,  'car',   FALSE),
(9,  'truck', TRUE),
(10,  'bike',  FALSE),
(11,  'car',   TRUE),
(12, 'truck', FALSE),
(13, 'car',   TRUE),
(14, 'bike',   FALSE),
(15, 'truck',  TRUE),
(16, 'car',    FALSE),
(17, 'bike',   TRUE),
(18, 'car',    FALSE),
(19, 'truck',  FALSE),
(20, 'bike',   FALSE),
(21, 'car',    TRUE),
(22, 'bike',   FALSE),
(23, 'truck',  TRUE),
(24, 'car',    FALSE),
(25, 'bike',   TRUE),
(26, 'car',    TRUE),
(27, 'truck',  FALSE),
(28, 'bike',   FALSE),
(29, 'car',    TRUE),
(30, 'truck',  TRUE),
(31, 'car',    FALSE),
(32, 'bike',   FALSE),
(33, 'truck',  FALSE),
(34, 'car',    TRUE);


-- Parking Fees
INSERT INTO parking_fees (vehicle_type, hourly_rate) VALUES
('car', 50.00),
('bike', 20.00),
('truck', 100.00);

-- Parking Records
INSERT INTO parking_records (vehicle_id, spot_id, entry_time)
VALUES
(1,1,NOW()),
(2,2,NOW()),
(3,  3,  '2025-08-13 08:15:00'),       
(4,  4,  '2025-10-13 07:45:00'),        
(5,  5,  '2025-08-16 09:10:00'),      
(6,  6,  '2025-07-21 17:30:00'),        
(7,  7,  '2025-08-12 18:45:00'),        
(8,  8,  '2025-09-24 09:20:00'),       
(9,  9,  '2025-08-06 14:00:00'),        
(10, 10, '2025-08-10 10:30:00'),        
(11, 11, '2025-08-09 08:10:00'),
(12, 12, '2025-08-18 11:25:00'),
(13, 13, '2025-08-20 16:40:00'),
(14, 14, '2025-08-25 07:55:00'),
(15, 15, '2025-08-28 12:15:00'),
(16, 16, '2025-09-01 14:50:00'),
(17, 17, '2025-09-03 09:35:00'),
(18, 18, '2025-09-05 18:05:00'),
(19, 19, '2025-09-08 08:25:00'),
(20, 20, '2025-09-10 17:45:00'),
(21, 21, '2025-09-14 10:55:00'),
(22, 22, '2025-09-17 13:30:00'),
(23, 23, '2025-09-21 07:40:00'),
(24, 24, '2025-09-25 15:20:00'),
(25, 25, '2025-09-29 08:10:00'),
(26, 26, '2025-10-02 19:25:00'),
(27, 27, '2025-10-06 09:50:00'),
(28, 28, '2025-10-09 14:15:00'),
(29, 29, '2025-10-12 11:40:00'),
(30, 30, '2025-10-15 16:55:00'),
(31, 31, '2025-10-18 07:05:00'),
(32, 32, '2025-08-18 10:05:00'),
(33, 33, '2025-08-18 20:15:00'),
(34, 34, '2025-09-18 07:15:00');      

-- Vehicle exits → update exit_time, auto mark free
UPDATE parking_records
SET exit_time = DATE_ADD(entry_time, INTERVAL 2 HOUR)
WHERE record_id = 1;

-- Calculate fee manually
CALL calculate_fee(1);

-- Check current occupancy
SELECT * FROM current_occupancy;

-- Check audit logs
SELECT * FROM parking_audit;

-- Check parking records
SELECT * FROM parking_records;

-- All vehicles:
SELECT * FROM vehicles;
-- All customers from Chennai:
SELECT * FROM customers WHERE city = 'Chennai';
-- Distinct cities:
SELECT DISTINCT city FROM customers;
-- Available parking spots:
SELECT * FROM parking_spots WHERE is_occupied = FALSE;

-- Parking Records Queries
-- Check all parking records:
SELECT * FROM parking_records;
-- Check current occupancy:
SELECT * FROM current_occupancy;
-- Longest parking sessions (with exit):
SELECT v.plate_no, 
       TIMESTAMPDIFF(HOUR, pr.entry_time, pr.exit_time) AS hours_parked
FROM parking_records pr
JOIN vehicles v ON pr.vehicle_id = v.vehicle_id
WHERE pr.exit_time IS NOT NULL
ORDER BY hours_parked DESC
LIMIT 5;
-- Vehicles parked more than once in the same spot (duplicates):
SELECT vehicle_id, spot_id, COUNT(*) AS count
FROM parking_records
GROUP BY vehicle_id, spot_id
HAVING COUNT(*) > 1;

-- Revenue Queries
-- Total revenue collected today:
SELECT SUM(fee) AS total_revenue
FROM parking_records
WHERE DATE(exit_time) = CURDATE();
-- Monthly revenue:
SELECT DATE_FORMAT(exit_time, '%Y-%m') AS month, SUM(fee) AS total_revenue
FROM parking_records
WHERE exit_time IS NOT NULL
GROUP BY DATE_FORMAT(exit_time, '%Y-%m')
ORDER BY month DESC;
-- Revenue by vehicle type:
SELECT v.vehicle_type, SUM(pr.fee) AS total_revenue
FROM parking_records pr
JOIN vehicles v ON pr.vehicle_id = v.vehicle_id
WHERE pr.exit_time IS NOT NULL
GROUP BY v.vehicle_type;

-- Customer Analytics
-- Most frequent customers:
SELECT c.name, COUNT(*) AS visits
FROM parking_records pr
JOIN vehicles v ON pr.vehicle_id = v.vehicle_id
JOIN customers c ON v.customer_id = c.customer_id
GROUP BY c.name
ORDER BY visits DESC;
-- Customers who parked in all spot types (division query):
SELECT v.plate_no
FROM vehicles v
JOIN parking_records pr ON v.vehicle_id = pr.vehicle_id
JOIN parking_spots p ON pr.spot_id = p.spot_id
GROUP BY v.plate_no
HAVING COUNT(DISTINCT p.spot_type) = (
    SELECT COUNT(DISTINCT spot_type) FROM parking_spots
);

-- Time-based Analytics
-- Peak parking hours (most entries by hour):
SELECT HOUR(entry_time) AS hour, COUNT(*) AS vehicles_entered
FROM parking_records
GROUP BY HOUR(entry_time)
ORDER BY vehicles_entered DESC;
-- Vehicles currently parked longer than X hours (e.g., 2 hours):
SELECT v.plate_no, TIMESTAMPDIFF(HOUR, pr.entry_time, NOW()) AS hours_parked
FROM parking_records pr
JOIN vehicles v ON pr.vehicle_id = v.vehicle_id
WHERE pr.exit_time IS NULL
HAVING hours_parked > 2;

-- Audit Queries
-- Full audit log:
SELECT * FROM parking_audit ORDER BY action_time DESC;
-- Audit by action type (INSERT/UPDATE/DELETE):
SELECT * FROM parking_audit WHERE action_type='DELETE';
-- Audit for a specific record:
SELECT * FROM parking_audit WHERE record_id = 1;

DELETE FROM parking_records
WHERE record_id = 2;

SELECT * FROM parking_audit;
-- audit log for deleted record
SELECT * FROM parking_audit
WHERE record_id = 2 AND action_type = 'DELETE';

UPDATE parking_records
SET exit_time = NOW()
WHERE exit_time IS NULL AND entry_time < CURDATE();