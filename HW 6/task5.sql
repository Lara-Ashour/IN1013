-- Create Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Create Headwaiters Table
CREATE TABLE Headwaiters (
    headwaiter_id INT PRIMARY KEY,
    headwaiter_name VARCHAR(50),
    headwaiter_surname VARCHAR(50)
);

-- Create Waiters Table
CREATE TABLE Waiters (
    waiter_id INT PRIMARY KEY,
    waiter_name VARCHAR(50),
    waiter_surname VARCHAR(50),
    headwaiter_id INT,
    FOREIGN KEY (headwaiter_id) REFERENCES Headwaiters(headwaiter_id)
);

-- Create Rooms Table
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_name VARCHAR(50),
    headwaiter_id INT,
    FOREIGN KEY (headwaiter_id) REFERENCES Headwaiters(headwaiter_id)
);

-- Create Bills Table
CREATE TABLE Bills (
    bill_id INT PRIMARY KEY,
    customer_id INT,
    waiter_id INT,
    room_id INT,
    bill_amount DECIMAL(10, 2),
    bill_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (waiter_id) REFERENCES Waiters(waiter_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

-- Create Tables Table
CREATE TABLE Tables (
    table_id INT PRIMARY KEY,
    room_id INT,
    seats INT,
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

-- Insert Data into Customers
INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Tanya Singh'),
(2, 'Alice Brown'),
(3, 'Bob Smith');

-- Insert Data into Headwaiters
INSERT INTO Headwaiters (headwaiter_id, headwaiter_name, headwaiter_surname) VALUES
(201, 'Charles', 'Green');

-- Insert Data into Waiters
INSERT INTO Waiters (waiter_id, waiter_name, waiter_surname, headwaiter_id) VALUES
(101, 'John', 'Doe', 201),
(102, 'Zoe', 'Ball', 201),
(103, 'Sam', 'Wilson', 201);

-- Insert Data into Rooms
INSERT INTO Rooms (room_id, room_name, headwaiter_id) VALUES
(301, 'Green', 201),
(302, 'Blue', 201);

-- Insert Data into Bills
INSERT INTO Bills (bill_id, customer_id, waiter_id, room_id, bill_amount, bill_date) VALUES
(1001, 1, 101, 301, 450.00, '2016-02-15'),
(1002, 2, 102, 302, 600.00, '2016-02-20'),
(1003, 3, 103, 301, 300.00, '2016-03-10');

-- Insert Data into Tables
INSERT INTO Tables (table_id, room_id, seats) VALUES
(401, 301, 4),
(402, 301, 8),
(403, 302, 10),
(404, 302, 6);


-- Which waiters have taken 2 or more bills on a single date?
SELECT Waiters.waiter_name, Waiters.waiter_surname, Bills.bill_date, COUNT(Bills.bill_id) AS bill_count
FROM Bills
JOIN Waiters ON Bills.waiter_id = Waiters.waiter_id
GROUP BY Waiters.waiter_name, Waiters.waiter_surname, Bills.bill_date
HAVING COUNT(Bills.bill_id) >= 2;

-- Rooms with tables that can serve more than 6 people and the count of such tables.
SELECT Rooms.room_name, COUNT(Tables.table_id) AS table_count
FROM Rooms
JOIN Tables ON Tables.room_id = Rooms.room_id
WHERE Tables.seats > 6
GROUP BY Rooms.room_name;

-- Names of the rooms and the total amount of bills in each room.
SELECT Rooms.room_name, SUM(Bills.bill_amount) AS total_bill_amount
FROM Bills
JOIN Rooms ON Bills.room_id = Rooms.room_id
GROUP BY Rooms.room_name;

-- Headwaiter's name, surname, and total bill amount their waiters have taken.
SELECT Headwaiters.headwaiter_name, Headwaiters.headwaiter_surname, SUM(Bills.bill_amount) AS total_bill_amount
FROM Bills
JOIN Waiters ON Bills.waiter_id = Waiters.waiter_id
JOIN Headwaiters ON Waiters.headwaiter_id = Headwaiters.headwaiter_id
GROUP BY Headwaiters.headwaiter_name, Headwaiters.headwaiter_surname
ORDER BY total_bill_amount DESC;

-- Customers who have spent more than £400 on average.
SELECT Customers.customer_name
FROM Bills
JOIN Customers ON Bills.customer_id = Customers.customer_id
GROUP BY Customers.customer_name
HAVING AVG(Bills.bill_amount) > 400;

-- Which waiters have taken 3 or more bills on a single date?
SELECT Waiters.waiter_name, Waiters.waiter_surname, COUNT(Bills.bill_id) AS bill_count
FROM Bills
JOIN Waiters ON Bills.waiter_id = Waiters.waiter_id
GROUP BY Waiters.waiter_name, Waiters.waiter_surname, Bills.bill_date
HAVING COUNT(Bills.bill_id) >= 3;
