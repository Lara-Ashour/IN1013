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


-- List the names of customers who spent more than 450.00 on a single bill when 'Charles' was their Headwaiter.
SELECT DISTINCT Customers.customer_name
FROM Bills
JOIN Customers ON Bills.customer_id = Customers.customer_id
JOIN Headwaiters ON Bills.waiter_id = Headwaiters.headwaiter_id
WHERE Bills.bill_amount > 450.00 AND Headwaiters.headwaiter_name = 'Charles';

-- A customer called Nerida has complained that a waiter was rude to her on 11th January 2016.
SELECT Headwaiters.headwaiter_name, Headwaiters.headwaiter_surname
FROM Bills
JOIN Customers ON Bills.customer_id = Customers.customer_id
JOIN Headwaiters ON Bills.waiter_id = Headwaiters.headwaiter_id
WHERE Customers.customer_name = 'Nerida' AND Bills.bill_date = '2016-01-11';

-- Names of customers with the smallest bill.
SELECT Customers.customer_name
FROM Bills
JOIN Customers ON Bills.customer_id = Customers.customer_id
WHERE Bills.bill_amount = (
    SELECT MIN(bill_amount) FROM Bills
);
