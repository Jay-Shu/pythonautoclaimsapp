/**
	Name of Script: paca-select-statements.sql
    Author: Jacob Shuster
    Role: Consultant - 1099
    Umbrella Company: N/A
    Creation Date: 2024-07-30
    Script Cost: N/A
    Rate: 100.00 (Based on 2019*)

    Changelog:
        2024-08-02: Staging for Certificates to be added to Stored Procedures
          per best practices. (Researching further).
        2024-08-05: Reseolved Syntax issues with Stored Procedures.
        2024-08-05: Remove USE clause, because CREATE PROCEDURE (T-SQL)
          does not allow for statements above it.
        2024-08-17: Updated a mispelled column name and updated accordingly within PythonAutoClaimsApp.sql
        2024-08-18: Fixed spelling errors and updated SELECT STATEMENTS of Homes Stored Procedcure v3 to use
          HOMES_INTERNAL_ID. This was necessary to prevent updates/deletes for hitting beyond their intended
          target.

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
        @firstName First Name of the Account Holder.
        @lastName Last Name of the Account Holder.
        @intent: Our mode of searching; 1 = Equal to for First Name and Last Name,
          2 = First Name Ends With and Last Name Equal To.
          3 = First Name Starts With and Last Name Equal To.
          4 = Last Name Ends  With and First Name Equal To.
          5 = Last Name Starts With and First Name Equal To.
          Contains is not being considered at this time. The table will be full scans due to their small size regardless of the Index.
        @accountNum: Account Number of the Client Account.
        @homeAddress: Home Address of the Insured Home.

		
	Citations:
		1. CREATE PROCEDURE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver16
    2. NO COUNT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver16
    3. ERROR_MESSAGE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/error-message-transact-sql?view=sql-server-ver16
    4. CREATE_QUEUE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-queue-transact-sql?view=sql-server-ver16
    5. CREATE_ENDPOINT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-endpoint-transact-sql?view=sql-server-ver16
    6. CASE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-ver16
    7. IF...ELSE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16
    8. Tutorial: Signing Stored Procedures With a Certificate, https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-signing-stored-procedures-with-a-certificate?view=sql-server-ver16
    9. Slash Star (Block Comment), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/slash-star-comment-transact-sql?view=sql-server-ver16

	Author Notes:
		Inspired by my time at Hyland working with Phil Mosher and Brandon Rossin.
		GO Keyword does not require a semi-colon. As it would be redundant.
		BEGIN...END Blocks have been phased out completely for TRY...CATCH and GO.
        BEGIN TRANSACTION...COMMIT TRANSACTION Blocks to be used. As it is intended
            for the application to be running these statements.
    These will need to be transitioned into Stored Procedures. This is necessary for
      exposing an external Web service.

**/

--USE PACA

/*
  We need to create a signing certificate for our Stored Procedures.
  Also, HTTP Endpoints are going to be phased out in the long-term
  it is recommended AGAINST using such Endpoints.
  
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

*/


-- We need our basic query for grabbing accounts without the WHERE Clause.
CREATE PROCEDURE paca.getAccounts_v1
as
SET NOCOUNT ON
BEGIN TRY
SELECT ACCOUNT_CITY,
ACCOUNT_DATE_RENEWAL,
ACCOUNT_DATE_START,
ACCOUNT_FIRST_NAME,
ACCOUNT_HONORIFICS,
ACCOUNT_ID,
ACCOUNT_LAST_NAME,
ACCOUNT_NUM,
ACCOUNT_PO_BOX,
ACCOUNT_STATE,
ACCOUNT_STREET_ADD_1,
ACCOUNT_STREET_ADD_2,
ACCOUNT_SUFFIX,
ACCOUNT_TYPE,
ACCOUNT_ZIP
FROM paca.ACCOUNTS
END TRY
BEGIN CATCH
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

CREATE PROCEDURE paca.getAccounts_v2
/*
  Intended to use First Name and Last Name.
  This is without the usage of like within the
  WHERE Clause.
*/

@firstName NVARCHAR(64),
@lastName NVARCHAR(64),
@intent INT
AS
SET NOCOUNT ON
BEGIN TRY
  IF @intent = 1
BEGIN
SELECT ACCOUNT_CITY,
ACCOUNT_DATE_RENEWAL,
ACCOUNT_DATE_START,
ACCOUNT_FIRST_NAME,
ACCOUNT_HONORIFICS,
ACCOUNT_ID,
ACCOUNT_LAST_NAME,
ACCOUNT_NUM,
ACCOUNT_PO_BOX,
ACCOUNT_STATE,
ACCOUNT_STREET_ADD_1,
ACCOUNT_STREET_ADD_2,
ACCOUNT_SUFFIX,
ACCOUNT_TYPE,
ACCOUNT_ZIP
FROM paca.ACCOUNTS
WHERE ACCOUNT_FIRST_NAME = @firstName
AND ACCOUNT_LAST_NAME = @lastName
END
ELSE
IF @intent = 2
 BEGIN
