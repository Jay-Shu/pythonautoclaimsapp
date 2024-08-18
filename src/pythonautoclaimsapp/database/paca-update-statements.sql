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
        2024-08-09: Added AND VEHICLE_VIN = @vehicleVin line for the WHERE clause of the
            Vehicle Update Stored Procedure.
        2024-08-11: Re-design of updateAccount_v1.
		2024-08-14: Full replacement of updateAccounts_v1.
		2024-08-15: Added an additional DECLARE to separate the Inputs from the already existing values.
		2024-08-15: Resolved repetitive logic causing double SET.
		2024-08-16: Updated Variable notes.
		2024-08-16: Added new shell for updateHomes_v1. All future update stored procedures will utilize
			this shell.
		2024-08-18: Shell applied to updateVehicles_v1.
		
    TO DO (Requested):
		N/A - No current modification requests pending.
	
	TO DO (SELF):
		Policies Enumerations. - DONE
		Bundle Enumeration for Car and Home. For non-goal. - DONE
        Incorporation of the STRING_SPLIT() function. This was introduced in MS SQL Server 2016,
            
		
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
		@acctH: Account Honorifics Input.
		@acctFN: Account First Name Input.
		@acctLN: Account Last Name Input.
		@acctSuf: Account Suffix Input.
		@acctStAdd1: Account Street Address 1 Input.
		@acctStAdd2: Account Street Address 2 Input.
		@acctCity: Account City Input.
		@acctState: Account State Input.
		@acctZip: Account ZIP Input.
		@acctPoBox: Account PO Box Input.
		@acctDtSt: Account Date Start Input.
		@acctDtRe: Account Date Renewal Input. This will need revisiting.
		@acctType: Account Type Input.
		@acctH_actual: Account Current Honorifics.
		@acctFN_actual: Account Current First Name.
		@acctLN_actual: Account Current Last Name.
		@acctSuf_actual: Account Current Suffix.
		@acctStAdd1_actual: Account Current Street Address 1.
		@acctStAdd2_actual: Account Current Street Address 2.
		@acctCity_actual: Account Current City.
		@acctState_actual: Account Current State.
		@acctZip_actual: Account Current ZIP.
		@acctPoBox_actual: Account Current PO Box.
		@acctDtSt_actual: Account Current Date Start.
		@acctDtRe_actual: Account Current Date Renewal.
		@acctType_actual: Account Current Type.
		@val: This is a placeholder so that the Query runs. The Value is not utilized for anything else.

		
	Citations:
		1. CREATE PROCEDURE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver16
        2. NO COUNT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver16
        3. ERROR_MESSAGE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/error-message-transact-sql?view=sql-server-ver16
        4. CASE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-ver16
        5. IF...ELSE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16
        6. Tutorial: Signing Stored Procedures With a Certificate, https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-signing-stored-procedures-with-a-certificate?view=sql-server-ver16
        7. Slash Star (Block Comment), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/slash-star-comment-transact-sql?view=sql-server-ver16
        8. STRING_SPLIT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/string-split-transact-sql?view=sql-server-ver16
        9. TRY_CAST (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/try-cast-transact-sql?view=sql-server-ver16
		10. JSON_OBJECT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/json-object-transact-sql?view=sql-server-ver16
    	11. OPENJSON (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/openjson-transact-sql?view=sql-server-ver16
    	12. JSON data in SQL Server, https://learn.microsoft.com/en-us/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver16
		13. DECLARE @local_variable, https://learn.microsoft.com/en-us/sql/t-sql/language-elements/declare-local-variable-transact-sql?view=sql-server-ver16
		14. WHERE (T-SQL), https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql?view=sql-server-ver16
		15. Predicates (T-SQL), https://learn.microsoft.com/en-us/sql/t-sql/queries/predicates?view=sql-server-ver16
		16. Search Condition (T-SQL), https://learn.microsoft.com/en-us/sql/t-sql/queries/search-condition-transact-sql?view=sql-server-ver16

	Author Notes:
		Inspired by my time at Hyland working with Phil Mosher and Brandon Rossin.
		GO Keyword does not require a semi-colon. As it would be redundant.
		BEGIN...END Blocks have been phased out completely for TRY...CATCH and GO.
        BEGIN TRANSACTION...COMMIT TRANSACTION Blocks to be used. As it is intended
            for the application to be running these statements. You MUST immediately
            COMMIT the TRANSACTION following the Statement(s) execution(s). This is
            to avoid erroneously leaving your cursor open.
        STRING_SPLIT() - No longer being considered.

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

CREATE PROCEDURE paca.updateAccounts_v1
@json NVARCHAR(MAX)
AS
SET NOCOUNT ON
/*
-- Test block, kept for historical reason.
SET @json = N'[
  {"ACCOUNT_NUM":"ICA00000003","ACCOUNT_HONORIFICS":"NULL","ACCOUNT_PO_BOX":"123 Easy Street","ACCOUNT_TYPE":"123"}
]';
*/
DECLARE @updStatement NVARCHAR(MAX) = N'UPDATE paca.ACCOUNTS SET'
DECLARE @tempTable TABLE (
	ACCOUNT_NUM	NVARCHAR(11) NOT NULL,
	ACCOUNT_HONORIFICS	NVARCHAR(16) NULL,
	ACCOUNT_FIRST_NAME 	NVARCHAR(128) NULL,
	ACCOUNT_LAST_NAME 	NVARCHAR(128) NULL,
	ACCOUNT_SUFFIX		NVARCHAR(16) NULL,
	ACCOUNT_STREET_ADD_1 NVARCHAR(128) NULL,
	ACCOUNT_STREET_ADD_2 NVARCHAR(128) NULL,
	ACCOUNT_CITY		NVARCHAR(128) NULL,
	ACCOUNT_STATE	NVARCHAR(16) NULL,
	ACCOUNT_ZIP		INT NULL,
	ACCOUNT_PO_BOX	NVARCHAR(128) NULL,
	ACCOUNT_DATE_START	DATETIME NULL,
	ACCOUNT_DATE_RENEWAL DATETIME NULL,
	ACCOUNT_TYPE	NVARCHAR(64) NULL)


INSERT INTO @tempTable
SELECT
	ACCOUNT_NUM,
	ACCOUNT_HONORIFICS,
	ACCOUNT_FIRST_NAME,
	ACCOUNT_LAST_NAME,
	ACCOUNT_SUFFIX,
	ACCOUNT_STREET_ADD_1,
	ACCOUNT_STREET_ADD_2,
	ACCOUNT_CITY,
	ACCOUNT_STATE,
	ACCOUNT_ZIP,
	ACCOUNT_PO_BOX,
	ACCOUNT_DATE_START,
	ACCOUNT_DATE_RENEWAL,
	ACCOUNT_TYPE
FROM OPENJSON(@json) WITH (
    ACCOUNT_NUM NVARCHAR(11) 'strict $.ACCOUNT_NUM',
    ACCOUNT_HONORIFICS NVARCHAR(16) '$.ACCOUNT_HONORIFICS',
    ACCOUNT_FIRST_NAME 	NVARCHAR(128) '$.ACCOUNT_FIRST_NAME',
	  ACCOUNT_LAST_NAME 	NVARCHAR(128) '$.ACCOUNT_LAST_NAME',
	  ACCOUNT_SUFFIX		NVARCHAR(16) '$.ACCOUNT_SUFFIX',
	  ACCOUNT_STREET_ADD_1 NVARCHAR(128) '$.ACCOUNT_STREET_ADD_1',
	  ACCOUNT_STREET_ADD_2 NVARCHAR(128) '$.ACCOUNT_STREET_ADD_2',
	  ACCOUNT_CITY		NVARCHAR(128) '$.ACCOUNT_CITY',
	  ACCOUNT_STATE	NVARCHAR(16) '$.ACCOUNT_STATE',
	  ACCOUNT_ZIP		INT '$.ACCOUNT_ZIP',
	  ACCOUNT_PO_BOX	NVARCHAR(128) '$.ACCOUNT_PO_BOX',
	  ACCOUNT_DATE_START	DATETIME '$.ACCOUNT_DATE_START',
	  ACCOUNT_DATE_RENEWAL DATETIME '$.ACCOUNT_DATE_RENEWAL',
	  ACCOUNT_TYPE	NVARCHAR(64) '$.ACCOUNT_TYPE'
)
;

DECLARE @accountNum NVARCHAR(11) = (SELECT TOP 1 ACCOUNT_NUM FROM @tempTable),
@acctH NVARCHAR(16) = (SELECT TOP 1 ACCOUNT_HONORIFICS FROM @tempTable),
@acctFN NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_FIRST_NAME FROM @tempTable),
@acctLN NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_LAST_NAME FROM @tempTable),
@acctSuf NVARCHAR(16) = (SELECT TOP 1 ACCOUNT_SUFFIX FROM @tempTable),
@acctStAdd1 NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_STREET_ADD_1 FROM @tempTable),
@acctStAdd2 NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_STREET_ADD_2 FROM @tempTable),
@acctCity NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_CITY FROM @tempTable),
@acctState NVARCHAR(16) = (SELECT TOP 1 ACCOUNT_STATE FROM @tempTable),
@acctZip NVARCHAR(5) = (SELECT TOP 1 ACCOUNT_ZIP FROM @tempTable),
@acctPoBox NVARCHAR(64) = (SELECT TOP 1 CAST(ACCOUNT_PO_BOX AS NVARCHAR(64)) FROM @tempTable),
@acctDtSt NVARCHAR(32) = (SELECT TOP 1 ACCOUNT_DATE_START FROM @tempTable),
@acctDtRe NVARCHAR(32) = (SELECT TOP 1 ACCOUNT_DATE_RENEWAL FROM @tempTable),
@acctType NVARCHAR(64) = (SELECT TOP 1 CAST(ACCOUNT_TYPE AS NVARCHAR(64)) FROM @tempTable)

