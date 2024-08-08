/**
	Name of Script: paca-queue-statements.sql
    Author: Jacob Shuster
    Role: Consultant - 1099
    Umbrella Company: N/A
    Creation Date: 2024-08-02
    Script Cost: N/A
    Rate: 100.00 (Based on 2019*)

    Changelog:
        2024-07-31: Created getAccounts_v1 for retrieving accounts in general.
        2024-07-31: Migrated to proper location for Git.
        2024-08-01: Created getAccounts_v2 for adding the Where clause for Searching.
          i.e. Starts-with and Ends-With effectively (N'%' + @variableName and @variableName N'%').
        2024-08-01: Created getAccounts_v3 and getAccounts_v4.
		

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
        @intent; Enumerations as follows:
          1 = Basic
            no "like" used only "=",
          2 = Search for the first name with ends-with.
          3 = Search for the first name with starts-with.
          4 = Search for the last name ends-with.
          5 = Search for the last name starts-with.
          Not including past this, as it should be within the logic for Python. Creating a v3 for additional flexibility.
		
	Citations:
		1. CREATE PROCEDURE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver16
    2. NO COUNT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver16
    3. ERROR_MESSAGE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/error-message-transact-sql?view=sql-server-ver16
    4. CREATE_QUEUE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-queue-transact-sql?view=sql-server-ver16
    5. CREATE_ENDPOINT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-endpoint-transact-sql?view=sql-server-ver16
    6. CASE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-ver16
    7. IF...ELSE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16

	Author Notes:
		Inspired by my time at Hyland working with Phil Mosher and Brandon Rossin.
		GO Keyword does not require a semi-colon. As it would be redundant.
		BEGIN...END Blocks have been phased out completely for TRY...CATCH and GO.
        BEGIN TRANSACTION...COMMIT TRANSACTION Blocks to be used. As it is intended
            for the application to be running these statements.
    These will need to be transitioned into Stored Procedures. This is necessary for
      exposing an external Web service.

**/

USE PACA;

BEGIN TRY
CREATE QUEUE paca.getAccounts_v1
   WITH 
   STATUS = ON,
   RETENTION = OFF ,
   ACTIVATION (
		STATUS = ON,
		PROCEDURE_NAME = paca.getAccounts_v1 ,
		MAX_QUEUE_READERS = 16384, 
		EXECUTE AS SELF),
   POISON_MESSAGE_HANDLING (STATUS = ON) 
   ON [Paca_FG1]
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