/**
	Name of Script: PythonAutoClaimsApp.sql
    Author: Jacob Shuster
    Role: Consultant - 1099
    Umbrella Company: N/A
    Creation Date: 2024-07-17
    Script Cost: N/A
    Rate: 100.00 (Based on 2019*)

	GitHub: https://github.com/Jay-Shu/pythonautoclaimsapp.git

    Changelog:
        2024-07-18: Added the addition for Partitions.
		2024-07-18: Commented out Partitions for future usage, and if we have the time.
		2024-07-18: Began additions of Indexes. These are included with all tables going forward.
		2024-07-19: Added Vehicles Table.
		2024-07-19: Added Homes Table. Non-Goal, staging out.
		2024-07-19: Added Policies Table. Necessary for Auto-Claims.
		2024-07-19: Added Vehicle Coverages Table.
		2024-07-26: Removed STATISTICS_INCREMENTAL. As this caused issues with the initially Create.
		2024-07-26: Updated the PACA references to [PACA] where applicable. This does not apply
			to all instances of the PACA.
		2024-07-26: Added TRY...CATCH for ACCOUNTS Test INSERTs.
		2024-07-27: Added Inserts for Initial Vehicles.
		2024-07-27: Added Inserts for Vehicles and Homes for Initial data set.
		2024-07-27: Added Inserts for Policies.
		2024-07-28: Added Inserts for Vehicle Coverages.
		

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
        variableName; description
		
	Citations:
		1. Database Files and Filegroups, https://learn.microsoft.com/en-us/sql/relational-databases/databases/database-files-and-filegroups?view=sql-server-ver16
		2. Database table partitioning in SQL Server, https://www.sqlshack.com/database-table-partitioning-sql-server/
		3. CREATE PARTITION FUNCTION (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-partition-function-transact-sql?view=sql-server-ver16
		4. CREATE PARTITION SCHEME (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-partition-scheme-transact-sql?view=sql-server-ver16
		5. Partitioned tables and indexes, https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver16
		6. CREATE INDEX (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-index-transact-sql?view=sql-server-ver16
		7. CREATE USER (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-user-transact-sql?view=sql-server-ver16
		8. CREATE LOGIN (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-login-transact-sql?view=sql-server-ver16
		9. CREATE STATISTICS (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-statistics-transact-sql?view=sql-server-ver16
		10. Use cases for FILESTREAM (Transact-SQL), https://www.sqlshack.com/sql-server-filetable-use-cases/
		11. RAISERROR(Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-ver16
		12. TRY...CATCH (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/try-catch-transact-sql?view=sql-server-ver16
		13. += (Addition Assignment) (T-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/add-equals-transact-sql?view=sql-server-ver16
		14. How to calculate decimals (x,y) max value in sql server, https://stackoverflow.com/questions/37529664/how-to-calculate-decimalx-y-max-value-in-sql-server
		15. SELECT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql?view=sql-server-ver16
		16. Predicates, https://learn.microsoft.com/en-us/sql/t-sql/queries/predicates?view=sql-server-ver16

	Author Notes:
		Inspired by my time at Hyland working with Phil Mosher and Brandon Rossin.
		GO Keyword does not require a semi-colon. As it would be redundant.
		BEGIN...END Blocks have been phased out completely for TRY...CATCH and GO.
		Calculation for DECIMAL(X,Y): (10 ^ (x-y)) - (10 ^ -y) . Absolute and Negative Values.
		Logical Processing Order:	
    		FROM
    		ON
    		JOIN
    		WHERE
    		GROUP BY
    		WITH CUBE or WITH ROLLUP
    		HAVING
    		SELECT
    		DISTINCT
    		ORDER BY
    		TOP
**/


-- We need to create the Database First
USE MASTER

CREATE DATABASE PACA
ON PRIMARY
	( NAME=N'PACA',
		FILENAME=N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PACA.mdf',
	SIZE=256MB,
	MAXSIZE=2GB,
	FILEGROWTH=1MB),
