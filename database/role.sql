-- Login for the database (SQL Server authentication)
CREATE LOGIN RentalAdmin WITH PASSWORD = 'Admin@123';
CREATE LOGIN RentalAgentLogin WITH PASSWORD = 'Agent@123';
CREATE LOGIN FinanceLogin WITH PASSWORD = 'Finance@123';

-- Create database users linked to logins
USE YourDatabaseName;

CREATE USER RentalAdminUser FOR LOGIN RentalAdmin;
CREATE USER RentalAgentUser FOR LOGIN RentalAgentLogin;
CREATE USER FinanceUser FOR LOGIN FinanceLogin;

-- Create custom roles
CREATE ROLE AdminRole;
CREATE ROLE AgentRole;
CREATE ROLE FinanceRole;

-- Assign users to roles
EXEC sp_addrolemember 'AdminRole', 'RentalAdminUser';
EXEC sp_addrolemember 'AgentRole', 'RentalAgentUser';
EXEC sp_addrolemember 'FinanceRole', 'FinanceUser';

AdminRole: Full access
GRANT SELECT, INSERT, UPDATE, DELETE ON Customer TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Customer_Contact TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Car TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Reservation TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Employee TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Employee_Contact TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Contract TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Payment TO AdminRole;

GRANT EXECUTE ON sp_AddReservation TO AdminRole;
GRANT EXECUTE ON sp_UpdateCarStatus TO AdminRole;
GRANT EXECUTE ON sp_GetCustomerReservations TO AdminRole;
GRANT EXECUTE ON sp_AddPayment TO AdminRole;

AgentRole: Limited access (only reservations and cars)
GRANT SELECT, INSERT, UPDATE ON Reservation TO AgentRole;
GRANT SELECT ON Car TO AgentRole;
GRANT EXECUTE ON sp_AddReservation TO AgentRole;
GRANT EXECUTE ON sp_GetCustomerReservations TO AgentRole;

FinanceRole: Only payment access
GRANT SELECT, INSERT ON Payment TO FinanceRole;
GRANT EXECUTE ON sp_AddPayment TO FinanceRole;
-- Example: Remove UPDATE access from FinanceRole
REVOKE UPDATE ON Payment FROM FinanceRole;

⿥ Optional: Deny Sensitive Actions
-- Deny deletion of customers to FinanceRole
DENY DELETE ON Customer TO FinanceRole;

Switch user context to test permissions:

EXECUTE AS USER = 'RentalAgentUser';
-- Try inserting a new reservation (should succeed)
INSERT INTO Reservation (Reservation_ID, Car_ID, Customer_ID, Start_Date, End_Date, Reservation_Date, Status)
VALUES ('R019','CAR011','C005','2025-12-20','2025-12-25', GETDATE(),'Approved');

-- Try deleting a car (should fail)
DELETE FROM Car WHERE Car_ID='CAR005';
REVERT;