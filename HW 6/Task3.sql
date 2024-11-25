
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);


CREATE TABLE Headwaiters (
    headwaiter_id INT PRIMARY KEY,
    headwaiter_name VARCHAR(50),
    headwaiter_surname VARCHAR(50)
);


CREATE TABLE Waiters (
    waiter_id INT PRIMARY KEY,
    waiter_name VARCHAR(50),
    waiter_surname VARCHAR(50),
    headwaiter_id INT,
    FOREIGN KEY (headwaiter_id) REFERENCES Headwaiters(headwaiter_id)
);


CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_name VARCHAR(50),
    headwaiter_id INT,
    FOREIGN KEY (headwaiter_id) REFERENCES Headwaiters(headwaiter_id)
);


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



INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Tanya Singh'),
(2, 'Alice Brown'),
(3, 'Bob Smith');


INSERT INTO Headwaiters (headwaiter_id, headwaiter_name, headwaiter_surname) VALUES
(201, 'Charles', 'Green');


INSERT INTO Waiters (waiter_id, waiter_name, waiter_surname, headwaiter_id) VALUES
(101, 'John', 'Doe', 201),
(102, 'Zoe', 'Ball', 201),
(103, 'Sam', 'Wilson', 201);


INSERT INTO Rooms (room_id, room_name, headwaiter_id) VALUES
(301, 'Green', 201),
(302, 'Blue', 201);


INSERT INTO Bills (bill_id, customer_id, waiter_id, room_id, bill_amount, bill_date) VALUES
(1001, 1, 101, 301, 450.00, '2016-02-15'),
(1002, 2, 102, 302, 600.00, '2016-02-20'),
(1003, 3, 103, 301, 300.00, '2016-03-10');



SELECT waiter_name
FROM Bills
JOIN Customers ON Bills.customer_id = Customers.customer_id
JOIN Waiters ON Bills.waiter_id = Waiters.waiter_id
WHERE Customers.customer_name = 'Tanya Singh';


SELECT DISTINCT Bills.bill_date
FROM Bills
JOIN Rooms ON Bills.room_id = Rooms.room_id
JOIN Headwaiters ON Rooms.headwaiter_id = Headwaiters.headwaiter_id
WHERE Headwaiters.headwaiter_name = 'Charles'
  AND Rooms.room_name = 'Green'
  AND Bills.bill_date LIKE '2016-02%';


SELECT DISTINCT Waiters.waiter_name, Waiters.waiter_surname
FROM Waiters
JOIN Headwaiters ON Waiters.headwaiter_id = Headwaiters.headwaiter_id
WHERE Headwaiters.headwaiter_id = (
    SELECT Headwaiters.headwaiter_id
    FROM Waiters
    JOIN Headwaiters ON Waiters.headwaiter_id = Headwaiters.headwaiter_id
    WHERE Waiters.waiter_name = 'Zoe' AND Waiters.waiter_surname = 'Ball'
);