SELECT ACCOUNT_CITY,
ACCOUNT_DATE_RENEWAL,
ACCOUNT_DATE_START,
ACCOUNT_FIRST_NAME,
ACCOUNT_HONORIFICS,
ACCOUNT_ID,
ACCOUNT_LAST_NAME,
ACCOUNT_NUM,
ACCOUNT_PO_BOX,
ACCOUNT_STATE,
ACCOUNT_STREET_ADD_1,
ACCOUNT_STREET_ADD_2,
ACCOUNT_SUFFIX,
ACCOUNT_TYPE,
ACCOUNT_ZIP
FROM paca.ACCOUNTS
WHERE ACCOUNT_FIRST_NAME like N'%' + @firstName
AND ACCOUNT_LAST_NAME = @lastName
END
ELSE
IF @intent = 3
BEGIN 
SELECT ACCOUNT_CITY,
ACCOUNT_DATE_RENEWAL,
ACCOUNT_DATE_START,
ACCOUNT_FIRST_NAME,
ACCOUNT_HONORIFICS,
ACCOUNT_ID,
ACCOUNT_LAST_NAME,
ACCOUNT_NUM,
ACCOUNT_PO_BOX,
ACCOUNT_STATE,
ACCOUNT_STREET_ADD_1,
ACCOUNT_STREET_ADD_2,
ACCOUNT_SUFFIX,
ACCOUNT_TYPE,
ACCOUNT_ZIP
FROM paca.ACCOUNTS
WHERE ACCOUNT_FIRST_NAME like @firstName + N'%'
AND ACCOUNT_LAST_NAME = @lastName
END
ELSE
IF @intent = 4
BEGIN
SELECT ACCOUNT_CITY,
ACCOUNT_DATE_RENEWAL,
ACCOUNT_DATE_START,
ACCOUNT_FIRST_NAME,
ACCOUNT_HONORIFICS,
ACCOUNT_ID,
ACCOUNT_LAST_NAME,
ACCOUNT_NUM,
ACCOUNT_PO_BOX,
ACCOUNT_STATE,
ACCOUNT_STREET_ADD_1,
ACCOUNT_STREET_ADD_2,
ACCOUNT_SUFFIX,
ACCOUNT_TYPE,
ACCOUNT_ZIP
FROM paca.ACCOUNTS
WHERE ACCOUNT_FIRST_NAME = @firstName
AND ACCOUNT_LAST_NAME like N'%' + @lastName
END
ELSE
IF @intent = 5
BEGIN
SELECT ACCOUNT_CITY,
ACCOUNT_DATE_RENEWAL,
ACCOUNT_DATE_START,
ACCOUNT_FIRST_NAME,
ACCOUNT_HONORIFICS,
ACCOUNT_ID,
ACCOUNT_LAST_NAME,
ACCOUNT_NUM,
ACCOUNT_PO_BOX,
ACCOUNT_STATE,
ACCOUNT_STREET_ADD_1,
ACCOUNT_STREET_ADD_2,
ACCOUNT_SUFFIX,
ACCOUNT_TYPE,
ACCOUNT_ZIP
FROM paca.ACCOUNTS
WHERE ACCOUNT_FIRST_NAME = @firstName
AND ACCOUNT_LAST_NAME like @lastName + N'%'
END
END TRY
BEGIN CATCH
SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH

GO

CREATE PROCEDURE paca.getAccounts_v3
@accountNum NVARCHAR(11)
AS
BEGIN TRY
SELECT ACCOUNT_CITY,
ACCOUNT_DATE_RENEWAL,
ACCOUNT_DATE_START,
ACCOUNT_FIRST_NAME,
ACCOUNT_HONORIFICS,
ACCOUNT_ID,
ACCOUNT_LAST_NAME,
ACCOUNT_NUM,
ACCOUNT_PO_BOX,
ACCOUNT_STATE,
ACCOUNT_STREET_ADD_1,
ACCOUNT_STREET_ADD_2,
ACCOUNT_SUFFIX,
ACCOUNT_TYPE,
ACCOUNT_ZIP
FROM paca.ACCOUNTS
WHERE ACCOUNT_NUM = @accountNum
END TRY
BEGIN CATCH
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

