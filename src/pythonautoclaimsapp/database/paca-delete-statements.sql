/**
	Name of Script: paca-delete-statements.sql
    Author: Jacob Shuster
    Role: Consultant - 1099
    Umbrella Company: N/A
    Creation Date: 2024-08-06
    Script Cost: N/A
    Rate: 100.00 (Based on 2019*)

    Changelog:
        2024-08-07: removeAccount_v1, removeVehicle_v1, removePolicy_v1, removeHome_v1
        2024-08-19: Beginning the process of overhauling to Serialization and Deserialization of JSON.
        2024-08-19: Added SET NOCOUNT ON to all Stored Procedures per Best Practices.
        2024-08-19: Completed overhaul of Stored Procedures.
        2024-10-04: Added Schema to Stored Procedures. Without a Schema they will default to dbo and we need it in paca.
        2025-01-02: POLICY_ID_ACTUAL to POLICIES_ID_ACTUAL which is the correct column name for removePolicy_v1.
		
    TO DO (Requested):
		N/A - No current modification requests pending.
	
	TO DO (SELF):
		Policies Enumerations. - DONE
		Bundle Enumeration for Car and Home. For non-goal. - DONE
		
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
        @variableName: description

		
	Citations:
		    1. CREATE PROCEDURE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver16
        2. NO COUNT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver16
        3. ERROR_MESSAGE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/error-message-transact-sql?view=sql-server-ver16
        4. CASE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-ver16
        5. IF...ELSE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16
        6. Tutorial: Signing Stored Procedures With a Certificate, https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-signing-stored-procedures-with-a-certificate?view=sql-server-ver16
        7. Slash Star (Block Comment), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/slash-star-comment-transact-sql?view=sql-server-ver16

	Author Notes:
		Inspired by my time at Hyland working with Phil Mosher and Brandon Rossin.
		GO Keyword does not require a semi-colon. As it would be redundant.
		BEGIN...END Blocks have been phased out completely for TRY...CATCH and GO.
        BEGIN TRANSACTION...COMMIT TRANSACTION Blocks to be used. As it is intended
            for the application to be running these statements.
      
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

CREATE PROCEDURE paca.removeAccount_v1
@json NVARCHAR(MAX)
AS
SET NOCOUNT ON;
DECLARE @tempTable TABLE (
	ACCOUNT_NUM	NVARCHAR(11) NOT NULL)


INSERT INTO @tempTable
SELECT
	ACCOUNT_NUM
FROM OPENJSON(@json) WITH (
    ACCOUNT_NUM NVARCHAR(11) 'strict $.ACCOUNT_NUM'
)
;

DECLARE @accountNum NVARCHAR(11) = (SELECT TOP 1 ACCOUNT_NUM FROM @tempTable);

BEGIN TRY
BEGIN TRANSACTION
DELETE FROM paca.ACCOUNTS
WHERE ACCOUNT_NUM = @accountNum
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

RETURN;

GO

CREATE PROCEDURE paca.removeHome_v1
@json NVARCHAR(MAX)
/*
  For the next release this needs to be updated to use a unique identifier
*/
AS
SET NOCOUNT ON;
DECLARE @tempTable TABLE (
	ACCOUNT_NUM	NVARCHAR(11) NOT NULL,
  HOMES_INTERNAL_ID NVARCHAR(11) NOT NULL)

INSERT INTO @tempTable
SELECT
	ACCOUNT_NUM,
  HOMES_INTERNAL_ID
FROM OPENJSON(@json) WITH (
    ACCOUNT_NUM NVARCHAR(11) 'strict $.ACCOUNT_NUM',
    HOMES_INTERNAL_ID NVARCHAR(11) 'strict $.HOMES_INTERNAL_ID'
);

DECLARE @accountNum NVARCHAR(11) = (SELECT TOP 1 ACCOUNT_NUM FROM @tempTable);
DECLARE @homesIntID NVARCHAR(11) = (SELECT TOP 1 HOMES_INTERNAL_ID FROM @tempTable WHERE ACCOUNT_NUM = @accountNum)

BEGIN TRY
BEGIN TRANSACTION
DELETE FROM paca.HOMES
WHERE HOMES_ACCOUNT_NUM = @accountNum AND HOMES_INTERNAL_ID = @homesIntID
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

RETURN;

GO

CREATE PROCEDURE paca.removeVehicle_v1
@json NVARCHAR(MAX)
AS
SET NOCOUNT ON;
DECLARE @tempTable TABLE (
	ACCOUNT_NUM	NVARCHAR(11) NOT NULL,
  VEHICLE_VIN NVARCHAR(32) NOT NULL)

INSERT INTO @tempTable
SELECT
	ACCOUNT_NUM,
  VEHICLE_VIN
FROM OPENJSON(@json) WITH (
    ACCOUNT_NUM NVARCHAR(11) 'strict $.ACCOUNT_NUM',
    VEHICLE_VIN NVARCHAR(32) 'strict $.VEHICLE_VIN'
);

