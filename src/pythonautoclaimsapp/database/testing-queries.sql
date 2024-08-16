/*
	CHARINDEX CANNOT LOCATE CHAR(61) OR CHAR(58).

	Scrapped previous design. This design works.



  Citations:
    1. JSON_OBJECT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/json-object-transact-sql?view=sql-server-ver16
    2. OPENJSON (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/openjson-transact-sql?view=sql-server-ver16
    3. JSON data in SQL Server, https://learn.microsoft.com/en-us/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver16
	4. DECLARE @local_variable, https://learn.microsoft.com/en-us/sql/t-sql/language-elements/declare-local-variable-transact-sql?view=sql-server-ver16
	5. WHERE (T-SQL), https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql?view=sql-server-ver16
	6. Predicates (T-SQL), https://learn.microsoft.com/en-us/sql/t-sql/queries/predicates?view=sql-server-ver16
	7. Search Condition (T-SQL), https://learn.microsoft.com/en-us/sql/t-sql/queries/search-condition-transact-sql?view=sql-server-ver16
*/

CREATE PROCEDURE updateAccounts_v1
@json NVARCHAR(MAX)
AS
SET NOCOUNT ON

/*
SET @json = N'[
  {"ACCOUNT_NUM":"ICA00000003","ACCOUNT_HONORIFICS":"Mr.","ACCOUNT_PO_BOX":"123 Easy Street","ACCOUNT_TYPE":"123"}
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
@acctType NVARCHAR(64) = (SELECT TOP 1 CAST(ACCOUNT_TYPE AS NVARCHAR(64)) FROM @tempTable),
@acctH_actual NVARCHAR(16) = (SELECT TOP 1 ACCOUNT_HONORIFICS FROM paca.ACCOUNTS WHERE ACCOUNT_NUM = @accountNum),
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
	1. IS NULL AND IS NULL
	2. IS NOT NULL AND IS NULL
	3. IS NOT NULL AND IS NOT NULL
	4. IS NULL AND IS NOT NULL
	5. Intentional Null
*/


