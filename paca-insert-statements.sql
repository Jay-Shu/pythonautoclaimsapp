/**
	Name of Script: paca-insert-statements.sql
    Author: Jacob Shuster
    Role: Consultant - 1099
    Umbrella Company: N/A
    Creation Date: 2024-08-04
    Script Cost: N/A
    Rate: 100.00 (Based on 2019*)

    Changelog:
        2024-08-06: Removed citations that were no longer applicable.
		
    TO DO (Requested):
		N/A - No current modification requests pending.
	
	TO DO (SELF):
		Policies Enumerations. - DONE
		Bundle Enumeration for Car and Home. For non-goal. - DONE
    Plan for additional tables; such as CLAIMS
		
    DISCLAIMER:
        After receipt, this Script is "as-is". Additional modifications past the base are at 100.00 per hour.
        This script is intended to setup your initial Python Auto Claims App.
    
    Non-Billable Items:
        Notes.
        
    Accessing the below variables is @nameOfVariable. The variable will ONLY be accessible within the bounds of the GO
		Paramater. This is because each batch is committed before the next can complete.

    WARNING: DO NOT MODIFY SCRIPT WITHOUT CONSULTING THE CREATOR FIRST. AS SOME CHANGES MAY PREVENT THE SCRIPT FROM
		EXECUTING PROPERLY.

    Scalar Variables:
        @acctHonorifics: Account Holder's Honorofics. Null by default.
        @acctFirstName: Account Holder's First Name.
        @acctLastName: Account Holder's Last Name.
        @acctSuffix: Account Holder's Suffix. Null by default.
        @acctStreetAdd1: Account Holder's Address Line 1.
        @acctStreetAdd2: Account Holder's Address Line 2.
        @acctCity: Account Holder's City.
        @acctState: Account Holder's State.
        @acctZip: Account Holder's Zip Code.
        @acctPOBox: Account Holder's PO Box.
        @acctDateStart: Account Holder's Account Inception Date.
        @acctType: Account Holder's Account Type.
        @vehicleAcctNum: Account Number associated with this Vehicle.
        @vehicleVin: VIN Number of the Vehicle.
        @vehicleYear: Year of the Vehicle.
        @vehicleMake: Make of the Vehicle.
        @vehicleModel: Model of the Vehicle.
        @vehiclePremium: Premium cost for the Vehicle.
        @vehicleAnnualMileage: Annual Mileage estimate of the Vehicle.
        @vehicleVehicleUse: Vehicle use cases.
        @vehicleAddress1Garaged: Vehicle Physical Location. Where it is housed at when not in operation.
        @vehicleAddress2Garaged: Vehicle Physical Location 2. Where it is housed at when not in operation if not a house. Null by default.
		
	Citations:
		1. CREATE PROCEDURE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver16
    2. NO COUNT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver16
    3. ERROR_MESSAGE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/error-message-transact-sql?view=sql-server-ver16
    4. CASE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-ver16
    5. IF...ELSE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16
    6. Tutorial: Signing Stored Procedures With a Certificate, https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-signing-stored-procedures-with-a-certificate?view=sql-server-ver16

	Author Notes:
		Inspired by my time at Hyland working with Phil Mosher and Brandon Rossin.
		GO Keyword does not require a semi-colon. As it would be redundant.
		BEGIN...END Blocks have been phased out completely for TRY...CATCH and GO.
        BEGIN TRANSACTION...COMMIT TRANSACTION Blocks to be used. As it is intended
            for the application to be running these statements.
    These will need to be transitioned into Stored Procedures. This is necessary for
      exposing an external Web service.
    SET NOCOUNT ON is used to lessen the output to the MS SQL Server Logs.
    It is recommended that it ALWAYS follows the AS Clause, and before
      any other lines of code.

  BEST PRACTICES OF STORED PROCEDURES:
    Use the SET NOCOUNT ON statement as the first statement in the body of the procedure. That is, place it just after the AS keyword. This turns off messages that SQL Server sends back to the client after any SELECT, INSERT, UPDATE, MERGE, and DELETE statements are executed. This keeps the output generated to a minimum for clarity. There is no measurable performance benefit however on today's hardware. For information, see SET NOCOUNT (Transact-SQL).
    Use schema names when creating or referencing database objects in the procedure. It takes less processing time for the Database Engine to resolve object names if it doesn't have to search multiple schemas. It also prevents permission and access problems caused by a user's default schema being assigned when objects are created without specifying the schema.
    Avoid wrapping functions around columns specified in the WHERE and JOIN clauses. Doing so makes the columns non-deterministic and prevents the query processor from using indexes.
    Avoid using scalar functions in SELECT statements that return many rows of data. Because the scalar function must be applied to every row, the resulting behavior is like row-based processing and degrades performance.
    Avoid the use of SELECT *. Instead, specify the required column names. This can prevent some Database Engine errors that stop procedure execution. For example, a SELECT * statement that returns data from a 12 column table and then inserts that data into a 12 column temporary table succeeds until the number or order of columns in either table is changed.
    Avoid processing or returning too much data. Narrow the results as early as possible in the procedure code so that any subsequent operations performed by the procedure are done using the smallest data set possible. Send just the essential data to the client application. It is more efficient than sending extra data across the network and forcing the client application to work through unnecessarily large result sets.
    Use explicit transactions by using BEGIN/COMMIT TRANSACTION and keep transactions as short as possible. Longer transactions mean longer record locking and a greater potential for deadlocking.
    Use the Transact-SQL TRY...CATCH feature for error handling inside a procedure. TRY...CATCH can encapsulate an entire block of Transact-SQL statements. This not only creates less performance overhead, it also makes error reporting more accurate with significantly less programming.
    Use the DEFAULT keyword on all table columns that are referenced by CREATE TABLE or ALTER TABLE Transact-SQL statements in the body of the procedure. This prevents passing NULL to columns that don't allow null values.
    Use NULL or NOT NULL for each column in a temporary table. The ANSI_DFLT_ON and ANSI_DFLT_OFF options control the way the Database Engine assigns the NULL or NOT NULL attributes to columns when these attributes aren't specified in a CREATE TABLE or ALTER TABLE statement. If a connection executes a procedure with different settings for these options than the connection that created the procedure, the columns of the table created for the second connection can have different nullability and exhibit different behavior. If NULL or NOT NULL is explicitly stated for each column, the temporary tables are created by using the same nullability for all connections that execute the procedure.
    Use modification statements that convert nulls and include logic that eliminates rows with null values from queries. Be aware that in Transact-SQL, NULL isn't an empty or "nothing" value. It is a placeholder for an unknown value and can cause unexpected behavior, especially when querying for result sets or using AGGREGATE functions.
    Use the UNION ALL operator instead of the UNION or OR operators, unless there is a specific need for distinct values. The UNION ALL operator requires less processing overhead because duplicates aren't filtered out of the result set.
**/