FILEGROUP Paca_FG1
	( NAME = N'PACA_FG1_Dat1',
	FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PACA_FG1_Dat1.ndf',
	SIZE=512MB,
	MAXSIZE=2GB,
	FILEGROWTH=1MB),
	( NAME = N'PACA_FG1_Dat2',
	FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PACA_FG1_Dat2.ndf',
	SIZE=256MB,
	MAXSIZE=2GB,
	FILEGROWTH=1MB)
LOG ON
	( NAME=N'PACA_LOG',
	FILENAME=N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PACA_LOG.ldf',
	SIZE=1MB,
	MAXSIZE=10MB,
	FILEGROWTH=1MB);
GO

/**

	We need to create the login for the Database.
	As well as;
		DEFAULT_DATABASE: pacauser
		CHECK_EXPIRATION: Disabled with off
		CHECK_POLICY: Disables the Windows Password Policy
			This is because MS SQL Server will take on
			whatever Password Policy is used by the Domain.

**/

USE PACA
CREATE LOGIN pacauser WITH PASSWORD = N'pacauser',
	DEFAULT_DATABASE = PACA,
	CHECK_EXPIRATION = OFF,
	CHECK_POLICY = OFF
GO

/**

	Create the principal account for the pacauser

**/

CREATE USER pacauser FOR LOGIN pacauser
GO

/**

	Creating our Schemas.
	Granting Authorization to pacauser.

**/

CREATE SCHEMA paca AUTHORIZATION pacauser
GRANT SELECT ON SCHEMA::paca TO contentcomposer
GO

USE MASTER

GRANT VIEW SERVER STATE TO pacauser
GO

-- sp_addrolemember and sp_addsrvrolemember have been replaced with ALTER SERVER ROLE.

USE PACA

ALTER ROLE db_accessadmin ADD MEMBER pacauser
ALTER ROLE db_backupoperator ADD MEMBER pacauser
ALTER ROLE db_datareader ADD MEMBER pacauser
ALTER ROLE db_datawriter ADD MEMBER pacauser
ALTER ROLE db_owner ADD MEMBER pacauser
ALTER ROLE db_securityadmin ADD MEMBER pacauser
GO


/**

Partitions are being added to non-goals. 2024-07-18

-- MAX DEFAULT PARTITIONS IS 15.000

CREATE PARTITION FUNCTION accounts_partition (datetime)
AS RANGE RIGHT
FOR VALUES (N'20230101',N'20230201',N'20230401',
N'20230501',N'20230601',N'20230701',N'20230801',
N'20230901',N'20230901')
GO

CREATE PARTITION SCHEME
AS PARTITION accounts_partition
TO (January, February, March, 
    April, May, June, July, 
    Avgust, September, October, 
    November, December);
GO

**/

BEGIN TRY
CREATE TABLE ACCOUNTS
(
	ACCOUNT_ID INT IDENTITY(1,1),
	ACCOUNT_NUM	AS N'ICA' + RIGHT('00000000' + CAST(ACCOUNT_ID AS NVARCHAR(8)),8) PERSISTED NOT NULL,
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
	ACCOUNT_TYPE	NVARCHAR(64) NOT NULL,
	CONSTRAINT PK_AccountNum PRIMARY KEY CLUSTERED (ACCOUNT_NUM)
) ON [PRIMARY]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.

*/

RAISERROR(N'Unable to Create the table ACCOUNTS.',20,-1)
	WITH LOG;
END CATCH;
GO

/**

	Creating our Indexes:
	account_idx
	account_idx2
	account_idx3
	
	Clustered Indexes:
		Rationale; Overall Clustered Indexes Perform Better.
		A Clustered Index is used to define the order or to
			sort the table or arrange the data by alphabetical
			order just like a dictionary.
		It is fater than a non-clustered index.
		It demands less memory to execute the operation.
		It permits you to save data sheets in the leaf nodes
			of the Index.
		A single table can consist of a sole cluster index.
			(This means ONLY ONE for the ENTIRE TABLE).
		It has the natural ability to store data on the disk.
**/

BEGIN TRY
CREATE INDEX account_idx ON ACCOUNTS(ACCOUNT_NUM ASC,ACCOUNT_FIRST_NAME)
	WITH (ALLOW_ROW_LOCKS = ON)
	ON [Paca_FG1]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.

*/

