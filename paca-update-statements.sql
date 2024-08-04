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
        @name : Description
		
	Citations:
		1. CREATE PROCEDURE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver16
        2. NO COUNT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver16
        3. ERROR_MESSAGE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/error-message-transact-sql?view=sql-server-ver16
        4. CREATE_QUEUE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-queue-transact-sql?view=sql-server-ver16
        5. CREATE_ENDPOINT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-endpoint-transact-sql?view=sql-server-ver16
        6. CASE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-ver16
        7. IF...ELSE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16
        8. Tutorial: Signing Stored Procedures With a Certificate, https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-signing-stored-procedures-with-a-certificate?view=sql-server-ver16

	Author Notes:
		Inspired by my time at Hyland working with Phil Mosher and Brandon Rossin.
		GO Keyword does not require a semi-colon. As it would be redundant.
		BEGIN...END Blocks have been phased out completely for TRY...CATCH and GO.
        BEGIN TRANSACTION...COMMIT TRANSACTION Blocks to be used. As it is intended
            for the application to be running these statements.
    These will need to be transitioned into Stored Procedures. This is necessary for
      exposing an external Web service.

**/

USE PACA

CREATE PROCEDURE updateAccount_v1
@accountNum NVARCHAR(11),
@accountItemToUpdate NVARCHAR(MAX),
@accountItemVal NVARCHAR(128)
AS
BEGIN TRY
BEGIN TRANSACTION
/*

@accountNum: This is the Account Number Associated with the Client's Account.
@accountItemToUpdate: This is the Item we are updating with the Account
    itself. Vehicles and Homes will not be updated here.
@accountItemVal: This is the Value Actual we are using to update the Account.
*/

CASE
    WHEN @accountItemToUpdate = N'ACCOUNT_HONORIFICS'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_HONORIFICS = CAST(@accountItemVal AS NVARCHAR(16))
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
    WHEN @accountItemToUpdate = N'ACCOUNT_FIRST_NAME'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_FIRST_NAME = CAST(@accountItemVal AS NVARCHAR(128))
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
    WHEN @accountItemToUpdate = N'ACCOUNT_LAST_NAME'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_LAST_NAME = CAST(@accountItemVal AS NVARCHAR(128))
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
    WHEN @accountItemToUpdate = N'ACCOUNT_SUFFIX'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_SUFFIX = CAST(@accountItemVal AS NVARCHAR(16))
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
    WHEN @accountItemToUpdate = N'ACCOUNT_STREET_ADD_1'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_STREET_ADD_1 = CAST(@accountItemVal AS NVARCHAR(128))
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
    WHEN @accountItemToUpdate = N'ACCOUNT_STREET_ADD_2'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_STREET_ADD_2 = CAST(@accountItemVal AS NVARCHAR(128))
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
    WHEN @accountItemToUpdate = N'ACCOUNT_CITY'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_CITY = CAST(@accountItemVal AS NVARCHAR(128))
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
    WHEN @accountItemToUpdate = N'ACCOUNT_STATE'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_STATE = CAST(@accountItemVal AS NVARCHAR(16))
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
    WHEN @accountItemToUpdate = N'ACCOUNT_ZIP'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_ZIP = CAST(@accountItemVal AS INT)
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
    WHEN @accountItemToUpdate = N'ACCOUNT_PO_BOX'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_PO_BOX = CAST(@accountItemVal AS NVARCHAR(128))
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
    WHEN @accountItemToUpdate = N'ACCOUNT_DATE_START'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_DATE_START = CAST(@accountItemVal AS DATETIME)
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
    WHEN @accountItemToUpdate = N'ACCOUNT_DATE_RENEWAL'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_DATE_RENEWAL = CAST(@accountItemVal AS DATETIME)
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
    WHEN @accountItemToUpdate = N'ACCOUNT_TYPE'
    THEN
    BEGIN TRY
        UPDATE paca.ACCOUNTS
        SET ACCOUNT_TYPE = CAST(@accountItemVal AS INT)
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

COMMIT TRANSACTION
END TRY
BEGIN CATCH
-- We need to Rollback our transaction if it did not work.
ROLLBACK TRANSACTION
SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH