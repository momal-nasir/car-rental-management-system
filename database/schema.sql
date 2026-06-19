CREATE TABLE Customer (
    Customer_ID       VARCHAR(10) PRIMARY KEY,
    Customer_Name     VARCHAR(100) NOT NULL,
    Email             VARCHAR(120) UNIQUE NOT NULL,
    City              VARCHAR(50),
    Postal_Code       VARCHAR(10),
    Street            VARCHAR(100),
    House_No          VARCHAR(20),
    Licence_ID        VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE Customer_Contact (
    Customer_ID VARCHAR(10) NOT NULL 
        FOREIGN KEY REFERENCES Customer(Customer_ID) ON DELETE CASCADE,
    Contact     VARCHAR(20) NOT NULL,
    PRIMARY KEY (Customer_ID, Contact)
);
CREATE TABLE Car (
    Car_ID             VARCHAR(10) PRIMARY KEY,
    Brand_Name         VARCHAR(50) NOT NULL,
    Type               VARCHAR(50),
    Model              VARCHAR(20),
    Daily_Rate         DECIMAL(10,2) CHECK (Daily_Rate > 4000),
    Licence_Number     VARCHAR(50) UNIQUE NOT NULL,
    Status             VARCHAR(20) CHECK (Status IN ('Available','Reserved','Maintenance')),
    Odometer_Reading   INT CHECK (Odometer_Reading >= 0)
);
CREATE TABLE Reservation (
    Reservation_ID     VARCHAR(10) PRIMARY KEY,
    Car_ID             VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Car(Car_ID),
    Customer_ID        VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Customer(Customer_ID),
    Start_Date         DATE NOT NULL,
    End_Date           DATE NOT NULL,
    Reservation_Date   DATE NOT NULL DEFAULT GETDATE(),
    Status             VARCHAR(20) CHECK (Status IN ('Approved','Cancelled')),
    CHECK (End_Date >= Start_Date)
);
CREATE TABLE Employee (
    Employee_ID        VARCHAR(10) PRIMARY KEY,
    Employee_Name      VARCHAR(100) NOT NULL,
    Employee_Salary    DECIMAL(12,2) CHECK (Employee_Salary > 30000),
    Employee_Designation VARCHAR(100) CHECK (Employee_Designation IN ('Rental Agent','Fleet Manager','Vehicle Inspector','Cashier','Branch Manager','Customer Service Representative'))
);
CREATE TABLE Employee_Contact (
    Employee_ID VARCHAR(10) NOT NULL 
        FOREIGN KEY REFERENCES Employee(Employee_ID) ON DELETE CASCADE,
    Employee_Contact VARCHAR(20) NOT NULL,
    PRIMARY KEY (Employee_ID, Employee_Contact)
);
CREATE TABLE Contract (
    Contract_ID     VARCHAR(10) PRIMARY KEY,
    Reservation_ID  VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Reservation(Reservation_ID),
    Employee_ID     VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Employee(Employee_ID),
    Start_Date      DATE NOT NULL,
    End_Date        DATE NOT NULL,
    CHECK (End_Date >= Start_Date)
);
CREATE TABLE Payment (
    Payment_ID      VARCHAR(10) PRIMARY KEY,
    Contract_ID     VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Contract(Contract_ID),
    Customer_ID     VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Customer(Customer_ID),
    Payment_Date    DATE NOT NULL DEFAULT GETDATE(),
    Payment_Method  VARCHAR(30)
        CHECK (Payment_Method IN ('Cash','Card','Online'))
);

INSERT INTO Customer (Customer_ID, Customer_Name, Email, City, Postal_Code, Street, House_No, Licence_ID) VALUES
('C001','Alice Johnson','alice.johnson@email.com','New York','10001','5th Avenue','12A','LIC1001'),
('C002','Bob Smith','bob.smith@email.com',NULL,'20002','Broadway','45B','LIC1002'), 
('C003','Charlie Brown','charlie.brown@email.com','Chicago','60601',NULL,'23','LIC1003'), 
('C004','David Lee','david.lee@email.com','San Francisco','94105','Market Street',NULL,'LIC1004'), 
('C005','Emma Davis','emma.davis@email.com','New York','02101','Beacon Street','7','LIC1005'), 
('C006','Frank White','frank.white@email.com','Miami','33101','Ocean Drive','19','LIC1006'),
('C007','Grace Kim','grace.kim@email.com','Seattle','98101','Pine Street','11','LIC1007'),
('C008','Hannah Scott','hannah.scott@email.com','Austin','73301','Congress  Ave','14','LIC1008'),
('C009','Ian Martinez','ian.martinez@email.com','Denver','80201','Colfax Ave','9','LIC1009'),
('C010','Julia Lopez','julia.lopez@email.com','Denver','80201','Fremont St','5','LIC1010'), 
('C011','Kevin Turner','kevin.turner@email.com','Miami','32801','Orange Ave','22','LIC1011'), 


('C012','LauraPerez','laura.perez@email.com','Dallas','19101','Chestnut St','16','LIC1012'),
('C013','MichaelYoung','michael.young@email.com','Dallas','77001','Main St','8','LIC1013'), 
('C014','Natalie Adams','natalie.adams@email.com','Phoenix','85001','Central Ave','2','LIC1014'),
('C015','Oliver Clark','oliver.clark@email.com','Minneapolis','55401','Elm St','10','LIC1015');
INSERT INTO Customer_Contact (Customer_ID, Contact) VALUES
-- C001 (2 contacts)
('C001', '(212) 555-1189'),
('C001', '(212) 555-9921'),

-- C002 (1 contact)
('C002', '(202) 555-7744'),

-- C003 (1 contact)
('C003', '(312) 555-6632'),

-- C004 (1 contact)
('C004', '(415) 555-4498'),

-- C005 (2 contacts)
('C005', '(917) 555-2045'),
('C005', '(917) 555-7782'),

-- C006 (1 contact)
('C006', '(305) 555-9144'),

-- C007 (1 contact)
('C007', '(206) 555-3309'),

-- C008 (1 contact)
('C008', '(512) 555-8876'),

-- C009 (1 contact)
('C009', '(303) 555-2211'),

-- C010 (1 contact)
('C010', '(303) 555-6578'),

-- C011 (1 contact)
('C011', '(407) 555-9234'),

-- C012 (2 contacts)
('C012', '(214) 555-7854'),
('C012', '(214) 555-9920'),

-- C013 (2 contacts)
('C013', '(214) 555-6655'),
('C013', '(214) 555-1177'),

-- C014 (1 contact)
('C014', '(602) 555-8899'),

-- C015 (1 contact)
('C015', '(612) 555-4477');
INSERT INTO Car (Car_ID, Brand_Name, Type, Model, Daily_Rate, Licence_Number, Status, Odometer_Reading) VALUES
('CAR001', 'Toyota', 'Sedan', 'Corolla 2018', 4500, 'LIC-CAR-1001', 'Available', 65000),
('CAR002', 'Honda', 'Sedan', 'Civic 2019', 4800, 'LIC-CAR-1002', 'Reserved', 72000),
('CAR003', 'Ford', 'SUV', 'Escape 2020', 5200, 'LIC-CAR-1003', 'Maintenance', 41000),
('CAR004', 'BMW', 'SUV', 'X5 2021', 9500, 'LIC-CAR-1004', 'Available', 28000),
('CAR005', 'Mercedes', 'Sedan', 'C-Class 2017', 8800, 'LIC-CAR-1005', 'Reserved', 89000),
('CAR006', 'Hyundai', 'Hatchback', 'i20 2020', 4300, 'LIC-CAR-1006', 'Available', 35000),
('CAR007', 'KIA', 'SUV', 'Sportage 2022', 6000, 'LIC-CAR-1007', 'Maintenance', 17000),
('CAR008', 'Audi', 'Sedan', 'A4 2019', 9200, 'LIC-CAR-1008', 'Reserved', 54000),
('CAR009', 'Tesla', 'Electric', 'Model 3 2021', 10000, 'LIC-CAR-1009', 'Available', 22000),
('CAR010', 'Nissan', 'SUV', 'Rogue 2018', 4700, 'LIC-CAR-1010', 'Available', 98000),
('CAR011', 'Chevrolet', 'Sedan', 'Malibu 2017', 4600, 'LIC-CAR-1011', 'Reserved', 105000),
('CAR012', 'Volkswagen', 'Hatchback', 'Golf 2019', 5100, 'LIC-CAR-1012', 'Available', 58000),
('CAR013', 'Subaru', 'SUV', 'Forester 2020', 5300, 'LIC-CAR-1013', 'Reserved', 46000),
('CAR014', 'Lexus', 'Sedan', 'ES 350 2021', 9400, 'LIC-CAR-1014', 'Maintenance', 30000),
('CAR015', 'Mazda', 'Sedan', 'Mazda 3 2018', 4700, 'LIC-CAR-1015', 'Available', 86000);

INSERT INTO Reservation VALUES
('R001','CAR001','C001','2025-01-05','2025-01-10','2025-01-02','Approved'),
('R002','CAR003','C001','2025-03-15','2025-03-20','2025-03-10','Approved'),

('R003','CAR002','C002','2025-02-12','2025-02-18','2025-02-10','Approved'),
('R004','CAR005','C002','2025-06-01','2025-06-05','2025-05-25','Cancelled'),

('R005','CAR004','C003','2025-04-01','2025-04-06','2025-03-29','Approved'),

('R006','CAR006','C004','2025-07-10','2025-07-15','2025-07-05','Approved'),
('R007','CAR006','C004','2025-10-01','2025-10-04','2025-09-27','Approved'),

('R008','CAR007','C005','2025-08-05','2025-08-12','2025-07-30','Approved'),

('R009','CAR008','C006','2025-09-20','2025-09-25','2025-09-15','Cancelled'),

('R010','CAR009','C007','2025-05-11','2025-05-16','2025-05-05','Approved'),
('R011','CAR009','C007','2025-11-10','2025-11-15','2025-11-01','Approved'),

('R012','CAR010','C008','2025-04-22','2025-04-28','2025-04-19','Approved'),

('R013','CAR012','C009','2025-12-20','2025-12-27','2025-12-15','Approved'),

('R014','CAR014','C010','2025-03-10','2025-03-14','2025-03-05','Cancelled'),
('R015','CAR014','C010','2025-08-01','2025-08-06','2025-07-28','Approved');('R015','CAR014','C010','2025-08-01','2025-08-06','2025-07-28','Approved');
INSERT INTO Employee (Employee_ID, Employee_Name, Employee_Salary, Employee_Designation) VALUES
('E001','John Carter',65000,'Branch Manager'),
('E002','Emily Davis',42000,'Rental Agent'),
('E003','Michael Harris',48000,'Fleet Manager'),
('E004','Sarah Thompson',39000,'Customer Service Representative'),
('E005','David Wilson',52000,'Vehicle Inspector'),
('E006','Sophia Martinez',45000,'Cashier'),
('E007','Daniel Roberts',47000,'Rental Agent'),
('E008','Olivia Brown',51000,'Fleet Manager'),
('E009','James Turner',38000,'Customer Service Representative'),
('E010','Ava Collins',56000,'Vehicle Inspector'),
('E011','Henry Walker',43000,'Cashier'),
('E012','Natalie Reed',54000,'Fleet Manager'),
('E013','Ethan Brooks',61000,'Branch Manager'),
('E014','Chloe Mitchell',36500,'Customer Service Representative'),
('E015','Lucas Perry',49000,'Rental Agent');
INSERT INTO Contract (Contract_ID, Reservation_ID, Employee_ID, Start_Date, End_Date) VALUES
('CT001','R001','E001','2025-12-01','2025-12-05'),
('CT002','R002','E002','2025-12-03','2025-12-07'),
('CT003','R003','E003','2025-12-05','2025-12-10'),
('CT004','R004','E004','2025-12-02','2025-12-06'),
('CT005','R005','E005','2025-12-07','2025-12-12'),
('CT006','R006','E006','2025-12-04','2025-12-08'),
('CT007','R007','E001','2025-12-10','2025-12-15'),
('CT008','R008','E007','2025-12-06','2025-12-09'),
('CT009','R009','E008','2025-12-09','2025-12-13'),
('CT010','R010','E009','2025-12-11','2025-12-14'),
('CT011','R011','E010','2025-12-05','2025-12-08'),
('CT012','R012','E011','2025-12-07','2025-12-12'),
('CT013','R013','E012','2025-12-10','2025-12-14'),
('CT014','R014','E013','2025-12-03','2025-12-07'),
('CT015','R015','E014','2025-12-12','2025-12-16');
INSERT INTO Payment (Payment_ID, Contract_ID, Customer_ID, Payment_Date, Payment_Method) VALUES
('P001','CT001','C001','2025-11-30','Card'),
('P002','CT002','C002','2025-12-02','Cash'),
('P003','CT003','C003','2025-12-04','Online'),
('P004','CT004','C004','2025-12-01','Card'),
('P005','CT005','C005','2025-12-06','Cash'),
('P006','CT006','C006','2025-12-03','Online'),
('P007','CT007','C001','2025-12-09','Card'),
('P008','CT008','C007','2025-12-05','Cash'),
('P009','CT009','C008','2025-12-08','Online'),
('P010','CT010','C009','2025-12-10','Card'),
('P011','CT011','C010','2025-12-04','Cash'),
('P012','CT012','C011','2025-12-08','Online'),
('P013','CT013','C012','2025-12-09','Card'),
('P014','CT014','C013','2025-12-02','Cash'),
('P015','CT015','C014','2025-12-11','Online');