RAISERROR(N'Unable to Create the INDEX account_idx.',20,-1)
	WITH LOG;
END CATCH;
GO

BEGIN TRY
CREATE INDEX account_idx2 ON ACCOUNTS(ACCOUNT_NUM DESC,
	ACCOUNT_FIRST_NAME ASC,ACCOUNT_LAST_NAME ASC,ACCOUNT_CITY)
	WITH (ALLOW_ROW_LOCKS = ON)
	ON [Paca_FG1]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.

*/

RAISERROR(N'Unable to Create the account_idx2.',20,-1)
	WITH LOG;
END CATCH;
GO

BEGIN TRY
CREATE INDEX account_idx3 ON ACCOUNTS(ACCOUNT_CITY,ACCOUNT_STATE,
	ACCOUNT_FIRST_NAME ASC,ACCOUNT_LAST_NAME ASC)
	WITH (ALLOW_ROW_LOCKS = ON)
	ON [Paca_FG1]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.

*/

RAISERROR(N'Unable to Create the INDEX account_idx3.',20,-1)
	WITH LOG;
END CATCH;

GO


/**

	Vehicles to Account is a 1:Many relationship.
	This is because you will only have 1 Account.
	But, 1 Account can have 1 or more Cars.

	VIN is a unique alpha-numeric value, therefore
	must be a 1 of. Any attempt to re-use the VIN
	SHALL be denied.

**/

