CREATE PROCEDURE sp_AddReservation
    @Reservation_ID VARCHAR(10),
    @Car_ID VARCHAR(10),
    @Customer_ID VARCHAR(10),
    @Start_Date DATE,
    @End_Date DATE,
    @Status VARCHAR(20)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Car WHERE Car_ID = @Car_ID AND Status = 'Maintenance')
    BEGIN
        RAISERROR('Cannot reserve a car under maintenance!', 16, 1);
        RETURN;
    END

    INSERT INTO Reservation (Reservation_ID, Car_ID, Customer_ID, Start_Date, End_Date, Reservation_Date, Status)
    VALUES (@Reservation_ID, @Car_ID, @Customer_ID, @Start_Date, @End_Date, GETDATE(), @Status);

    UPDATE Car
    SET Status = 'Reserved'
    WHERE Car_ID = @Car_ID AND Status = 'Available';
END;




EXEC sp_AddReservation 'R018', 'CAR010', 'C003', '2025-12-20', '2025-12-25', 'Approved';
SELECT * FROM Reservation WHERE Reservation_ID='R018';
SELECT Car_ID, Status FROM Car WHERE Car_ID='CAR010';SELECT Car_ID, Status FROM Car WHERE Car_ID='CAR010';

CREATE PROCEDURE sp_UpdateCarStatus
    @Car_ID VARCHAR(10),
    @NewStatus VARCHAR(20)
AS
BEGIN
    IF @NewStatus NOT IN ('Available','Reserved','Maintenance')
    BEGIN
        RAISERROR('Invalid status value!', 16, 1);
        RETURN;
    END

    UPDATE Car
    SET Status = @NewStatus
    WHERE Car_ID = @Car_ID;
END;



EXEC sp_UpdateCarStatus 'CAR007', 'Available';
SELECT Car_ID, Status FROM Car WHERE Car_ID='CAR007'; 

CREATE PROCEDURE sp_GetCustomerReservations
    @Customer_ID VARCHAR(10)
AS
BEGIN
    SELECT r.Reservation_ID, r.Car_ID, c.Brand_Name, r.Start_Date, r.End_Date, r.Status
    FROM Reservation r
    JOIN Car c ON r.Car_ID = c.Car_ID
    WHERE r.Customer_ID = @Customer_ID
    ORDER BY r.Start_Date;
END;




EXEC sp_GetCustomerReservations 'C001'; 
CREATE PROCEDURE sp_AddPayment
    @Payment_ID VARCHAR(10),
    @Contract_ID VARCHAR(10),
    @Customer_ID VARCHAR(10),
    @Payment_Method VARCHAR(30)
AS
BEGIN
    IF @Payment_Method NOT IN ('Cash','Card','Online')
    BEGIN
        RAISERROR('Invalid payment method!', 16, 1);
        RETURN;
    END

    INSERT INTO Payment (Payment_ID, Contract_ID, Customer_ID, Payment_Date, Payment_Method)
    VALUES (@Payment_ID, @Contract_ID, @Customer_ID, GETDATE(), @Payment_Method);
END;



EXEC sp_AddPayment 'P016', 'CT003', 'C003', 'Card';
SELECT * FROM Payment WHERE Payment_ID='P016';