CREATE PROCEDURE paca.getAccounts_v4
/*
  This is for displaying the Vehicles with a specific account.
*/
@accountNum NVARCHAR(11)
AS
BEGIN TRY
SELECT a.ACCOUNT_CITY,
a.ACCOUNT_DATE_RENEWAL,
a.ACCOUNT_DATE_START,
a.ACCOUNT_FIRST_NAME,
a.ACCOUNT_HONORIFICS,
a.ACCOUNT_ID,
a.ACCOUNT_LAST_NAME,
a.ACCOUNT_NUM,
a.ACCOUNT_PO_BOX,
a.ACCOUNT_STATE,
a.ACCOUNT_STREET_ADD_1,
a.ACCOUNT_STREET_ADD_2,
a.ACCOUNT_SUFFIX,
a.ACCOUNT_TYPE,
a.ACCOUNT_ZIP,
v.VEHICLE_YEAR,
v.VEHICLE_MAKE,
v.VEHICLE_MODEL,
v.VEHICLE_ADDRESS1_GARAGED,
v.VEHICLE_ADDRESS2_GARAGED,
v.VEHICLE_VEHICLE_USE,
v.VEHICLE_ANNUAL_MILEAGE,
v.VEHICLE_VIN
FROM paca.ACCOUNTS a
INNER JOIN paca.VEHICLES v on v.VEHICLE_ACCOUNT_NUM = a.ACCOUNT_NUM
WHERE ACCOUNT_NUM = @accountNum
END TRY
BEGIN CATCH
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

CREATE PROCEDURE paca.getAccounts_v5
/*
  This is for displaying the Homes with a specific account.
*/
@accountNum NVARCHAR(11)
AS
BEGIN TRY
SELECT a.ACCOUNT_CITY,
a.ACCOUNT_DATE_RENEWAL,
a.ACCOUNT_DATE_START,
a.ACCOUNT_FIRST_NAME,
a.ACCOUNT_HONORIFICS,
a.ACCOUNT_ID,
a.ACCOUNT_LAST_NAME,
a.ACCOUNT_NUM,
a.ACCOUNT_PO_BOX,
a.ACCOUNT_STATE,
a.ACCOUNT_STREET_ADD_1,
a.ACCOUNT_STREET_ADD_2,
a.ACCOUNT_SUFFIX,
a.ACCOUNT_TYPE,
a.ACCOUNT_ZIP,
h.HOMES_INTERNAL_ID,
h.HOMES_ADDRESS,
h.HOMES_PREMIUM,
h.HOMES_ADDRESS,
h.HOMES_SEC1_DW,
h.HOMES_SEC1_DWEX,
h.HOMES_SEC1_PER_PROP,
h.HOMES_SEC1_LOU,
h.HOMES_SEC1_FD_SC,
h.HOMES_SEC1_SI,
h.HOMES_SEC1_BU_SD,
h.HOMES_SEC2_PL,
h.HOMES_SEC2_DPO,
h.HOMES_SEC2_MPO
FROM paca.ACCOUNTS a
INNER JOIN paca.HOMES h on h.HOMES_ACCOUNT_NUM = a.ACCOUNT_NUM
WHERE ACCOUNT_NUM = @accountNum
END TRY
BEGIN CATCH
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

CREATE PROCEDURE paca.getHomes_v1
AS
BEGIN TRY
SELECT
HOMES_INTERNAL_ID,
HOMES_ACCOUNT_NUM,
HOMES_PREMIUM,
HOMES_ADDRESS,
HOMES_SEC1_DW,
HOMES_SEC1_DWEX,
HOMES_SEC1_PER_PROP,
HOMES_SEC1_LOU,
HOMES_SEC1_FD_SC,
HOMES_SEC1_SI,
HOMES_SEC1_BU_SD,
HOMES_SEC2_PL,
HOMES_SEC2_DPO,
HOMES_SEC2_MPO
FROM paca.HOMES
END TRY
BEGIN CATCH
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

CREATE PROCEDURE paca.getHomes_v2
@accountNum NVARCHAR(11)
AS
BEGIN TRY
SELECT
HOMES_INTERNAL_ID,
HOMES_ACCOUNT_NUM,
HOMES_PREMIUM,
HOMES_ADDRESS,
HOMES_SEC1_DW,
HOMES_SEC1_DWEX,
HOMES_SEC1_PER_PROP,
HOMES_SEC1_LOU,
HOMES_SEC1_FD_SC,
HOMES_SEC1_SI,
HOMES_SEC1_BU_SD,
HOMES_SEC2_PL,
HOMES_SEC2_DPO,
HOMES_SEC2_MPO
FROM paca.HOMES
WHERE HOMES_ACCOUNT_NUM = @accountNum
END TRY
BEGIN CATCH
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

CREATE PROCEDURE paca.getHomes_v3
@homeInternalID NVARCHAR(11)
AS
BEGIN TRY
SELECT
HOMES_INTERNAL_ID,
HOMES_ACCOUNT_NUM,
HOMES_PREMIUM,
HOMES_ADDRESS,
HOMES_SEC1_DW,
HOMES_SEC1_DWEX,
HOMES_SEC1_PER_PROP,
HOMES_SEC1_LOU,
HOMES_SEC1_FD_SC,
HOMES_SEC1_SI,
HOMES_SEC1_BU_SD,
HOMES_SEC2_PL,
HOMES_SEC2_DPO,
HOMES_SEC2_MPO
FROM paca.HOMES
WHERE HOMES_INTERNAL_ID = @homeInternalID
END TRY
BEGIN CATCH
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