DECLARE @accountNum NVARCHAR(11) = (SELECT TOP 1 ACCOUNT_NUM FROM @tempTable);
DECLARE @vehicleVin NVARCHAR(11) = (SELECT TOP 1 VEHICLE_VIN FROM @tempTable WHERE ACCOUNT_NUM = @accountNum)

BEGIN TRY
BEGIN TRANSACTION
DELETE FROM paca.VEHICLES
WHERE VEHICLE_ACCOUNT_NUM = @accountNum
AND VEHICLE_VIN = @vehicleVin
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

RETURN;

GO

CREATE PROCEDURE paca.removePolicy_v1
@json NVARCHAR(MAX)
AS
SET NOCOUNT ON;
DECLARE @tempTable TABLE (
	POLICY_ID_ACTUAL	NVARCHAR(11) NOT NULL)

INSERT INTO @tempTable
SELECT
	POLICY_ID_ACTUAL
FROM OPENJSON(@json) WITH (
    POLICY_ID_ACTUAL NVARCHAR(11) 'strict $.POLICY_ID_ACTUAL'
);

DECLARE @policyIdActual NVARCHAR(11) = (SELECT TOP 1 POLICY_ID_ACTUAL FROM @tempTable);

BEGIN TRY
BEGIN TRANSACTION
DELETE FROM paca.POLICIES
WHERE POLICIES_ID_ACTUAL = @policyIdActual
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

RETURN;

GO


CREATE PROCEDURE paca.removeVehicleCoverages_v1
@json NVARCHAR(MAX)
AS
SET NOCOUNT ON;
DECLARE @tempTable TABLE (
	VEHICLES_COVERAGE_ACCOUNT_NUM	NVARCHAR(11) NOT NULL)
-- Consider giving VEHICLE COVERAGES unique Identifiers
INSERT INTO @tempTable
SELECT
	VEHICLES_COVERAGE_ACCOUNT_NUM
FROM OPENJSON(@json) WITH (
    VEHICLES_COVERAGE_ACCOUNT_NUM NVARCHAR(11) 'strict $.VEHICLES_COVERAGE_ACCOUNT_NUM'
);

DECLARE @vehicleCoverageAccountNum NVARCHAR(11) = (SELECT TOP 1 VEHICLES_COVERAGE_ACCOUNT_NUM FROM @tempTable);

BEGIN TRY
BEGIN TRANSACTION
DELETE FROM paca.VEHICLE_COVERAGES
WHERE VEHICLES_COVERAGE_ACCOUNT_NUM = @vehicleCoverageAccountNum
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

RETURN;

GO

CREATE PROCEDURE paca.removeVehicleClaims_v1
@json NVARCHAR(11)
AS
SET NOCOUNT ON;
DECLARE @tempTable TABLE (
	VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER	NVARCHAR(11) NOT NULL,
  VEHICLE_CLAIMS_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
  VEHICLE_CLAIMS_VEHICLE_VIN NVARCHAR(32) NOT NULL)
-- Consider giving VEHICLE COVERAGES unique Identifiers
INSERT INTO @tempTable
SELECT
	VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER,
  VEHICLE_CLAIMS_ACCOUNT_NUM,
  VEHICLE_CLAIMS_VEHICLE_VIN
FROM OPENJSON(@json) WITH (
    VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER NVARCHAR(11) 'strict $.VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER',
    VEHICLE_CLAIMS_ACCOUNT_NUM NVARCHAR(11) 'strict $.VEHICLE_CLAIMS_ACCOUNT_NUM',
    VEHICLE_CLAIMS_VEHICLE_VIN NVARCHAR(32) 'strict $.VEHICLE_CLAIMS_VEHICLE_VIN'
);

DECLARE @vehicleClaimsIntCaseNumber NVARCHAR(11) = (SELECT TOP 1 VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER FROM @tempTable);

DECLARE @vehicleClaimsAccountNum NVARCHAR(11) = (SELECT TOP 1 VEHICLE_CLAIMS_ACCOUNT_NUM FROM @tempTable WHERE VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER = @vehicleClaimsIntCaseNumber),
@vehicleClaimsVehicleVin NVARCHAR(32) = (SELECT TOP 1 VEHICLE_CLAIMS_VEHICLE_VIN FROM @tempTable WHERE VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER = @vehicleClaimsIntCaseNumber)

BEGIN TRY
BEGIN TRANSACTION
DELETE FROM paca.VEHICLE_CLAIMS
WHERE VEHICLE_CLAIMS_ACCOUNT_NUM = @vehicleClaimsAccountNum
AND VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER = @vehicleClaimsIntCaseNumber
AND VEHICLE_CLAIMS_VEHICLE_VIN = @vehicleClaimsVehicleVin
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

RETURN;

GO