DECLARE @acctH_actual NVARCHAR(16) = (SELECT TOP 1 ACCOUNT_HONORIFICS FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctFN_actual NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_FIRST_NAME FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctLN_actual NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_LAST_NAME FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctSuf_actual NVARCHAR(16) = (SELECT TOP 1 ACCOUNT_SUFFIX FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctStAdd1_actual NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_STREET_ADD_1 FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctStAdd2_actual NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_STREET_ADD_2 FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctCity_actual NVARCHAR(128) = (SELECT TOP 1 ACCOUNT_CITY FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctState_actual NVARCHAR(16) = (SELECT TOP 1 ACCOUNT_STATE FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctZip_actual NVARCHAR(5) = (SELECT TOP 1 ACCOUNT_ZIP FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctPoBox_actual NVARCHAR(64) = (SELECT TOP 1 CAST(ACCOUNT_PO_BOX AS NVARCHAR(64)) FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctDtSt_actual NVARCHAR(32) = (SELECT TOP 1 ACCOUNT_DATE_START FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctDtRe_actual NVARCHAR(32) = (SELECT TOP 1 ACCOUNT_DATE_RENEWAL FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@acctType_actual NVARCHAR(64) = (SELECT TOP 1 CAST(ACCOUNT_TYPE AS NVARCHAR(64)) FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
@val UNIQUEIDENTIFIER = NEWID();

/*
IF (@acctH is null AND @acctH_actual is null)
BEGIN
SET @acctH = N'NULL';
SET @updStatement += N' ACCOUNT_HONORIFICS = '   + @acctH + N' , '
END
*/
/*
Combinations:
	1. IS NULL AND IS NULL. Does not need to be defined as no changes are made.
	2. IS NOT NULL AND IS NULL
	3. IS NOT NULL AND IS NOT NULL
	4. IS NULL AND IS NOT NULL
	5. Intentional Null
*/


-- Account Honorifics
IF (@acctH IS NOT NULL AND @acctH <> N'NULL' AND @acctH_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_HONORIFICS = ' + '''' + @acctH + '''' + N' , '
	END

IF (@acctH = N'NULL' AND @acctH_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_HONORIFICS = NULL , '
	END

IF (@acctH  <> N'NULL' AND @acctH_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_HONORIFICS = '  + ''''  + @acctH + '''' + N' , '
	END

-- Account First Name
IF (@acctFN is not null AND @acctFN <> N'NULL' AND @acctFN_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_FIRST_NAME = ' + '''' + @acctFN + '''' + N' , '
	END

IF (@acctFN = N'NULL' AND @acctFN_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_FIRST_NAME = NULL , '
	END

IF (@acctFN  <> N'NULL' AND @acctFN_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_FIRST_NAME = '  + ''''  + @acctFN + '''' + N' , '
	END

-- Account Last Name
IF (@acctLN IS NOT NULL AND @acctLN <> N'NULL' AND @acctLN_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_LAST_NAME = ' + '''' + @acctLN + '''' + N' , '
	END

IF (@acctLN = N'NULL' AND @acctLN_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_LAST_NAME = NULL , '
	END

IF (@acctLN  <> N'NULL' AND @acctLN_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_LAST_NAME = '  + ''''  + @acctLN + '''' + N' , '
	END

-- Account Suffix
IF (@acctSuf IS NOT NULL AND @acctSuf <> N'NULL' AND @acctSuf_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_SUFFIX = ' + '''' + @acctSuf + '''' + N' , '
	END

IF (@acctSuf = N'NULL' AND @acctSuf_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_SUFFIX = NULL , '
	END

IF (@acctSuf <> N'NULL' AND @acctSuf_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_SUFFIX = '  + ''''  + @acctSuf + '''' + N' , '
	END

-- Account Street Address 1
IF (@acctStAdd1 IS NOT NULL AND @acctStAdd1 <> N'NULL' AND @acctStAdd1_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_1 = ' + '''' + @acctStAdd1 + '''' + N' , '
	END

IF (@acctStAdd1 = N'NULL' AND @acctStAdd1_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_1 = NULL , '
	END

IF (@acctStAdd1 <> N'NULL' AND @acctStAdd1_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_1 = '  + ''''  + @acctStAdd1 + '''' + N' , '
	END

-- Account Street Address 2
IF (@acctStAdd2 IS NOT NULL AND @acctStAdd2 <> N'NULL' AND @acctStAdd2_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_2 = ' + '''' + @acctStAdd2 + '''' + N' , '
	END

IF (@acctStAdd2 = N'Intentional' AND @acctStAdd2_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_2 = NULL , '
	END

IF (@acctStAdd2 <> N'NULL' AND @acctStAdd2_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_2 = '  + ''''  + @acctStAdd2 + '''' + N' , '
	END

-- Account City
IF (@acctCity IS NOT NULL AND @acctCity <> N'NULL' AND @acctCity_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_CITY = ' + '''' + @acctCity + '''' + N' , '
	END

IF (@acctCity = N'NULL' AND @acctCity_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_CITY = NULL , '
	END

IF (@acctCity <> N'NULL' AND @acctCity_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_CITY = '  + ''''  + @acctCity + '''' + N' , '
	END


-- Account State
IF (@acctState IS NOT NULL AND @acctState <> N'NULL' AND @acctState_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_STATE = ' + '''' + @acctState + '''' + N' , '
	END

IF (@acctState = N'NULL' AND @acctState_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_STATE = NULL , '
	END

IF (@acctState <> N'NULL' AND @acctState_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_STATE = '  + ''''  + @acctState + '''' + N' , '
	END


-- Account ZIP
IF (@acctZip IS NOT NULL AND @acctZip <> N'NULL' AND @acctZip_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_ZIP = ' + @acctZip + N' , '
	END

IF (@acctZip = N'NULL' AND @acctZip_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_ZIP = NULL , '
	END

IF (@acctZip  <> N'NULL' AND @acctZip_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_ZIP = '  + @acctZip + N' , '
	END

-- Account PO Box
IF (@acctPoBox IS NOT NULL AND @acctPoBox <> N'NULL' AND @acctPoBox_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_PO_BOX = ' + '''' + @acctPoBox + '''' + N' , '
	END

IF (@acctPoBox = N'NULL' AND @acctPoBox_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_PO_BOX = NULL , '
	END

IF (@acctPoBox <> N'NULL' AND @acctPoBox_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_PO_BOX = ' + ''''  + @acctPoBox + '''' + N' , '
	END

-- Account Date Start
IF (@acctDtSt IS NOT NULL AND @acctDtSt <> N'NULL' AND @acctDtSt_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = ' + '''' + @acctDtSt + '''' + N' , '
	END

IF (@acctDtSt = N'NULL' AND @acctDtSt_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = NULL , '
	END

IF (@acctDtSt <> N'NULL' AND @acctDtSt_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = ' + ''''  + @acctDtSt + '''' + N' , '
	END

-- Account Date Renewal
IF (@acctDtRe IS NOT NULL AND @acctDtRe <> N'NULL' AND @acctDtRe_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = ' + '''' + @acctDtRe + '''' + N' , '
	END

IF (@acctDtRe = N'NULL' AND @acctDtRe_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = NULL , '
	END

IF (@acctDtRe <> N'NULL' AND @acctDtRe_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = ' + ''''  + @acctDtRe + '''' + N' , '
	END

-- Account Type
IF (@acctType IS NOT NULL AND @acctType <> N'NULL' AND @acctType_actual IS NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_TYPE = ' + '''' + @acctType + ''''
	END

IF (@acctType = N'NULL' AND @acctType_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_TYPE = NULL'
	END

IF (@acctType  <> N'NULL' AND @acctType_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' ACCOUNT_TYPE = ' + '''' + @acctType + ''''
	END


IF(RIGHT(@updStatement,2) = N', ')
BEGIN
SET @updStatement = LEFT(@updStatement,LEN(@updStatement) -1) + N' WHERE ACCOUNT_NUM = ' + '''' + @accountNum + '''' + ';';
END
ELSE
BEGIN
SET @updStatement += N' WHERE ACCOUNT_NUM = ' + '''' + @accountNum + '''' + ';';
END

BEGIN TRY
BEGIN TRANSACTION
EXECUTE sp_executesql @updStatement, N'@val NVARCHAR(MAX) OUTPUT',@val OUTPUT
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

EXECUTE paca.getAccounts_v3 @accountNum

RETURN;

GO


CREATE PROCEDURE paca.updateHomes_v1
@json NVARCHAR(MAX)
AS
SET NOCOUNT ON
/*
-- Test block, kept for historical reason.
SET @json = N'[
  {"HOMES_INTENRAL_ID":"HOM00000001","HOMES_ACCOUNT_NUM":"ICA00000002","HOMES_SEC1_PER_PROP":"NULL","HOMES_SEC1_BU_SD":100.00,"HOMES_SEC1_SL":255.00}
]';
*/
DECLARE @updStatement NVARCHAR(MAX) = N'UPDATE paca.HOMES SET'
DECLARE @tempTable TABLE (
	HOMES_INTENRAL_ID NVARCHAR(11) NOT NULL,
	HOMES_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
	HOMES_PREMIUM DECIMAL(10,2) NULL,
	HOMES_ADDRESS NVARCHAR(128) NULL,
	HOMES_SEC1_DW DECIMAL(10,2) NULL,
	HOMES_SEC1_DWEX DECIMAL(10,2) NULL,
	HOMES_SEC1_PER_PROP DECIMAL(10,2) NULL,
	HOMES_SEC1_LOU DECIMAL(10,2) NULL,
	HOMES_SEC1_FD_SC DECIMAL(10,2) NULL,
	HOMES_SEC1_SL DECIMAL(10,2) NULL,
	HOMES_SEC1_BU_SD DECIMAL(12,2) NULL,
	HOMES_SEC2_PL DECIMAL(12,2) NULL,
	HOMES_SEC2_DPO DECIMAL(12,2) NULL,
	HOMES_SEC2_MPO DECIMAL(12,2) NULL)


INSERT INTO @tempTable
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
	HOMES_SEC1_SL,
	HOMES_SEC1_BU_SD,
	HOMES_SEC2_PL,
	HOMES_SEC2_DPO,
	HOMES_SEC2_MPO
FROM OPENJSON(@json) WITH (
    HOMES_INTERNAL_ID NVARCHAR(11) 'strict $.HOMES_INTERNAL_ID',
    HOMES_ACCOUNT_NUM NVARCHAR(11) 'strict $.HOMES_ACCOUNT_NUM',
    HOMES_PREMIUM 	DECIMAL(10,2) '$.HOMES_PREMIUM',
	  HOMES_ADDRESS 	NVARCHAR(128) '$.HOMES_ADDRESS',
	  HOMES_SEC1_DW		DECIMAL(10,2) '$.HOMES_SEC1_DW',
	  HOMES_SEC1_DWEX DECIMAL(10,2) '$.HOMES_SEC1_DWEX',
	  HOMES_SEC1_PER_PROP DECIMAL(10,2) '$.HOMES_SEC1_PER_PROP',
	  HOMES_SEC1_LOU		DECIMAL(10,2) '$.HOMES_SEC1_LOU',
	  HOMES_SEC1_FD_SC	DECIMAL(10,2) '$.HOMES_SEC1_FD_SC',
	  HOMES_SEC1_SL		DECIMAL(10,2) '$.HOMES_SEC1_SL',
	  HOMES_SEC1_BU_SD	DECIMAL(12,2) '$.HOMES_SEC1_BU_SD',
	  HOMES_SEC2_PL	DECIMAL(12,2) '$.HOMES_SEC2_PL',
	  HOMES_SEC2_DPO DECIMAL(12,2) '$.HOMES_SEC2_DPO',
	  HOMES_SEC2_MPO	DECIMAL(12,2) '$.HOMES_SEC2_MPO'
)
;

DECLARE @homeInternalID NVARCHAR(11) = (SELECT TOP 1 HOMES_INTENRAL_ID FROM @tempTable),
@accountNum NVARCHAR(11) = (SELECT TOP 1 HOMES_ACCOUNT_NUM FROM @tempTable),
@homePremium NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_PREMIUM AS NVARCHAR(32)) FROM @tempTable),
@homeAddress NVARCHAR(128) = (SELECT TOP 1 HOMES_ADDRESS FROM @tempTable),
@homeSec1DW NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_DW AS NVARCHAR(32)) FROM @tempTable),
@homeSec1DWEX NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_DWEX AS NVARCHAR(32)) FROM @tempTable),
@homeSec1PerProp NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_PER_PROP AS NVARCHAR(32)) FROM @tempTable),
@homeSec1LOU NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_LOU AS NVARCHAR(32)) FROM @tempTable),
@homeSec1FDSC NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_FD_SC AS NVARCHAR(32)) FROM @tempTable),
@homeSec1SL NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_SL AS NVARCHAR(32)) FROM @tempTable),
@homeSec1BUSD NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_BU_SD AS NVARCHAR(32)) FROM @tempTable),
@homeSec2PL NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC2_PL AS NVARCHAR(32)) FROM @tempTable),
@homeSec2DPO NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC2_DPO AS NVARCHAR(32)) FROM @tempTable),
@homeSec2MPO NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC2_MPO AS NVARCHAR(32)) FROM @tempTable)

DECLARE @homePremium_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_PREMIUM AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeAddress_actual NVARCHAR(128) = (SELECT TOP 1 HOMES_ADDRESS FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec1DW_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_DW AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec1DWEX_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_DWEX AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec1PerProp_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_PER_PROP AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec1LOU_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_LOU AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec1FDSC_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_FD_SC AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec1SL_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_SL AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec1BUSD_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC1_BU_SD AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec2PL_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC2_PL AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec2DPO_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC2_DPO AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@homeSec2MPO_actual NVARCHAR(32) = (SELECT TOP 1 CAST(HOMES_SEC2_MPO AS NVARCHAR(32)) FROM paca.HOMES WHERE HOMES_INTERNAL_ID = @homeInternalID),
@val UNIQUEIDENTIFIER = NEWID();

/*
IF (@acctH is null AND @acctH_actual is null)
BEGIN
SET @acctH = N'NULL';
SET @updStatement += N' ACCOUNT_HONORIFICS = '   + @acctH + N' , '
END
*/
/*
Combinations:
	1. IS NULL AND IS NULL. Does not need to be defined as no changes are made.
	2. IS NOT NULL AND IS NULL
	3. IS NOT NULL AND IS NOT NULL
	4. IS NULL AND IS NOT NULL
	5. Intentional Null
*/


-- Account Honorifics
IF (@homePremium IS NOT NULL AND @homePremium <> N'NULL' AND @homePremium_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_PREMIUM = ' + @homePremium + N' , '
	END

IF (@homePremium = N'NULL' AND @homePremium_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_PREMIUM = NULL , '
	END

IF (@homePremium  <> N'NULL' AND @homePremium_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_PREMIUM = '  + @homePremium + N' , '
	END

-- Account First Name
IF (@homeAddress is not null AND @homeAddress <> N'NULL' AND @homeAddress_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_ADDRESS = ' + '''' + @homeAddress + '''' + N' , '
	END

IF (@homeAddress = N'NULL' AND @homeAddress_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_ADDRESS = NULL , '
	END

IF (@homeAddress  <> N'NULL' AND @homeAddress_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_ADDRESS = '  + ''''  + @homeAddress + '''' + N' , '
	END

-- Account Last Name
IF (@homeSec1DW IS NOT NULL AND @homeSec1DW <> N'NULL' AND @homeSec1DW_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_DW = ' + @homeSec1DW + N' , '
	END

IF (@homeSec1DW = N'NULL' AND @homeSec1DW_actual is not null)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_DW = NULL , '
	END

IF (@homeSec1DW  <> N'NULL' AND @homeSec1DW_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_DW = '   + @homeSec1DW + N' , '
	END

-- Account Suffix
IF (@homeSec1DWEX IS NOT NULL AND @homeSec1DWEX <> N'NULL' AND @acctSuf_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_DWEX = ' + @homeSec1DWEX + N' , '
	END

IF (@homeSec1DWEX = N'NULL' AND @homeSec1DWEX_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_DWEX = NULL , '
	END

IF (@homeSec1DWEX <> N'NULL' AND @homeSec1DWEX_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_DWEX = '  + @homeSec1DWEX + N' , '
	END

-- Account Street Address 1
IF (@homeSec1PerProp IS NOT NULL AND @homeSec1PerProp <> N'NULL' AND @homeSec1PerProp_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_PER_PROP = ' + @homeSec1PerProp + N' , '
	END

IF (@homeSec1PerProp = N'NULL' AND @homeSec1PerProp_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_PER_PROP = NULL , ';
	END

IF (@homeSec1PerProp <> N'NULL' AND @homeSec1PerProp_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_PER_PROP = '  + @homeSec1PerProp + N' , ';
	END

-- Account Street Address 2
IF (@homeSec1LOU IS NOT NULL AND @homeSec1LOU <> N'NULL' AND @homeSec1LOU_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_LOU = ' + @homeSec1LOU + N' , ';
	END

IF (@homeSec1LOU = N'Intentional' AND @homeSec1LOU_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_LOU = NULL , ';
	END

IF (@homeSec1LOU <> N'NULL' AND @homeSec1LOU_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_LOU = '  + @homeSec1LOU + N' , ';
	END

-- Account City
IF (@homeSec1FDSC IS NOT NULL AND @homeSec1FDSC <> N'NULL' AND @homeSec1FDSC_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_FD_SC = ' + @homeSec1FDSC + N' , ';
	END

IF (@homeSec1FDSC = N'NULL' AND @homeSec1FDSC_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_FD_SC = NULL , ';
	END

IF (@homeSec1FDSC <> N'NULL' AND @homeSec1FDSC_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_FD_SC = '  + @homeSec1FDSC + N' , ';
	END


-- Account State
IF (@homeSec1SL IS NOT NULL AND @homeSec1SL <> N'NULL' AND @homeSec1SL_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_SL = ' + @homeSec1SL + N' , ';
	END

IF (@homeSec1SL = N'NULL' AND @homeSec1SL_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_SL = NULL , ';
	END

IF (@homeSec1SL <> N'NULL' AND @homeSec1SL_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_SL = '  + @homeSec1SL + N' , ';
	END


-- Account ZIP
IF (@homeSec1BUSD IS NOT NULL AND @homeSec1BUSD <> N'NULL' AND @acctZip_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_BU_SD = ' + @homeSec1BUSD + N' , ';
	END

IF (@homeSec1BUSD = N'NULL' AND @homeSec1BUSD_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_BU_SD = NULL , ';
	END

IF (@homeSec1BUSD  <> N'NULL' AND @homeSec1BUSD_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_BU_SD = '  + @homeSec1BUSD + N' , ';
	END

-- Account PO Box
IF (@homeSec2PL IS NOT NULL AND @homeSec2PL <> N'NULL' AND @homeSec2PL_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC2_PL = ' + '''' + @homeSec2PL + '''' + N' , '
	END

IF (@homeSec2PL = N'NULL' AND @homeSec2PL_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC2_PL = NULL , '
	END

IF (@homeSec2PL <> N'NULL' AND @homeSec2PL_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC2_PL = ' + ''''  + @homeSec2PL + '''' + N' , '
	END

-- Account Date Start
IF (@homeSec2DPO IS NOT NULL AND @homeSec2DPO <> N'NULL' AND @acctDtSt_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC2_DPO = ' + @homeSec2DPO + N' , '
	END

IF (@homeSec2DPO = N'NULL' AND @homeSec2DPO_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC2_DPO = NULL , '
	END

IF (@homeSec2DPO <> N'NULL' AND @homeSec2DPO_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC2_DPO = '  + @homeSec2DPO + N' , '
	END

-- Account Date Renewal
IF (@homeSec2MPO IS NOT NULL AND @homeSec2MPO <> N'NULL' AND @homeSec2MPO_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC2_MPO = ' + @homeSec2MPO
	END

IF (@homeSec2MPO = N'NULL' AND @homeSec2MPO_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC2_MPO = NULL '
	END

IF (@homeSec2MPO <> N'NULL' AND @homeSec2MPO_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC2_MPO = '  + @homeSec2MPO
	END



IF(RIGHT(@updStatement,2) = N', ')
BEGIN
SET @updStatement = LEFT(@updStatement,LEN(@updStatement) -1) + N' WHERE HOMES_INTERNAL_ID = ' + '''' + @homeInternalID + '''' + ';';
END
ELSE
BEGIN
SET @updStatement += N' WHERE HOMES_INTERNAL_ID = ' + '''' + @homeInternalID + '''' + ';';
END

BEGIN TRY
BEGIN TRANSACTION
EXECUTE sp_executesql @updStatement, N'@val NVARCHAR(MAX) OUTPUT',@val OUTPUT
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

EXECUTE paca.getHomes_v3 @homeInternalID

RETURN;

GO

/*
Update our vehicle
*/

CREATE PROCEDURE updateVehicle_v1
@json NVARCHAR(MAX)
AS
SET NOCOUNT ON
/*
-- Test block, kept for historical reason.
SET @json = N'[
  {"HOMES_INTENRAL_ID":"HOM00000001","HOMES_ACCOUNT_NUM":"ICA00000002","HOMES_SEC1_PER_PROP":"NULL","HOMES_SEC1_BU_SD":100.00,"HOMES_SEC1_SL":255.00}
]';
*/
DECLARE @updStatement NVARCHAR(MAX) = N'UPDATE paca.VEHICLES SET'
DECLARE @tempTable TABLE (
	VEHICLE_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
	VEHICLE_VIN NVARCHAR(32) NOT NULL,
	VEHICLE_YEAR INT NULL,
	VEHICLE_MAKE	NVARCHAR(32) NULL,
	VEHICLE_MODEL	NVARCHAR(65) NULL,
	VEHICLE_PREMIUM	DECIMAL(5,2) NULL,
	VEHICLE_ANNUAL_MILEAGE INT NULL,
	VEHICLE_VEHICLE_USE	NVARCHAR(64) NULL,
	VEHICLE_ADDRESS1_GARAGED NVARCHAR(128) NULL,
	VEHICLE_ADDRESS2_GARAGED NVARCHAR(128) NULL)


INSERT INTO @tempTable
SELECT
	VEHICLE_ACCOUNT_NUM,
	VEHICLE_VIN,
	VEHICLE_YEAR,
	VEHICLE_MAKE,
	VEHICLE_MODEL,
	VEHICLE_PREMIUM,
	VEHICLE_ANNUAL_MILEAGE,
	VEHICLE_VEHICLE_USE,
	VEHICLE_ADDRESS1_GARAGED,
	VEHICLE_ADDRESS2_GARAGED
FROM OPENJSON(@json) WITH (
    VEHICLE_VIN NVARCHAR(32) 'strict $.VEHICLE_VIN',
    VEHICLE_ACCOUNT_NUM NVARCHAR(11) 'strict $.VEHICLE_ACCOUNT_NUM',
    VEHICLE_YEAR 	INT '$.VEHICLE_YEAR',
	  VEHICLE_MAKE 	NVARCHAR(32) '$.VEHICLE_MAKE',
	  VEHICLE_MODEL		NVARCHAR(65) '$.VEHICLE_MODEL',
	  VEHICLE_PREMIUM DECIMAL(5,2) '$.VEHICLE_PREMIUM',
	  VEHICLE_ANNUAL_MILEAGE INT '$.VEHICLE_ANNUAL_MILEAGE',
	  VEHICLE_VEHICLE_USE		NVARCHAR(64) '$.VEHICLE_VEHICLE_USE',
	  VEHICLE_ADDRESS1_GARAGED	NVARCHAR(128) '$.VEHICLE_ADDRESS1_GARAGED',
	  VEHICLE_ADDRESS2_GARAGED	NVARCHAR(128) '$.VEHICLE_ADDRESS2_GARAGED'
)
;

DECLARE
@accountNum NVARCHAR(11) = (SELECT TOP 1 VEHICLE_ACCOUNT_NUM FROM @tempTable),
@vehicleVin NVARCHAR(32) = (SELECT TOP 1 VEHICLE_VIN FROM @tempTable),
@vehicleYear NVARCHAR(128) = (SELECT TOP 1 VEHICLE_YEAR FROM @tempTable),
@vehicleMake NVARCHAR(32) = (SELECT TOP 1 VEHICLE_MAKE FROM @tempTable),
@vehicleModel NVARCHAR(32) = (SELECT TOP 1 VEHICLE_MODEL FROM @tempTable),
@vehiclePremium NVARCHAR(32) = (SELECT TOP 1 CAST(VEHICLE_PREMIUM AS NVARCHAR(32)) FROM @tempTable),
@vehicleAnnualMileage NVARCHAR(32) = (SELECT TOP 1 CAST(VEHICLE_ANNUAL_MILEAGE AS NVARCHAR(32)) FROM @tempTable),
@vehicleVehicleUse NVARCHAR(32) = (SELECT TOP 1 VEHICLE_VEHICLE_USE FROM @tempTable),
@vehicleAddress1Garaged NVARCHAR(32) = (SELECT TOP 1 VEHICLE_ADDRESS1_GARAGED FROM @tempTable),
@vehicleAddress2Garaged NVARCHAR(32) = (SELECT TOP 1 VEHICLE_ADDRESS2_GARAGED FROM @tempTable)

DECLARE
@vehicleVin_actual NVARCHAR(32) = (SELECT TOP 1 VEHICLE_VIN FROM paca.VEHICLES WHERE VEHICLE_VIN = @vehicleVin),
@vehicleYear_actual NVARCHAR(128) = (SELECT TOP 1 VEHICLE_YEAR FROM paca.VEHICLES WHERE VEHICLE_VIN = @vehicleVin),
@vehicleMake_actual NVARCHAR(32) = (SELECT TOP 1 VEHICLE_MAKE FROM paca.VEHICLES WHERE VEHICLE_VIN = @vehicleVin),
@vehicleModel_actual NVARCHAR(32) = (SELECT TOP 1 VEHICLE_MODEL FROM paca.VEHICLES WHERE VEHICLE_VIN = @vehicleVin),
@vehiclePremium_actual NVARCHAR(32) = (SELECT TOP 1 CAST(VEHICLE_PREMIUM AS NVARCHAR(32)) FROM paca.VEHICLES WHERE VEHICLE_VIN = @vehicleVin),
@vehicleAnnualMileage_actual NVARCHAR(32) = (SELECT TOP 1 CAST(VEHICLE_ANNUAL_MILEAGE AS NVARCHAR(32)) FROM paca.VEHICLES WHERE VEHICLE_VIN = @vehicleVin),
@vehicleVehicleUse_actual NVARCHAR(32) = (SELECT TOP 1 VEHICLE_VEHICLE_USE FROM paca.VEHICLES WHERE VEHICLE_VIN = @vehicleVin),
@vehicleAddress1Garaged_actual NVARCHAR(32) = (SELECT TOP 1 VEHICLE_ADDRESS1_GARAGED FROM paca.VEHICLES WHERE VEHICLE_VIN = @vehicleVin),
@vehicleAddress2Garaged_actual NVARCHAR(32) = (SELECT TOP 1 VEHICLE_ADDRESS2_GARAGED FROM paca.VEHICLES WHERE VEHICLE_VIN = @vehicleVin),
@val UNIQUEIDENTIFIER = NEWID();

/*
IF (@acctH is null AND @acctH_actual is null)
BEGIN
SET @acctH = N'NULL';
SET @updStatement += N' ACCOUNT_HONORIFICS = '   + @acctH + N' , '
END
*/
/*
Combinations:
	1. IS NULL AND IS NULL. Does not need to be defined as no changes are made.
	2. IS NOT NULL AND IS NULL
	3. IS NOT NULL AND IS NOT NULL
	4. IS NULL AND IS NOT NULL
	5. Intentional Null
*/


-- Vehicle VIN
IF (@vechicleVin IS NOT NULL AND @vechicleVin <> N'NULL' AND @vechicleVin_actual IS NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_VIN = '+ '''' + @vechicleVin + '''' + N' , '
	END

/*
We cannot have a VEHICLE_VIN as NULL. Therefore, this is not needed.
IF (@vechicleVin = N'NULL' AND @vechicleVin_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_VIN = NULL , '
	END
*/


IF (@vechicleVin  <> N'NULL' AND @vechicleVin_actual IS NOT NULL AND @vehicleVin <> @vechicleVin_actual)
	BEGIN
		SET @updStatement += N' VEHICLE_VIN = ' + ''''  + @vechicleVin + '''' + N' , '
	END

-- Vehicle Year
IF (@vehicleYear is not null AND @vehicleYear <> N'NULL' AND @vehicleYear_actual IS NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_YEAR = ' + @vehicleYear + N' , '
	END

IF (@vehicleYear = N'NULL' AND @vehicleYear_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_YEAR = NULL , '
	END

IF (@vehicleYear  <> N'NULL' AND @vehicleYear_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_YEAR = '  + @vehicleYear + N' , '
	END

-- Vehicle Make
IF (@vehicleMake IS NOT NULL AND @vehicleMake <> N'NULL' AND @vehicleMake_actual IS NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_MAKE = ' + @vehicleMake + N' , '
	END

IF (@vehicleMake = N'NULL' AND @vehicleMake_actual is not null)
	BEGIN
		SET @updStatement += N' VEHICLE_MAKE = NULL , '
	END

IF (@vehicleMake  <> N'NULL' AND @vehicleMake_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_MAKE = ' + ''''  + @vehicleMake + '''' + N' , '
	END

-- Vehicle Model
IF (@vehicleModel IS NOT NULL AND @vehicleModel <> N'NULL' AND @vehicleModel_actual IS NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_MODEL = '+ '''' + @vehicleModel + '''' + N' , '
	END

IF (@vehicleModel = N'NULL' AND @vehicleModel_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_MODEL = NULL , '
	END

IF (@vehicleModel <> N'NULL' AND @vehicleModel_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' VEHICLE_MODEL = ' + ''''  + @vehicleModel + '''' + N' , '
	END

-- Vehicle Premium
IF (@homeSec1PerProp IS NOT NULL AND @homeSec1PerProp <> N'NULL' AND @homeSec1PerProp_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_PER_PROP = ' + @homeSec1PerProp + N' , '
	END

IF (@homeSec1PerProp = N'NULL' AND @homeSec1PerProp_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_PER_PROP = NULL , ';
	END

IF (@homeSec1PerProp <> N'NULL' AND @homeSec1PerProp_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_PER_PROP = '  + @homeSec1PerProp + N' , ';
	END

-- Vehicle Annual Mileage
IF (@homeSec1LOU IS NOT NULL AND @homeSec1LOU <> N'NULL' AND @homeSec1LOU_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_LOU = ' + @homeSec1LOU + N' , ';
	END

IF (@homeSec1LOU = N'Intentional' AND @homeSec1LOU_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_LOU = NULL , ';
	END

IF (@homeSec1LOU <> N'NULL' AND @homeSec1LOU_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_LOU = '  + @homeSec1LOU + N' , ';
	END

-- Vehicle Vehicle Use
IF (@homeSec1FDSC IS NOT NULL AND @homeSec1FDSC <> N'NULL' AND @homeSec1FDSC_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_FD_SC = ' + @homeSec1FDSC + N' , ';
	END

IF (@homeSec1FDSC = N'NULL' AND @homeSec1FDSC_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_FD_SC = NULL , ';
	END

IF (@homeSec1FDSC <> N'NULL' AND @homeSec1FDSC_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_FD_SC = '  + @homeSec1FDSC + N' , ';
	END


-- Vehicle Address 1 Garaged
IF (@homeSec1SL IS NOT NULL AND @homeSec1SL <> N'NULL' AND @homeSec1SL_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_SL = ' + @homeSec1SL + N' , ';
	END

IF (@homeSec1SL = N'NULL' AND @homeSec1SL_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_SL = NULL , ';
	END

IF (@homeSec1SL <> N'NULL' AND @homeSec1SL_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_SL = '  + @homeSec1SL + N' , ';
	END


-- Vehicle Address 2 Garaged
IF (@homeSec1BUSD IS NOT NULL AND @homeSec1BUSD <> N'NULL' AND @acctZip_actual IS NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_BU_SD = ' + @homeSec1BUSD;
	END

IF (@homeSec1BUSD = N'NULL' AND @homeSec1BUSD_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_BU_SD = NULL';
	END

IF (@homeSec1BUSD  <> N'NULL' AND @homeSec1BUSD_actual IS NOT NULL)
	BEGIN
		SET @updStatement += N' HOMES_SEC1_BU_SD = '  + @homeSec1BUSD ;
	END




IF(RIGHT(@updStatement,2) = N', ')
BEGIN
SET @updStatement = LEFT(@updStatement,LEN(@updStatement) -1) + N' WHERE VEHICLE_VIN = ' + '''' + @vehicleVin_actual + '''' + ';';
END
ELSE
BEGIN
SET @updStatement += N' WHERE VEHICLE_VIN = ' + '''' + @vehicleVin_actual + '''' + ';';
END

BEGIN TRY
BEGIN TRANSACTION
EXECUTE sp_executesql @updStatement, N'@val NVARCHAR(MAX) OUTPUT',@val OUTPUT
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

EXECUTE paca.getHomes_v3 @homeInternalID

RETURN;

GO