--USE PACA

--Creation of a new account
CREATE PROCEDURE addAccount_v1
@acctHonorifics NVARCHAR(16),
@acctFirstName NVARCHAR(128),
@acctLastName NVARCHAR(128),
@acctSuffix NVARCHAR(16),
@acctStreetAdd1 NVARCHAR(128),
@acctStreetAdd2 NVARCHAR(128),
@acctCity NVARCHAR(128),
@acctState NVARCHAR(16),
@acctZip INT,
@acctPOBox NVARCHAR(128),
@acctDateStart DATETIME,
--@acctDateRenewal DATETIME, Not needed. Because this is a calculated value.
@acctType NVARCHAR(64)
AS

/*
ACCOUNT_HONORIFICS	NVARCHAR(16) NULL,
ACCOUNT_FIRST_NAME 	NVARCHAR(128) NOT NULL,
ACCOUNT_LAST_NAME 	NVARCHAR(128) NOT NULL,
ACCOUNT_SUFFIX		NVARCHAR(16) NULL,
ACCOUNT_STREET_ADD_1 NVARCHAR(128) NOT NULL,
ACCOUNT_STREET_ADD_2 NVARCHAR(128) NULL,
ACCOUNT_CITY		NVARCHAR(128) NOT NULL,
ACCOUNT_STATE	NVARCHAR(16) NOT NULL,
ACCOUNT_ZIP		INT NOT NULL,
ACCOUNT_PO_BOX	NVARCHAR(128) NULL,
ACCOUNT_DATE_START	DATETIME NOT NULL,
ACCOUNT_DATE_RENEWAL DATETIME NOT NULL,
ACCOUNT_TYPE NVARCHAR(64)
*/

BEGIN TRY
BEGIN TRANSACTION
INSERT INTO ACCOUNTS VALUES (@acctHonorifics,@acctFirstName,@acctLastName,@acctSuffix,@acctStreetAdd1,@acctStreetAdd2,@acctCity,@acctState,@acctZip,@acctPOBox,@acctDateStart,DATEADD(YY,1,@acctDateStart),@acctType)
COMMIT TRANSACTION
END TRY
BEGIN CATCH
SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH

RETURN;

GO

CREATE PROCEDURE addVehicle_v1
@vehicleAcctNum NVARCHAR(11),
@vehicleVin NVARCHAR(32),
@vehicleYear DATETIME,
@vehicleMake NVARCHAR(32),
@vehicleModel NVARCHAR(65),
@vehiclePremium DECIMAL(5,2),
@vehicleAnnualMileage INT,
@vehicleVehicleUse NVARCHAR(64),
@vehicleAddress1Garaged NVARCHAR(128),
@vehicleAddress2Garaged NVARCHAR(128)
AS
SET NOCOUNT ON
/*

VEHICLE_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
VEHICLE_VIN NVARCHAR(32) NOT NULL,
VEHICLE_YEAR DATETIME NOT NULL,
VEHICLE_MAKE	NVARCHAR(32) NOT NULL,
VEHICLE_MODEL	NVARCHAR(65) NOT NULL,
VEHICLE_PREMIUM	DECIMAL(5,2) NOT NULL,
VEHICLE_ANNUAL_MILEAGE INT NULL,
VEHICLE_VEHICLE_USE	NVARCHAR(64) NOT NULL,
VEHICLE_ADDRESS1_GARAGED NVARCHAR(128) NOT NULL,
VEHICLE_ADDRESS2_GARAGED NVARCHAR(128) NULL

*/
BEGIN TRY
BEGIN TRANSACTION
  BEGIN TRY
  INSERT INTO VEHICLES VALUES (@vehicleAcctNum,
@vehicleVin,
@vehicleYear,
@vehicleMake,
@vehicleModel,
@vehiclePremium,
@vehicleAnnualMileage,
@vehicleVehicleUse,
@vehicleAddress1Garaged,
@vehicleAddress2Garaged)
  COMMIT TRANSACTION
  END TRY
  BEGIN CATCH
  ROLLBACK TRANSACTION
    SELECT 
     ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage;
  END CATCH
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
  SELECT 
    ERROR_NUMBER() AS ErrorNumber
   ,ERROR_SEVERITY() AS ErrorSeverity
   ,ERROR_STATE() AS ErrorState
   ,ERROR_PROCEDURE() AS ErrorProcedure
   ,ERROR_LINE() AS ErrorLine
   ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
RETURN;

GO