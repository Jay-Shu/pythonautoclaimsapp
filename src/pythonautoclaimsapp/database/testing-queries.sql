/*

    END RESULT: UPDATE paca.VEHICLES SET VEHICLE_YEAR=2022 VEHICLE_MODEL=Elant'_MODEL=Elantra'  VEHICLE_MAKE=Hyund'_MAKE=Hyundai' 
    EXPECTED RESULT: UPDATE paca.VEHICLES SET VEHICLE_YEAR='2022',VEHICLE_MODEL='Elantra', VEHICLE_MAKE='Hyundai'
	https://stackoverflow.com/questions/11010453/get-everything-after-and-before-certain-character-in-sql-server
*/



DECLARE @stringsplittheory NVARCHAR(MAX)

SET @stringsplittheory = N'{VEHICLE_YEAR:2022,VEHICLE_MAKE:Hyundai,VEHICLE_MODEL:Elantra}'
SET @stringsplittheory = REPLACE(REPLACE(@stringsplittheory,N'{',N''),N'}',N'')


IF(OBJECT_ID(N'mytemptable',N'U')) is null
BEGIN
CREATE TABLE mytemptable
(ID INT IDENTITY(1,1),
QUERY NVARCHAR(MAX));
END
ELSE
BEGIN
DROP TABLE mytemptable;
CREATE TABLE mytemptable
(ID INT IDENTITY(1,1),
QUERY NVARCHAR(MAX));
END

INSERT INTO mytemptable
SELECT REPLACE(value,CHAR(58),CHAR(61)) FROM STRING_SPLIT(@stringsplittheory,',')



/*
    Take 2
*/

DECLARE @count INT = 1,
@myconcat NVARCHAR(MAX),
@updateKeyword NVARCHAR(MAX) = N'UPDATE paca.VEHICLES SET ',
@myval NVARCHAR(MAX),
@processingChar NVARCHAR(MAX),
@processingChar2 NVARCHAR(MAX),
@secondaryCounter INT = 1

WHILE @count < 4
BEGIN
SET @myconcat = (
SELECT TOP 1 QUERY
FROM mytemptable
WHERE ID = @count
)

/*

SUBSTRING() will be needed here instead of RIGHT()

*/

IF (@count = 1)
BEGIN
SET @processingChar = (SELECT SUBSTRING(@myval,LEN(LEFT(@myval, CHARINDEX ('=', @myval))) + 1,LEN(@myval) - LEN(LEFT(@myval,CHARINDEX ('=', @myval))) - LEN(RIGHT(@myval, LEN(@myval) - CHARINDEX ('=', @myval))) - 1));
--SET @processingChar2 = SUBSTRING(@myconcat,CHARINDEX('=',@myconcat),1);
--SET @processingChar = '''' + RIGHT(@myconcat,CHARINDEX(N'=',@myconcat)+1) + ''''
SET @myval = @updateKeyword + @processingChar 
--+ @processingChar2

SELECT @myval
SELECT @processingChar2

--Not producing the desired effect.
SET @secondaryCounter = (SELECT COUNT(QUERY) FROM mytemptable) --We need to track the rows.
--SELECT @stringSplit,ROW_NUMBER() OVER(ORDER BY ID ASC) as ROW#

END
	IF(@count <= @secondaryCounter AND @count <> 1) --We only need to count to 3
	BEGIN
	--SET @processingChar = '''' + @myconcat + ''''
	SET @myval += ' ' + @myconcat + ' ';
	--SET @processingChar = '''' + RIGHT(@myconcat,CHARINDEX(N'=',@myconcat)+1) + ''''
	--SET @myval += ' ' + LEFT(@myconcat,(LEN(@myconcat) - LEN(CHARINDEX(N'=',@myconcat)))) + @processingChar + ' ';
	END
	SET @count += 1;
END
SELECT @myval

--DROP TABLE mytemptable

SELECT * FROM mytemptable

--Another avenue for testing

--DECLARE @mytempVal XML = N'<paca><VEHICLE_MAKE>Hyundai</VEHICLE_MAKE><VEHICLE_MODEL>Elantra</VEHICLE_MODEL><VEHICLE_YEAR>2022</VEHICLE_YEAR></paca>'

/*
SELECT SUBSTRING(@myval, LEN(LEFT(@myval, CHARINDEX ('=', @myval))) + 1, LEN(@myval) - LEN(LEFT(@myval, 
    CHARINDEX ('=', @myval))) - LEN(RIGHT(@myval, LEN(@myval) - CHARINDEX ('=', @myval))) - 1);
*/
SELECT SUBSTRING(@myval,LEN(LEFT(@myval, CHARINDEX ('=', @myval))) + 1,LEN(@myval) - LEN(LEFT(@myval,CHARINDEX ('=', @myval))) - LEN(RIGHT(@myval, LEN(@myval) - CHARINDEX ('=', @myval))) - 1);

SELECT LEN(LEFT(@myval, CHARINDEX ('=', @myval))) + 1
SELECT LEN(@myval) - LEN(LEFT(@myval,CHARINDEX ('=', @myval)))
-- - LEN(RIGHT(@myval, LEN(@myval) - CHARINDEX ('=', @myval)))