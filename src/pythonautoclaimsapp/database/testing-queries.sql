/*

    END RESULT: UPDATE paca.VEHICLES SET VEHICLE_YEAR=2022 VEHICLE_MODEL=Elant'_MODEL=Elantra'  VEHICLE_MAKE=Hyund'_MAKE=Hyundai' 
    EXPECTED RESULT: UPDATE paca.VEHICLES SET VEHICLE_YEAR='2022',VEHICLE_MODEL='Elantra', VEHICLE_MAKE='Hyundai'

*/



DECLARE @stringsplittheory NVARCHAR(MAX)

SET @stringsplittheory = N'{VEHICLE_YEAR:2022,VEHICLE_MODEL:Elantra,VEHICLE_MAKE:Hyundai}'
SET @stringsplittheory = REPLACE(REPLACE(@stringsplittheory,N'{',N''),N'}',N'')

CREATE TABLE mytemptable
(ID INT IDENTITY(1,1),
QUERY NVARCHAR(MAX))

INSERT INTO mytemptable
SELECT REPLACE(value,CHAR(61),'') FROM STRING_SPLIT(@stringsplittheory,',')



/*
    Take 2
*/

DECLARE @count INT = 1,
@myconcat NVARCHAR(MAX),
@updateKeyword NVARCHAR(MAX) = N'UPDATE paca.VEHICLES SET ',
@myval NVARCHAR(MAX),
@processingChar NVARCHAR(MAX)

WHILE @count < 4
BEGIN
SET @myconcat = (
SELECT TOP 1 QUERY
FROM mytemptable
WHERE ID = @count
)

IF (@count = 1)
BEGIN
SET @processingChar = '''' + RIGHT(@myconcat,CHARINDEX(N'=',@myconcat)) + ''''
SET @myval = @updateKeyword + @myconcat
END
	IF(@count <= 3 AND @count <> 1)
	BEGIN
	SET @processingChar = '''' + RIGHT(@myconcat,CHARINDEX(N'=',@myconcat)) + ''''
	SET @myval += ' ' + LEFT(@myconcat,(LEN(@myconcat) - LEN(CHARINDEX(N'=',@myconcat)))) + @processingChar + ' ';
	END
	SET @count += 1;
END
SELECT @myval

--DROP TABLE mytemptable

SELECT * FROM mytemptable

--Another avenue for testing

DECLARE @mytempVal XML = N'<paca><VEHICLE_MAKE>Hyundai</VEHICLE_MAKE><VEHICLE_MODEL>Elantra</VEHICLE_MODEL><VEHICLE_YEAR>2022</VEHICLE_YEAR</paca>'