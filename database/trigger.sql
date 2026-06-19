CREATE TRIGGER trg_Prevent_Maintenance_Reservation
ON Reservation
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Car c ON i.Car_ID = c.Car_ID
        WHERE c.Status = 'Maintenance'
    )
    BEGIN
        RAISERROR ('Cannot reserve a car under maintenance!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If no maintenance issues, insert the row
    INSERT INTO Reservation (Reservation_ID, Car_ID, Customer_ID, Start_Date, End_Date, Reservation_Date, Status)
    SELECT Reservation_ID, Car_ID, Customer_ID, Start_Date, End_Date, Reservation_Date, Status
    FROM inserted;
END;



-- This should fail because CAR003 is under maintenance
INSERT INTO Reservation (Reservation_ID, Car_ID, Customer_ID, Start_Date, End_Date, Reservation_Date, Status)
VALUES ('R016', 'CAR003', 'C005', '2025-12-20', '2025-12-25', '2025-12-15', 'Approved');
CREATE TRIGGER trg_Set_Car_Reserved
ON Reservation
AFTER INSERT
AS
BEGIN
    UPDATE c
    SET c.Status = 'Reserved'
    FROM Car c
    JOIN inserted i ON c.Car_ID = i.Car_ID
    WHERE c.Status = 'Available';
END;




-- CAR001 is available, after reservation it should become Reserved
INSERT INTO Reservation (Reservation_ID, Car_ID, Customer_ID, Start_Date, End_Date, Reservation_Date, Status)
VALUES ('R017', 'CAR001', 'C002', '2025-12-22', '2025-12-26', '2025-12-18', 'Approved');

-- Check status
SELECT Car_ID, Status FROM Car WHERE Car_ID='CAR001'; 
CREATE TRIGGER trg_Prevent_Negative_Salary
ON Employee
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Employee_Salary < 30000)
    BEGIN
        RAISERROR('Employee salary cannot be below 30000!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE e
    SET Employee_Name = i.Employee_Name,
        Employee_Salary = i.Employee_Salary,
        Employee_Designation = i.Employee_Designation
    FROM Employee e
    JOIN inserted i ON e.Employee_ID = i.Employee_ID;
END;




-- Should fail
UPDATE Employee
SET Employee_Salary = 25000
WHERE Employee_ID = 'E002'; 
CREATE TRIGGER trg_Prevent_Car_Delete
ON Car
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN Reservation r ON d.Car_ID = r.Car_ID
        WHERE r.Status = 'Approved' AND r.End_Date >= GETDATE()
    )
    BEGIN
        RAISERROR('Cannot delete a car with active reservations!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DELETE c
    FROM Car c
    JOIN deleted d ON c.Car_ID = d.Car_ID;
END;



-- Assuming CAR001 has an active reservation
DELETE FROM Car WHERE Car_ID='CAR001';