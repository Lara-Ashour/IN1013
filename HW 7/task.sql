CREATE TABLE waiter (
    waiter_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    surname VARCHAR(50)
);

CREATE TABLE bills (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    waiter_id INT,
    bill_date DATE,
    cust_name VARCHAR(100),
    bill_total DECIMAL(10, 2),
    room_id INT,
    FOREIGN KEY (waiter_id) REFERENCES waiter(waiter_id)
);

CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(50)
);


INSERT INTO waiter (first_name, surname) VALUES
('Sam', 'Pitt'),
('John', 'Doe'),
('Jane', 'Smith');

INSERT INTO rooms (room_name) VALUES
('Room A'),
('Room B'),
('Room C');

INSERT INTO bills (waiter_id, bill_date, cust_name, bill_total, room_id) VALUES
(1, '2023-01-01', 'Customer 1', 450.00, 1),
(1, '2023-01-02', 'Customer 2', 300.00, 2),
(2, '2023-01-01', 'Customer 3', 500.00, 1),
(3, '2023-01-03', 'Customer 4', 200.00, 3);

CREATE VIEW samsBills AS
SELECT 
    waiter.first_name, 
    waiter.surname, 
    bills.bill_date, 
    bills.cust_name, 
    bills.bill_total
FROM 
    bills
JOIN 
    waiter 
ON 
    bills.waiter_id = waiter.waiter_id
WHERE 
    waiter.first_name = 'Sam' AND waiter.surname = 'Pitt';

SELECT *
FROM samsBills
WHERE bill_total > 400;

CREATE VIEW roomTotals AS
SELECT 
    rooms.room_name, 
    SUM(bills.bill_total) AS total_sum
FROM 
    bills
JOIN 
    rooms 
ON 
    bills.room_id = rooms.room_id
GROUP BY 
    rooms.room_name;

CREATE VIEW teamTotals AS
SELECT 
    CONCAT(waiter.first_name, ' ', waiter.surname) AS headwaiter_name, 
    SUM(bills.bill_total) AS total_sum
FROM 
    bills
JOIN 
    waiter 
ON 
    bills.waiter_id = waiter.waiter_id
GROUP BY 
    headwaiter_name;

