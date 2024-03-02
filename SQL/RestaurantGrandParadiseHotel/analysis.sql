-- DDL
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_type VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('available', 'occupied'))
);

CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY,
    room_id INT,
    customer_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    amount_paid DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

-- Inserting data into the Rooms table
INSERT INTO Rooms (room_id, room_type, status) VALUES
(1, 'Deluxe', 'available'),
(2, 'Deluxe', 'available'),
(3, 'Executive Suite', 'available'),
(4, 'Presidential Suite', 'available'),
(5, 'Deluxe', 'occupied'),
(6, 'Presidential Suite', 'occupied'),
(7, 'Executive Suite', 'occupied'),
(8, 'Deluxe', 'available'),
(9, 'Presidential Suite', 'available');

-- Inserting data into the Reservations table
INSERT INTO Reservations (reservation_id, room_id, customer_id, check_in_date, check_out_date, amount_paid) VALUES
(1, 1, 101, '2024-02-01', '2024-02-05', 500),
(2, 2, 102, '2024-02-02', '2024-02-07', 800),
(3, 3, 103, '2024-02-03', '2024-02-10', 1200),
(4, 4, 104, '2024-02-04', '2024-02-06', 1000),
(5, 5, 105, '2024-02-05', '2024-02-09', 1500),
(6, 6, 106, '2024-02-06', '2024-02-08', 2000),
(7, 7, 107, '2024-02-07', '2024-02-11', 1800),
(8, 8, 108, '2024-02-08', '2024-02-12', 1600),
(9, 9, 106, '2024-02-09', '2024-02-13', 1400);

.print #######################
.print #### SQL Challenge ####
.print #######################

.print \n Rooms table
.mode box
select * from Rooms limit 5;

.print \n Reservations table
.mode box
select * from Reservations limit 5;

-- 1. หาประเภทห้องที่โรงแรมมี และจำนวนห้องที่ว่างในแต่ละประเภท
.print \n 1.หาประเภทห้องที่โรงแรมมี และจำนวนห้องที่ว่างในแต่ละประเภท
SELECT
  room_type,
  SUM(room_id) AS Room_available
FROM Rooms
WHERE status = 'available'
GROUP BY room_type;


-- 2. คำนวนราคาเฉลี่ยที่ลูกค้าจ่ายต่อครั้ง
.print \n 2. คำนวนราคาเฉลี่ยที่ลูกค้าจ่ายต่อครั้ง
SELECT
  ROUND(AVG(amount_paid),2) AS Average_amount_per_section
FROM Reservations;

-- 3. หาลูกค้าที่มียอดการใช้จ่ายสูงที่สุดตลอดกาล และหาว่าจองห้องไปกี่ครั้ง
.print \n 3. หาลูกค้าที่มียอดการใช้จ่ายสูงที่สุดตลอดกาล และหาว่าจองห้องไปกี่ครั้ง
select
  customer_id,
  SUM(amount_paid) total_paid,
  COUNT(reservation_id) total_room_booked
FROM Reservations
GROUP BY customer_id
ORDER BY SUM(amount_paid) DESC
LIMIT 1;

-- 4. หาลูกค้าที่มียอดการใช้จ่ายสูงที่สุด และหาว่าจองห้องไปกี่ครั้ง
.print \n 4. หาลูกค้าที่มียอดการใช้จ่ายสูงที่สุด และหาว่าจองห้องไปกี่ครั้ง
SELECT 
  customer_id, 
  MAX(amount_paid) AS top_paid, 
  COUNT(reservation_id) AS booking_times
FROM reservations
GROUP BY customer_id
ORDER BY top_paid DESC
LIMIT 1;

-- 5.หาว่าวันไหน (จันทร์ – อาทิตย์) ที่มียอดจองห้องสูงที่สุด sqlite ดีตรงมันใช้ alias ใน group by ได้สะดวกดีปกติทำไม่ได้นะแบบนี้
.print \n 5.หาว่าวันไหน (จันทร์ – อาทิตย์) ที่มียอดจองห้องสูงที่สุด
SELECT
  CASE
    WHEN strftime('%w',check_in_date) = '0' THEN 'Sunday'
    WHEN strftime('%w',check_in_date) = '1' THEN 'Monday'
    WHEN strftime('%w',check_in_date) = '2' THEN 'Tuesday'
    WHEN strftime('%w',check_in_date) = '3' THEN 'Wednesday'
    WHEN strftime('%w',check_in_date) = '4' THEN 'Thrusday'
    WHEN strftime('%w',check_in_date) = '5' THEN 'Friday'
    ElSE 'Satuarday'
  END AS Day_of_week,
  COUNT(reservation_id) AS total_room_booked
FROM Reservations
GROUP BY Day_of_week
LIMIT 1;

-- 6.คำนวนอัตราการเข้าพัก (Occupancy Rate) ของโรงแรมนี้

SELECT
  ROUND(CAST(COUNT(status) AS float) / (SELECT CAST(COUNT(*) AS float) FROM Rooms)*100,2) AS Occupancy_Rate 
FROM Rooms
WHERE status = 'occupied';
--หรือแบบนี้ น่าจะไวกว่าเพราะไม่ใช่ subquery
SELECT
  SUM(CASE WHEN status = 'occupied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS occupancy_rate
FROM rooms;
