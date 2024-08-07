/**
	Name of Script: paca-update-statements.sql
    Author: Jacob Shuster
    Role: Consultant - 1099
    Umbrella Company: N/A
    Creation Date: 2024-08-04
    Script Cost: N/A
    Rate: 100.00 (Based on 2019*)

    Changelog:
        2024-08-02: Staging for Certificates to be added to Stored Procedures
          per best practices.
        2024-08-05: Removed USE Clause.
        2024-08-05: Resolve Syntax errors.
        2024-08-05: Addeed BEGIN...END Transaction (T-SQL) blocks.
        2024-08-05: IF...ELSE (T-SQL), replaced the USE Clauses.
        2024-08-06: Added Homes Update Statements.
        2024-08-06: Removed Default set of Citations that were not applicable.
        2024-08-06: Added missing Schema for any applicable Stored Procedures.
		
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
        @accountNum: Account Number of the Client Account.
        @accountItemToUpdate: What we are needing to update in the given row. Possible Values are the column names themselves.
            Any value provided outside of this will be handled on the Python end.
        @accountItemVal: The value actual we are setting the column to.

		
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
    These will need to be transitioned into Stored Procedures. This is necessary for
      exposing an external Web service.

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

CREATE PROCEDURE paca.updateAccount_v1
@accountNum NVARCHAR(11),
@accountItemToUpdate NVARCHAR(MAX),
@accountItemVal NVARCHAR(128)
AS
SET NOCOUNT ON
BEGIN TRY

/*

@accountNum: This is the Account Number Associated with the Client's Account.
@accountItemToUpdate: This is the Item we are updating with the Account
    itself. Vehicles and Homes will not be updated here.
@accountItemVal: This is the Value Actual we are using to update the Account.

*/

IF @accountItemToUpdate = N'ACCOUNT_HONORIFICS'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_HONORIFICS = CAST(@accountItemVal AS NVARCHAR(16))
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

IF @accountItemToUpdate = N'ACCOUNT_FIRST_NAME'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_FIRST_NAME = CAST(@accountItemVal AS NVARCHAR(128))
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

IF @accountItemToUpdate = N'ACCOUNT_LAST_NAME'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_LAST_NAME = CAST(@accountItemVal AS NVARCHAR(128))
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

IF @accountItemToUpdate = N'ACCOUNT_SUFFIX'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_SUFFIX = CAST(@accountItemVal AS NVARCHAR(16))
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

IF @accountItemToUpdate = N'ACCOUNT_STREET_ADD_1'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_STREET_ADD_1 = CAST(@accountItemVal AS NVARCHAR(128))
        WHERE ACCOUNT_NUM = @accountNum
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

IF @accountItemToUpdate = N'ACCOUNT_STREET_ADD_2'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_STREET_ADD_2 = CAST(@accountItemVal AS NVARCHAR(128))
        WHERE ACCOUNT_NUM = @accountNum
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

IF @accountItemToUpdate = N'ACCOUNT_CITY'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_CITY = CAST(@accountItemVal AS NVARCHAR(128))
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

IF @accountItemToUpdate = N'ACCOUNT_STATE'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_STATE = CAST(@accountItemVal AS NVARCHAR(16))
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

IF @accountItemToUpdate = N'ACCOUNT_ZIP'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_ZIP = CAST(@accountItemVal AS INT)
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

IF @accountItemToUpdate = N'ACCOUNT_PO_BOX'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_PO_BOX = CAST(@accountItemVal AS NVARCHAR(128))
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

IF @accountItemToUpdate = N'ACCOUNT_DATE_START'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_DATE_START = CAST(@accountItemVal AS DATETIME), ACCOUNT_DATE_RENEWAL = DATEADD(YY,1,CAST(@accountItemVal AS DATETIME))
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

IF @accountItemToUpdate = N'ACCOUNT_DATE_RENEWAL'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_DATE_RENEWAL = CAST(@accountItemVal AS DATETIME)
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

IF @accountItemToUpdate = N'ACCOUNT_TYPE'
    BEGIN TRY
    BEGIN TRANSACTION
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_TYPE = CAST(@accountItemVal AS NVARCHAR(64))
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
END TRY
BEGIN CATCH
-- We need to Rollback our transaction if it did not work.
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

CREATE PROCEDURE paca.updateHome_v1
@accountNum NVARCHAR(11),
@homeItemToUpdate NVARCHAR(MAX),
@homeItemVal NVARCHAR(128)
AS
SET NOCOUNT ON
BEGIN TRY
BEGIN TRANSACTION
/*
HOMES_PREMIUM DECIMAL(10,2) NOT NULL,
	HOMES_ADDRESS NVARCHAR(128) NOT NULL,
	HOMES_SEC1_DW DECIMAL(10,2) NULL,
	HOMES_SEC1_DWEX DECIMAL(10,2) NULL,
	HOMES_SEC1_PER_PROP DECIMAL(10,2) NULL,
	HOMES_SEC1_LOU DECIMAL(10,2) NULL,
	HOMES_SEC1_FD_SC DECIMAL(10,2) NULL,
	HOMES_SEC1_SI DECIMAL(10,2) NULL,
	HOMES_SEC1_BU_SD DECIMAL(12,2) NULL,
	HOMES_SEC2_PL DECIMAL(12,2) NULL,
	HOMES_SEC2_DPO DECIMAL(12,2) NULL,
	HOMES_SEC2_MPO DECIMAL(12,2) NULL,
*/
IF (@homeItemToUpdate = N'HOMES_PREMIUM')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_PREMIUM = CAST(@homeItemVal AS DECIMAL(10,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_ADDRESS')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_ADDRESS = CAST(@homeItemVal AS NVARCHAR(128))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC1_DW')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC1_DW = CAST(@homeItemVal AS DECIMAL(10,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC1_DWEX')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC1_DWEX = CAST(@homeItemVal AS DECIMAL(10,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC1_PER_PROP')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC1_PER_PROP = CAST(@homeItemVal AS DECIMAL(10,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC1_LOU')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC1_LOU = CAST(@homeItemVal AS DECIMAL(10,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC1_FD_SC')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC1_FD_SC = CAST(@homeItemVal AS DECIMAL(10,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC1_SI')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC1_SI = CAST(@homeItemVal AS DECIMAL(10,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC1_BU_SD')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC1_BU_SD = CAST(@homeItemVal AS DECIMAL(12,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC2_PL')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC2_PL = CAST(@homeItemVal AS DECIMAL(12,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC2_DPO')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC2_DPO = CAST(@homeItemVal AS DECIMAL(12,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END

IF (@homeItemToUpdate= N'HOMES_SEC2_MPO')
BEGIN
    UPDATE paca.HOMES
    SET HOMES_SEC2_MPO = CAST(@homeItemVal AS DECIMAL(12,2))
    WHERE HOMES_ACCOUNT_NUM = @accountNum
END


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

GO