-- Account Honorifics
IF (@acctH is not null AND @acctH_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_HONORIFICS = ' + '''' + @acctH + '''' + N' , '
	END

IF (@acctH = N'Intentional' AND @acctH_actual is not null)
	BEGIN
		SET @acctH = N'NULL'
		SET @updStatement += N' ACCOUNT_HONORIFICS = '  + @acctH + N' , '
	END

IF (@acctH is not null AND @acctH_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_HONORIFICS = '  + ''''  + @acctH + '''' + N' , '
	END
-- Account First Name
IF (@acctFN is not null AND @acctFN_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_FIRST_NAME = ' + '''' + @acctFN + '''' + N' , '
	END

IF (@acctFN = N'Intentional' AND @acctFN_actual is not null)
	BEGIN
		SET @acctFN = N'NULL'
		SET @updStatement += N' ACCOUNT_FIRST_NAME = '  + @acctFN + N' , '
	END

IF (@acctFN is not null AND @acctFN_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_FIRST_NAME = '  + ''''  + @acctFN + '''' + N' , '
	END

-- Account Last Name
IF (@acctLN is not null AND @acctLN_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_LAST_NAME = ' + '''' + @acctLN + '''' + N' , '
	END

IF (@acctLN = N'Intentional' AND @acctLN_actual is not null)
	BEGIN
		SET @acctLN = N'NULL'
		SET @updStatement += N' ACCOUNT_LAST_NAME = '  + @acctLN + N' , '
	END

IF (@acctLN is not null AND @acctLN_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_LAST_NAME = '  + ''''  + @acctLN + '''' + N' , '
	END

-- Account Suffix
IF (@acctSuf is not null AND @acctSuf_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_SUFFIX = ' + '''' + @acctSuf + '''' + N' , '
	END

IF (@acctSuf = N'Intentional' AND @acctSuf_actual is not null)
	BEGIN
		SET @acctSuf = N'NULL'
		SET @updStatement += N' ACCOUNT_SUFFIX = '  + @acctSuf + N' , '
	END

IF (@acctSuf is not null AND @acctSuf_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_SUFFIX = '  + ''''  + @acctSuf + '''' + N' , '
	END

-- Account Street Address 1
IF (@acctStAdd1 is not null AND @acctStAdd1_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_1 = ' + '''' + @acctStAdd1 + '''' + N' , '
	END

IF (@acctStAdd1 = N'Intentional' AND @acctStAdd1_actual is not null)
	BEGIN
		SET @acctStAdd1 = N'NULL'
		SET @updStatement += N' ACCOUNT_STREET_ADD_1 = '  + @acctStAdd1 + N' , '
	END

IF (@acctStAdd1 is not null AND @acctStAdd1_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_1 = '  + ''''  + @acctStAdd1 + '''' + N' , '
	END

-- Account Street Address 2
IF (@acctStAdd2 is not null AND @acctStAdd2_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_2 = ' + '''' + @acctStAdd2 + '''' + N' , '
	END

IF (@acctStAdd2 = N'Intentional' AND @acctStAdd2_actual is not null)
	BEGIN
		SET @acctStAdd2 = N'NULL'
		SET @updStatement += N' ACCOUNT_STREET_ADD_2 = '  + @acctStAdd2 + N' , '
	END

IF (@acctStAdd2 is not null AND @acctStAdd2_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_STREET_ADD_2 = '  + ''''  + @acctStAdd2 + '''' + N' , '
	END

-- Account City
IF (@acctCity is not null AND @acctCity_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_CITY = ' + '''' + @acctCity + '''' + N' , '
	END

IF (@acctCity = N'Intentional' AND @acctCity_actual is not null)
	BEGIN
		SET @acctCity = N'NULL'
		SET @updStatement += N' ACCOUNT_CITY = '  + @acctCity + N' , '
	END

IF (@acctCity is not null AND @acctCity_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_CITY = '  + ''''  + @acctCity + '''' + N' , '
	END


-- Account State
IF (@acctState is not null AND @acctState_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_STATE = ' + '''' + @acctState + '''' + N' , '
	END

IF (@acctState = N'Intentional' AND @acctState_actual is not null)
	BEGIN
		SET @acctState = N'NULL'
		SET @updStatement += N' ACCOUNT_STATE = '  + @acctState + N' , '
	END

IF (@acctState is not null AND @acctState_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_STATE = '  + ''''  + @acctState + '''' + N' , '
	END


-- Account ZIP
IF (@acctZip is not null AND @acctZip_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_ZIP = ' + @acctZip + N' , '
	END

IF (@acctZip = N'Intentional' AND @acctZip_actual is not null)
	BEGIN
		SET @acctZip = N'NULL'
		SET @updStatement += N' ACCOUNT_ZIP = '  + @acctZip + N' , '
	END

IF (@acctZip is not null AND @acctZip_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_ZIP = '  + @acctZip + N' , '
	END

-- Account PO Box
IF (@acctPoBox is not null AND @acctPoBox_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_PO_BOX = ' + '''' + @acctPoBox + '''' + N' , '
	END

IF (@acctPoBox = N'Intentional' AND @acctPoBox_actual is not null)
	BEGIN
		SET @acctPoBox = N'NULL'
		SET @updStatement += N' ACCOUNT_PO_BOX = ' + ''''  + @acctPoBox + '''' + N' , '
	END

IF (@acctPoBox is not null AND @acctPoBox_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_PO_BOX = ' + ''''  + @acctPoBox + '''' + N' , '
	END

-- Account Date Start
IF (@acctDtSt is not null AND @acctDtSt_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = ' + '''' + @acctDtSt + '''' + N' , '
	END

IF (@acctDtSt = N'Intentional' AND @acctDtSt_actual is not null)
	BEGIN
		SET @acctDtSt = N'NULL'
		SET @updStatement += N' ACCOUNT_DATE_START = ' + ''''  + @acctDtSt + '''' + N' , '
	END

IF (@acctDtSt is not null AND @acctDtSt_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = ' + ''''  + @acctDtSt + '''' + N' , '
	END

-- Account Date Renewal
IF (@acctDtRe is not null AND @acctDtRe_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = ' + '''' + @acctDtRe + '''' + N' , '
	END

IF (@acctDtRe = N'Intentional' AND @acctDtRe_actual is not null)
	BEGIN
		SET @acctDtRe = N'NULL'
		SET @updStatement += N' ACCOUNT_DATE_START = ' + ''''  + @acctDtRe + '''' + N' , '
	END

IF (@acctDtRe is not null AND @acctDtRe_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_DATE_START = ' + ''''  + @acctDtRe + '''' + N' , '
	END

-- Account Type
IF (@acctType is not null AND @acctType_actual is null)
	BEGIN
		SET @updStatement += N' ACCOUNT_TYPE = ' + '''' + @acctType + ''''
	END

IF (@acctType = N'Intentional' AND @acctType_actual is not null)
	BEGIN
		SET @acctType = N'NULL'
		SET @updStatement += N' ACCOUNT_TYPE = ' + '''' + @acctType + ''''
	END

IF (@acctType is not null AND @acctType_actual is not null)
	BEGIN
		SET @updStatement += N' ACCOUNT_TYPE = ' + '''' + @acctType + ''''
	END


IF(RIGHT(@updStatement,2) = N', ')
BEGIN
SET @updStatement = LEFT(@updStatement,LEN(@updStatement) -1) + N' WHERE ACCOUNT_NUM = ' + '''' + @accountNum + ''''
END
ELSE
BEGIN
SET @updStatement += N' WHERE ACCOUNT_NUM = ' + '''' + @accountNum + ''''
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