BEGIN TRY
CREATE TABLE VEHICLES
(
	VEHICLE_ID INT IDENTITY(1,1),
	VEHICLE_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
	VEHICLE_VIN NVARCHAR(32) NOT NULL,
	VEHICLE_YEAR DATETIME NOT NULL,
	VEHICLE_MAKE	NVARCHAR(32) NOT NULL,
	VEHICLE_MODEL	NVARCHAR(65) NOT NULL,
	VEHICLE_PREMIUM	DECIMAL(5,2) NOT NULL,
	VEHICLE_ANNUAL_MILEAGE INT NULL,
	VEHICLE_VEHICLE_USE	NVARCHAR(64) NOT NULL,
	VEHICLE_ADDRESS1_GARAGED NVARCHAR(128) NOT NULL,
	VEHICLE_ADDRESS2_GARAGED NVARCHAR(128) NULL,
	CONSTRAINT PK_Vehicles PRIMARY KEY CLUSTERED (VEHICLE_VIN),
	CONSTRAINT FK_Vehicles1 FOREIGN KEY (VEHICLE_ACCOUNT_NUM)
	REFERENCES ACCOUNTS (ACCOUNT_NUM)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ON [PRIMARY]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.

*/

RAISERROR(N'Unable to Create the table VEHICLES.',20,-1)
	WITH LOG;
END CATCH;

GO

/**

	Typical for an Insurance Company to have multiple
	offerings. Homes is an additional offerring that
	will follow POST-Completion.

**/

BEGIN TRY
CREATE TABLE HOMES
(
	HOMES_ID INT IDENTITY(1,1),
	HOMES_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
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
	CONSTRAINT PK_Homes PRIMARY KEY CLUSTERED (HOMES_ID),
	CONSTRAINT FK_HomesAccNum FOREIGN KEY (HOMES_ACCOUNT_NUM)
	REFERENCES ACCOUNTS (ACCOUNT_NUM)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ON [PRIMARY]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.

*/

RAISERROR(N'Unable to Create the table HOMES.',20,-1)
	WITH LOG;
END CATCH;
GO

BEGIN TRY
CREATE INDEX homes_idx ON HOMES(HOMES_ACCOUNT_NUM ASC,HOMES_ADDRESS)
	WITH (ALLOW_ROW_LOCKS = ON)
	ON [Paca_FG1]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.
*/

RAISERROR(N'Unable to Create the INDEX homes_idx.',20,-1)
	WITH LOG;
END CATCH;
GO


/**

TO-DO: POLICIES Enumerations

Policies:
Home
Car

**/

BEGIN TRY
CREATE TABLE POLICIES
(
	POLICIES_ID INT IDENTITY(1,1),
	POLICIES_ID_ACTUAL AS N'P-' + RIGHT('00000000' + CAST(POLICIES_ID AS NVARCHAR(8)),8) PERSISTED NOT NULL,
	POLICIES_NAME NVARCHAR(128) NOT NULL,
	POLICIES_TYPE INT NOT NULL,
	POLICIES_DESC NVARCHAR(MAX) NULL,
	CONSTRAINT PK_Policies PRIMARY KEY CLUSTERED (POLICIES_ID)
) ON [PRIMARY]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.

*/

RAISERROR(N'Unable to Create the table POLICIES.',20,-1)
	WITH LOG;
END CATCH;

GO

/**

TO-DO: Insert Test Data.
	Accounts: Not Done. Need;3.
	Vehicles: Not Done. Need; 3.
	Homes: Not Done. Need; 3.
	Policies: Not Done. Need; 3.

**/



/**

	Uninsured Motorist Coverage
	Personal Injury Protection
	Rental Reimbursement
	Comprehensive
	Medical Payments (Medpay)
	Property Damage
	Vehicle Coverages
	Orginal Parts Replacement
	Collision
	Medical Payments Coverage
	Roadside Assistance
	Comprehensive Insurance
	Windshield Insurance
	Glass Deductible Buyback
	Classic Car
	Rideshare
	Liability Insurance
	Comprehensive Coverage
	GAP Insurance
	Accidents
	Bodily Injury
	Umbrella Insurance
	Mechanical Breakdown Coverage
	
	
	ChatGPT Examples
	Liability Coverage
	Collision Coverage
	Comprehensive Coverage
	Personal Injury Protection (PIP)
	Medical Payment Coverage (MedPay)
	Uninsured/Underinsured Motorist Coverage
	Rental Reimbursement Coverage
	Roadside Assitance/Towing Coverage
	GAP Insurance
	New Car Replacement Coverage
	Rideshare Insurance
	Custom Parts and Eqiupment Coverage
	Glass Coverage
	Loss of Use Coverage
	Loan/Lease Payoff Coverage
	Pet Injury Coverage
	Emergency Lockout Coverage

**/


-- Needs the same precision as above with DECIMAL(x,y)
BEGIN TRY
CREATE TABLE VEHICLE_COVERAGES
(
	VEHICLES_COVERAGE_ID INT IDENTITY(1,1),
	VEHICLES_COVERAGE_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
	VEHICLES_COVERAGE_VEHICLE INT NOT NULL,
	VEHICLES_COVERAGE_LIABILITY DECIMAL(10,2) NULL,
	VEHICLES_COVERAGE_COLLISION DECIMAL(10,2) NULL,
	VEHICLES_COVERAGE_COMPREHENSIVE DECIMAL(10,2) NULL,
	VEHICLES_COVERAGE_PIP DECIMAL(10,2) NULL,
	VEHICLES_COVERAGE_MEDPAY DECIMAL(10,2) NULL,
	VEHICLES_COVERAGE_UNMOTO DECIMAL(10,2) NULL,
	VEHICLES_COVERAGE_RENTAL_REIMB DECIMAL(10,2) NULL,
	VEHICLES_COVERAGE_ROADSIDE_TOW DECIMAL(10,2) NULL,
	CONSTRAINT PK_VehicleCov PRIMARY KEY CLUSTERED (VEHICLES_COVERAGE_ID),
	CONSTRAINT Fk_VehicleCov1 FOREIGN KEY (VEHICLES_COVERAGE_ACCOUNT_NUM)
	REFERENCES ACCOUNTS (ACCOUNT_NUM)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ON [PRIMARY]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.
*/

RAISERROR(N'Unable to Create the table VEHICLE_COVERAGES.',20,-1)
	WITH LOG;
END CATCH;

GO

BEGIN TRY
CREATE TABLE VEHICLE_CLAIMS
(
	VEHICLE_CLAIMS_ID INT IDENTITY(1,1),
	VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER AS N'ICN' + RIGHT('00000000' + CAST(VEHICLE_CLAIMS_ID AS NVARCHAR(8)),8) PERSISTED NOT NULL,
	VEHICLE_CLAIMS_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
	VEHICLE_CLAIMS_VEHICLE_VIN NVARCHAR(32) NOT NULL,
	VEHICLE_CLAIMS_TITLE NVARCHAR(256) NOT NULL,
	VEHICLE_CLAIMS_DESCRIPTION NVARCHAR(MAX) NOT NULL,
	VEHICLE_CLAIMS_CLAIM_TYPE INT NOT NULL,
	VEHICLE_CLAIMS_EXTERNAL_CASE_NUMBER NVARCHAR(32) NULL,
	VEHICLE_CLAIMS_DEDUCTIBLE DECIMAL(10,2) NULL,
	VEHICLE_CLAIMS_TOTAL_ESTIMATE DECIMAL(10,2) NULL,
	VEHICLE_CLAIMS_STATUS SMALLINT NULL,
	VEHICLE_CLAIMS_MEDIA SMALLINT NULL,
	VEHICLE_CLAIMS_TOW_COMPANY NVARCHAR(128) NULL,
	CONSTRAINT PK_VehicleClaim PRIMARY KEY CLUSTERED (VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER),
	CONSTRAINT Fk_VehicleClaim1 FOREIGN KEY (VEHICLE_CLAIMS_ACCOUNT_NUM)
	REFERENCES ACCOUNTS (ACCOUNT_NUM)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CHECK (LEN(VEHICLE_CLAIMS_ACCOUNT_NUM) = 11)
) ON [PRIMARY]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.
*/

RAISERROR(N'Unable to Create the table VEHICLE_CLAIMS.',20,-1)
	WITH LOG;
END CATCH;

GO

/*

	INSERT OF OUR TEST ACCOUNTS.
	Using TRY...CATCH as that fits best practices.

*/

BEGIN TRY
INSERT INTO ACCOUNTS VALUES (NULL,N'Robert',N'Plant',NULL,N'1346 Zeppelin Ct.',NULL,N'Kansas City',N'Kansas',66025,NULL,CURRENT_TIMESTAMP,DATEADD(DD,1,DATEADD(yy,1,CURRENT_TIMESTAMP)),N'Car Insurance - Standalone' );
INSERT INTO ACCOUNTS VALUES (NULL,N'Jimmy',N'Page',NULL,N'1348 Zeppelin Ct.',NULL,N'Kansas City',N'Kansas',66025,NULL,CURRENT_TIMESTAMP,DATEADD(DD,1,DATEADD(yy,1,CURRENT_TIMESTAMP)),N'Car Insurance - Bundle Home' );
INSERT INTO ACCOUNTS VALUES (NULL,N'John',N'Bonham',NULL,N'1350 Zeppelin Ct.',NULL,N'Kansas City',N'Kansas',66025,NULL,CURRENT_TIMESTAMP,DATEADD(DD,1,DATEADD(yy,1,CURRENT_TIMESTAMP)),N'Home - Standalone' );
INSERT INTO ACCOUNTS VALUES (NULL,N'John Paul',N'Jones',NULL,N'1352 Zeppelin Ct.',NULL,N'Kansas City',N'Kansas',66025,NULL,CURRENT_TIMESTAMP,DATEADD(DD,1,DATEADD(yy,1,CURRENT_TIMESTAMP)),N'Home - Bundle Car Insurance' );
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.

*/

RAISERROR(N'Unable to perform Accounts inserts.',20,-1)
	WITH LOG;
END CATCH;

GO

/*

	We need to grab our previous accounts

*/

BEGIN TRY
DECLARE @rplant NVARCHAR(11),
@jpage NVARCHAR(11),
@jbonham NVARCHAR(11),
@jpauljones NVARCHAR(11);

SET @rplant = (SELECT TOP 1 ACCOUNT_NUM FROM ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'Robert' AND ACCOUNT_LAST_NAME = N'Plant');
SET @jpage = (SELECT TOP 1 ACCOUNT_NUM FROM ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'Jimmy' AND ACCOUNT_LAST_NAME = N'Page');
SET @jbonham = (SELECT TOP 1 ACCOUNT_NUM FROM ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'John' AND ACCOUNT_LAST_NAME = N'Bonham');
SET @jpauljones = (SELECT TOP 1 ACCOUNT_NUM FROM ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'John Paul' AND ACCOUNT_LAST_NAME = N'Jones');

/*

	VEHICLE_ID INT IDENTITY(1,1) - NOT NEEDED
	VEHICLE_ACCOUNT_NUM NVARCHAR(11) - @firstinitialLastname, e.g. @jdoe
	VEHICLE_VIN NVARCHAR(32)
	VEHICLE_YEAR DATETIME
	VEHICLE_MAKE	NVARCHAR(32)
	VEHICLE_MODEL	NVARCHAR(65)
	VEHICLE_PREMIUM	DECIMAL(5,2)
	VEHICLE_ANNUAL_MILEAGE INT
	VEHICLE_VEHICLE_USE	NVARCHAR(64)
	VEHICLE_ADDRESS1_GARAGED NVARCHAR(128)
	VEHICLE_ADDRESS2_GARAGED NVARCHAR(128)

*/

--Robert Plant needs a Vehicle
INSERT INTO VEHICLES VALUES (@rplant,N'KM8SC13EX5U005568',N'2005-01-01',N'Hyundai',N'Santa Fe',174.90,10000,N'Work, Pleasure, or drive to work.',N'1346 Zeppelin Ct., Kansas City, Kansas, 66025',NULL);

/*

	HOMES_ID INT IDENTITY(1,1), - NOT NEEDED
	HOMES_ACCOUNT_NUM NVARCHAR(11) NOT NULL, - @firstinitialLastname, e.g. @jdoe
	HOMES_PREMIUM DECIMAL(5,2) NOT NULL,
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
	HOMES_SEC2_MPO DECIMAL(12,2) NULL

*/

--Jimmy Page needs a Vehicle and a Home.
INSERT INTO VEHICLES VALUES (@jpage,N'5NPEB4AC0BH281769',N'2011-01-01',N'Hyundai',N'Sonata 2.4l',214.60,10000,N'Work, Pleasure, or drive to work.',N'1346 Zeppelin Ct., Kansas City, Kansas, 66025',NULL);

INSERT INTO HOMES VALUES (@jpage,1374.28,N'1348 Zeppelin Ct., Kansas City, Kansas, 66025',100.00,100.00,214.60,10000.00,2500.00,3500.00,500.00,250.00,125.00,250.00);

--John Bonham needs a Home
INSERT INTO HOMES VALUES (@jbonham,1374.28,N'1350 Zeppelin Ct., Kansas City, Kansas, 66025',100.00,100.00,214.60,10000.00,2500.00,3500.00,500.00,250.00,125.00,250.00);

--John Paul Jones needs a Home and a Vehicle
INSERT INTO HOMES VALUES (@jpauljones,1374.28,N'1352 Zeppelin Ct., Kansas City, Kansas, 66025',100.00,100.00,214.60,10000.00,2500.00,3500.00,500.00,250.00,125.00,250.00);

INSERT INTO VEHICLES VALUES (@jpauljones,N'5NPEB4AC0BH281770',N'2011-01-01',N'Hyundai',N'Sonata 2.4l',214.60,10000,N'Work, Pleasure, or drive to work.',N'1346 Zeppelin Ct., Kansas City, Kansas, 66025',NULL);
END TRY
BEGIN CATCH
RAISERROR(N'Unable to perform Vehicles and Homes inserts.',20,-1)
	WITH LOG;
END CATCH;

GO

/*

	POLICIES_ID AS N'P-' + RIGHT('00000000' + CAST(ACCOUNT_ID AS NVARCHAR(8)),8) PERSISTED NOT NULL,
	POLICIES_NAME NVARCHAR(128) NOT NULL,
	POLICIES_TYPE INT NOT NULL,
	POLICIES_DESC NVARCHAR(MAX) NULL,

*/

BEGIN TRY
INSERT INTO POLICIES VALUES (N'Car - Basic',123,N'This is the minimum policy requirement for a car.');
INSERT INTO POLICIES VALUES (N'Car - Advanced',425,N'This is the middle ground policy.');
INSERT INTO POLICIES VALUES (N'Car - Premium',513,N'This is the best car policy');
INSERT INTO POLICIES VALUES (N'Home - Basic',283,N'This is the minimum policy requirement for a home.');
INSERT INTO POLICIES VALUES (N'Home - Advanced',549,N'This is the middle ground policy.');
INSERT INTO POLICIES VALUES (N'Home - Premium',495,N'This is the best home policy');
INSERT INTO POLICIES VALUES (N'Car and Home Bundle - Basic',124,N'This is the minimum policy requirement for a home and car.');
INSERT INTO POLICIES VALUES (N'Car and Home Bundle - Advanced',284,N'This is the middle ground policy.');
INSERT INTO POLICIES VALUES (N'Car and Home Bundle - Premium',496,N'This is the best home and car policy.');
END TRY
BEGIN CATCH
RAISERROR(N'Unable to perform Policy inserts.',20,-1)
	WITH LOG;
END CATCH;
GO


/*

	VEHICLES_COVERAGE_ID INT IDENTITY(1,1), - NOT NEEDED
	VEHICLES_COVERAGE_ACCOUNT_NUM NVARCHAR(11) NOT NULL, -@firstinitialLastname, 0
	VEHICLES_COVERAGE_VEHICLE INT NOT NULL, 1
	VEHICLES_COVERAGE_LIABILITY DECIMAL(10,2) NULL, 2
	VEHICLES_COVERAGE_COLLISION DECIMAL(10,2) NULL, 3
	VEHICLES_COVERAGE_COMPREHENSIVE DECIMAL(10,2) NULL, 4
	VEHICLES_COVERAGE_PIP DECIMAL(10,2) NULL, 5
	VEHICLES_COVERAGE_MEDPAY DECIMAL(10,2) NULL, 6
	VEHICLES_COVERAGE_UNMOTO DECIMAL(10,2) NULL, 7
	VEHICLES_COVERAGE_RENTAL_REIMB DECIMAL(10,2) NULL, 8
	VEHICLES_COVERAGE_ROADSIDE_TOW DECIMAL(10,2) NULL, 9

*/

BEGIN TRY

/*

	Declarations are exclusive to their GO blocks. As each GO represents a "commit."
	Psuedo-Code:
		rplant,jpage,jbonham,jpauljones,vehicle_count
		
*/

DECLARE @rplant NVARCHAR(11),
@jpage NVARCHAR(11),
@jbonham NVARCHAR(11),
@jpauljones NVARCHAR(11),
@vehicle_count int = 0;

SET @rplant = (SELECT TOP 1 ACCOUNT_NUM FROM ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'Robert' AND ACCOUNT_LAST_NAME = N'Plant');
SET @jpage = (SELECT TOP 1 ACCOUNT_NUM FROM ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'Jimmy' AND ACCOUNT_LAST_NAME = N'Page');

/*
John Bonham is not needed for this portion of our test data. He does not have a Car insurance policy.
@jbonham = (SELECT TOP 1 ACCOUNT_NUM FROM ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'John' AND ACCOUNT_LAST_NAME = N'Bonham'),
*/

SET @jpauljones = (SELECT TOP 1 ACCOUNT_NUM FROM ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'John Paul' AND ACCOUNT_LAST_NAME = N'PJones');

SET @vehicle_count += 1; -- 1, 0 + 1

INSERT INTO VEHICLE_COVERAGES VALUES (@rplant,@vehicle_count,10000.00,50000.00,1000.00,1000.00,500.00,125.00,100.00,50.00);

SET @vehicle_count += 1; -- 2, 1 + 1

INSERT INTO VEHICLE_COVERAGES VALUES (@jpage,@vehicle_count,10000.00,50000.00,1000.00,1000.00,500.00,125.00,100.00,50.00);

/*

Proper usage of += operator.

Author Notes: For simplicity this is being performed. Otherwise each block would need declaration. It is not possible to do a
Trigger as it is not self-refernce-able (i.e. I cannot access the same data I am trying to interact with. I can just push-pull).

*/

SET @vehicle_count += 1; --3, 2 + 1

INSERT INTO VEHICLE_COVERAGES VALUES (@jpauljones,@vehicle_count,10000.00,50000.00,1000.00,1000.00,500.00,125.00,100.00,50.00);

END TRY
BEGIN CATCH
RAISERROR(N'Unable to perform Policy inserts.',20,-1)
	WITH LOG;
END CATCH;

GO