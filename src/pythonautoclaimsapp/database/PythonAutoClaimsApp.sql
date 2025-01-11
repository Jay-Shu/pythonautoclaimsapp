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
		2024-07-31: Set Default_Schema to paca for pacauser.
		2024-07-31: Granted Create Endpoint to pacauser.
		2024-07-31: Adding in Queue Blocks for staging.
		2024-07-31: Correctly Commented out Queue Blocks.
		2024-07-31: Removed DEFAULT_SCHEMA keyword from CREATE LOGIN. This is invalid and needs to
			be utilized through ALTER USER.
		2024-08-04: SET ANSI_NULLS ON added.
		2024-08-07: SET RECOVERY MODEL FULL; Added and split original SET Clauses.
		2024-08-07: SET ARITHABORT ON; and SET TRUSTWORTHY OFF;
		2024-08-07: SET ALLOW_SNAPSHOT_ISOLATION ON; SET CONCAT_NULL_YIELDS_NULL ON; SET PARAMETERIZATION ON; SET PAGE_VERIFY CHECKSUM;
		2024-08-09: Adding potential usage for database persistence with Flask. Need to test with pyodbc first.
		2024-08-09: Updated VEHICLE_YEAR from datatype DATETIME to datatype INT. This makes more sense.
		2024-08-13: Added HOMES_INTERNAL_ID to give homes a Unique Identifier to prevent updates from hitting incorrect targets.
		2024-08-16: Fixed note regarding ALTER ROLE from it's previous ALTER SERVER ROLE. SERVER is not a keyword used here.
		2024-08-17: Commented out problematic SET Clauses. These will need more research.
		2024-08-17: Removed old SET Clauses.
		2024-08-17: Updated BEGIN CATCH...END CATCH Blocks with SELECT Statement instead of original RAISEERROR().
		2024-09-03: Researching into DBCC CHECKIDENT() as this looks to be a necessary component for maintaining
			consistency with Computed columns. More specifically, these will need to target the following:
				ACCOUNTS
				HOMES
				POLICIES
				VEHICLE_CLAIMS
			The remainder columns using IDENTITY(x,y) and no other Computed value will not require this to fit Best Practices.
		2024-09-03: Added Reserved Memory Calculator, using my local machine as the Test Case. Initial Calculation does not
			account for other applications running on this machine similar to that of a Production Server.
		2024-09-03: Updated the Column Names of the Current Memory Allocations Query. Cosmetic Change.
		2025-01-10: Added CLUSTERED keyword to indexes. Creates a logical order of the key values determines the physcial
			order of the corresponding rows in a table. Refer to Author Notes for a more in-depth look.
		

    TO DO (Requested):
		N/A - No current modification requests pending.
	
	TO DO (SELF):
		Policies Enumerations. - DONE
		Bundle Enumeration for Car and Home. For non-goal. - DONE
		Research GPG Keys, and possible inclusion with application.
		
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
        @totalSysMem: Total System Memory of the Database Server where PACA will reside.
		@memoryForThreadStack: Memory required for your Database Server's Thread Stack. Refer to the table therein
			"Reserved Memory Calculator (Local Machine)" for determining what value that needs to be. This value is
			in KB therefore, must be converted to GB.
		@osMemoryRequirements: OS Memory Requirements, Refer to your OS Manufacturer's Technical Specifications to
			find this number.
		@memoryForOtherApplications: Find, record, and calculate the Memory required for any other applications
			running on the MS SQL Server.
		@memoryForMultipageAllocators: Refer to Changes to memory management starting with SQL Server 2012 (11.x).
			Specifically MPA, for memory allocations that request more than 8 KB. This is included within the
			Max Server Memory (MB) and Min Server Memory (MB) Configuration options and no longer independent.

		
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
		17. CREATE QUEUE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-queue-transact-sql?view=sql-server-ver16
		18. CREATE PROCEDURE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver16
		19. Slash Star (Block Comment), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/slash-star-comment-transact-sql?view=sql-server-ver16
		20. View or change the recovery model of a database (SQL Server), https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/view-or-change-the-recovery-model-of-a-database-sql-server?view=sql-server-ver16
		21. Recovery models (SQL Server), https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/recovery-models-sql-server?view=sql-server-ver16
		22. TRUSTWORTHY database property, https://learn.microsoft.com/en-us/sql/relational-databases/security/trustworthy-database-property?view=sql-server-ver16
		23. GRANT Database Principal Permissions (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-database-principal-permissions-transact-sql?view=sql-server-ver16
		24. Snapshot Isolation in SQL Server, https://learn.microsoft.com/en-us/dotnet/framework/data/adonet/sql/snapshot-isolation-in-sql-server
		25. SET ANSI_NULLS (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/set-ansi-nulls-transact-sql?view=sql-server-ver16
		26. In SQL Server, what does "SET ANSI_NULLS ON" mean?, https://stackoverflow.com/questions/9766717/in-sql-server-what-does-set-ansi-nulls-on-mean
		27. SET CONCAT_NULL_YIELDS_NULL (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/set-concat-null-yields-null-transact-sql?view=sql-server-ver16
		28. SET PARAMETERIZATION (Transact-SQL), https://learn.microsoft.com/en-us/sql/relational-databases/performance/specify-query-parameterization-behavior-by-using-plan-guides?view=sql-server-ver16
		29. Set the page_verify database option to checksum, https://learn.microsoft.com/en-us/sql/relational-databases/policy-based-management/set-the-page-verify-database-option-to-checksum?view=sql-server-ver16
		30. Best practices for persistent database connections in Python when using Flask, https://stackoverflow.com/questions/55523299/best-practices-for-persistent-database-connections-in-python-when-using-flask
		31. Indexes on computed columns, https://learn.microsoft.com/en-us/sql/relational-databases/indexes/indexes-on-computed-columns?view=sql-server-ver16
		32. NTFS allocation unit size, https://learn.microsoft.com/en-us/system-center/scom/plan-sqlserver-design?view=sc-om-2022#ntfs-allocation-unit-size
		33. DBCC CHECKIDENT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-checkident-transact-sql?view=sql-server-ver16
		34. Memory management architecture guide, https://learn.microsoft.com/en-us/sql/relational-databases/memory-management-architecture-guide?view=sql-server-ver16
		35. Configure the network packet size (serger configuration option), https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/configure-the-network-packet-size-server-configuration-option?view=sql-server-ver16.
		36. DBCC TRACEON - Trace Flags (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-traceon-trace-flags-transact-sql?view=sql-server-ver16
		37. Query hints (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/queries/hints-transact-sql-query?view=sql-server-ver16
		38. sys.types (Transact-SQL), https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-types-transact-sql?view=sql-server-ver16
		39. SQL Injection, https://learn.microsoft.com/en-us/sql/relational-databases/security/sql-injection?view=sql-server-ver16
		39. DSN and Connection String Keywords and Attributes, https://learn.microsoft.com/en-us/sql/connect/odbc/dsn-connection-string-attribute?view=sql-server-ver16
		40. DBCC DBREINDEX (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-dbreindex-transact-sql?view=sql-server-ver16
		41. DBCC CHECKTABLE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-checktable-transact-sql?view=sql-server-ver16
		42. DBCC CHECKALLOC (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-checkalloc-transact-sql?view=sql-server-ver16
		43. DBCC CHECKCONSTRAINTS (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-checkconstraints-transact-sql?view=sql-server-ver16

	Author Notes:
		Inspired by my time at Hyland working with Phil Mosher and Brandon Rossin.
		GO Keyword does not require a semi-colon. As it would be redundant.
		BEGIN...END Blocks have been phased out completely for TRY...CATCH and GO.
		DBCC CHECKIDENT(N'schema.table_name') and use DBCC CHECKIDENT(N'schema.table_name',RESEED)
		DBCC DBREINDEX(table_name,[,index_name[,fillfactor]]) for our purposes fillfactor will not be used as well as index_name as these values do not blanket all
		    indexes within a given table. We can build a query for executing this on demand or as a job.
		DBCC CHECKTABLE will be utilized to check the integrity of all pages and structures that mup up the table or index.
		    This also can access a view as well as tables.

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

		CLUSTERED indexes
			Creates an index in which the logical order of the key values determines the physical order of the corresponding rows in a table. The bottom, or leaf, level of the clustered index contains the actual data rows of the table. A table or view is allowed one clustered index at a time.

			A view with a unique clustered index is called an indexed view. Creating a unique clustered index on a view physically materializes the view. A unique clustered index must be created on a view before any other indexes can be defined on the same view. For more information, see Create Indexed Views.

			Create the clustered index before creating any nonclustered indexes. Existing nonclustered indexes on tables are rebuilt when a clustered index is created.

			If CLUSTERED isn't specified, a nonclustered index is created.

			Because the leaf level of a clustered index and the data pages are the same by definition, creating a clustered index and using the ON partition_scheme_name or ON filegroup_name clause effectively moves a table from the filegroup on which the table was created to the new partition scheme or filegroup. Before creating tables or indexes on specific filegroups, verify which filegroups are available and that they have enough empty space for the index.

		NTFS allocation unit size
			Volume alignment, commonly referred to as sector alignment, should be performed
			on the file system (NTFS) whenever a volume is created on a RAID device. Failure
			to do so can lead to significant performance degradation and is most commonly the
			result of partition misalignment with stripe unit boundaries. It can also lead
			to hardware cache misalignment, resulting in inefficient utilization of the array
			cache. When formatting the partition that will be used for SQL Server data files,
			it's recommended that you use a 64-KB allocation unit size (that is, 65,536 bytes)
			for data, logs, and tempdb. Be aware, however, that using allocation unit sizes
			greater than 4 KB results in the inability to use NTFS compression on the volume.
			While SQL Server does support read-only data on compressed volumes, it isn't recommended.

		Max Server Memeory Recommendation (initial reservation):
			1 GB of RAM for the OS.
			1 GB of RAM per every 4 GB of RAM installed (up to 16-GB RAM).
			1 GB of RAM per every 8 GB RAM installed (above 16-GB RAM).
		
		Reserved Memory Calculation:
			((total system memory) – (memory for thread stack) – (OS memory requirements) – (memory for other applications) – (memory for multipage allocators))

		total system memory: Total RAM on the System
		memory for thread stack:
			SQL Server Architecture		OS Architecture			Stack Size
			x86 (32-bit)				x86 (32-bit)			512 kb
			x86 (32-bit)				x64 (64-bit)			768 kb
			x64 (64-bit)				x64 (64-bit)			2048 kb
			IA64 (Itanium)				IA64 (Itanium)			4096 kb
		
		Reserved Memory Calculator (Local Machine):
			DECLARE	 @totalSysMem INT = 128,
			@memoryForThreadStack INT = 2048,
			@osMemoryRequirements INT = 4,
			@memoryForOtherApplications INT = 0,
			@memoryForMultipageAllocators INT = 0

		SELECT ((@totalSysMem) - ((@memoryForThreadStack/1000)/1000) - (@osMemoryRequirements) - (@memoryForOtherApplications) - (@memoryForMultipageAllocators))

		Finding your currently allocated memory:
			SELECT
  				physical_memory_in_use_kb/1024 AS sql_physical_memory_in_use_MB,
    			large_page_allocations_kb/1024 AS sql_large_page_allocations_MB,
    			locked_page_allocations_kb/1024 AS sql_locked_page_allocations_MB,
    			virtual_address_space_reserved_kb/1024 AS sql_VAS_reserved_MB,
    			virtual_address_space_committed_kb/1024 AS sql_VAS_committed_MB,
    			virtual_address_space_available_kb/1024 AS sql_VAS_available_MB,
    			page_fault_count AS sql_page_fault_count,
    			memory_utilization_percentage AS sql_memory_utilization_percentage,
    			process_physical_memory_low AS sql_process_physical_memory_low,
    			process_virtual_memory_low AS sql_process_virtual_memory_low
			FROM sys.dm_os_process_memory;
		Query hints are recommended as a last resort and only for experienced developers and database administrators.
**/

-- We need to create the Database First while in the Master Database
USE MASTER

-- Update the values below to their proper corresponding values.
-- If you do not have these values run the query below independently.

DECLARE	 @totalSysMem INT = 128,
			@memoryForThreadStack INT = 2048,
			@osMemoryRequirements INT = 4,
			@memoryForOtherApplications INT = 0,
			@memoryForMultipageAllocators INT = 0

		SELECT ((@totalSysMem) - ((@memoryForThreadStack/1000)/1000) - (@osMemoryRequirements) - (@memoryForOtherApplications) - (@memoryForMultipageAllocators))


GO

-- Lets display our currently allocated memory for any future calculations.
-- Updated Column Names for Easier Readability.

SELECT
  	physical_memory_in_use_kb/1024 AS N'SQL Physical Memory in use MB',
    large_page_allocations_kb/1024 AS N'SQL Large Page Allocations MB',
    locked_page_allocations_kb/1024 AS N'SQL Locked Page Allocations MB',
    virtual_address_space_reserved_kb/1024 AS N'SQL VAS Reserved MB - For Multi-page Allocator',
    virtual_address_space_committed_kb/1024 AS N'SQL VAS Committed MB - For Multi-page Allocator',
    virtual_address_space_available_kb/1024 AS N'SQL VAS Available MB - For Multi-page Allocator',
    page_fault_count AS N'SQL Page Fault Count',
    memory_utilization_percentage AS N'SQL Memory Utilization Percentage',
    process_physical_memory_low AS N'SQL Process Physical Memory Low',
    process_virtual_memory_low AS N'SQL Process Virtual Memory Low'
		FROM sys.dm_os_process_memory;

GO

--Create our database. Aptly named PACA.
CREATE DATABASE PACA
ON PRIMARY
	( NAME=N'PACA',
		FILENAME=N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PACA.mdf',
	SIZE=128MB,
	MAXSIZE=2GB,
	FILEGROWTH=1MB),
FILEGROUP Paca_FG1
	( NAME = N'PACA_FG1_Dat1',
	FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PACA_FG1_Dat1.ndf',
	SIZE=128MB,
	MAXSIZE=2GB,
	FILEGROWTH=1MB),
	( NAME = N'PACA_FG1_Dat2',
	FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PACA_FG1_Dat2.ndf',
	SIZE=64MB,
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
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- When using computed columns with indexes the following must be set to ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
-- SET NUMERIC_ROUNDABORT OFF; This must be set to off for Computed Columns.

GO

/**
Default is already 4096, not needed again.

-- Per Microsoft Documentation 4096 is the recommended value.
EXEC sp_configure 'network packet size', 4096;
GO
RECONFIGURE; --This means you don't have to restart the SQL Server after making this change.
GO
**/

ALTER DATABASE [PACA]
SET RECOVERY FULL; --FULL is necessary, as this will ensure that the transaction log is in lock-step.
GO

USE PACA
CREATE LOGIN pacauser WITH PASSWORD = N'pacauser',
	DEFAULT_DATABASE = PACA, --This user's Default MUST be PACA.
	--DEFAULT_SCHEMA = paca, Invalid Keyword for CREATE LOGIN.
	CHECK_EXPIRATION = OFF, --Disabled to never expire
	CHECK_POLICY = OFF; --Disabled to not use the Windows Domain Level Password Requirements.
GO

/**

	Create the principal account for the pacauser

**/

CREATE USER pacauser FOR LOGIN pacauser;
GO

/**

	Creating our Schemas.
	Granting Authorization to pacauser.

**/

CREATE SCHEMA paca AUTHORIZATION pacauser;
--contentcomposer user will not be a part of the final build.
--GRANT SELECT ON SCHEMA::paca TO contentcomposer;
GO

ALTER USER pacauser WITH DEFAULT_SCHEMA = paca;
GRANT VIEW DEFINITION TO pacauser;
GO

--We have to be in the master database to be able to grant view server state to a user.
USE MASTER

GRANT VIEW SERVER STATE TO pacauser;
--2024-08-07: No longer pursuing Endpoints as their original use case is no longer supported.
--GRANT CREATE ENDPOINT TO pacauser
GO

-- sp_addrolemember and sp_addsrvrolemember have been replaced with ALTER ROLE.

USE PACA

ALTER ROLE db_accessadmin ADD MEMBER pacauser
ALTER ROLE db_backupoperator ADD MEMBER pacauser
ALTER ROLE db_datareader ADD MEMBER pacauser
ALTER ROLE db_datawriter ADD MEMBER pacauser
ALTER ROLE db_ddladmin ADD MEMBER pacauser
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

EXECUTE AS LOGIN = N'pacauser'
BEGIN TRY
CREATE TABLE paca.ACCOUNTS
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
SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
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
EXECUTE AS LOGIN = N'pacauser'
BEGIN TRY
CREATE CLUSTERED INDEX account_idx ON paca.ACCOUNTS(ACCOUNT_NUM ASC,ACCOUNT_FIRST_NAME)
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

SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

BEGIN TRY
CREATE CLUSTERED INDEX account_idx2 ON paca.ACCOUNTS(ACCOUNT_NUM DESC,
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

SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

BEGIN TRY
CREATE CLUSTERED INDEX account_idx3 ON paca.ACCOUNTS(ACCOUNT_CITY,ACCOUNT_STATE,
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
SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
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
CREATE TABLE paca.VEHICLES
(
	VEHICLE_ID INT IDENTITY(1,1),
	VEHICLE_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
	VEHICLE_VIN NVARCHAR(32) NOT NULL,
	VEHICLE_YEAR INT NOT NULL,
	VEHICLE_MAKE	NVARCHAR(32) NOT NULL,
	VEHICLE_MODEL	NVARCHAR(65) NOT NULL,
	VEHICLE_PREMIUM	DECIMAL(5,2) NOT NULL,
	VEHICLE_ANNUAL_MILEAGE INT NULL,
	VEHICLE_VEHICLE_USE	NVARCHAR(64) NOT NULL,
	VEHICLE_ADDRESS1_GARAGED NVARCHAR(128) NOT NULL,
	VEHICLE_ADDRESS2_GARAGED NVARCHAR(128) NULL,
	CONSTRAINT PK_Vehicles PRIMARY KEY CLUSTERED (VEHICLE_VIN),
	CONSTRAINT FK_Vehicles1 FOREIGN KEY (VEHICLE_ACCOUNT_NUM)
	REFERENCES paca.ACCOUNTS (ACCOUNT_NUM)
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

SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

GO

/**

	Typical for an Insurance Company to have multiple
	offerings. Homes is an additional offerring that
	will follow POST-Completion.

**/

BEGIN TRY
CREATE TABLE paca.HOMES
(
	HOMES_ID INT IDENTITY(1,1),
	HOMES_INTERNAL_ID AS N'HOM' + RIGHT('00000000' + CAST(HOMES_ID AS NVARCHAR(8)),8) PERSISTED NOT NULL,
	HOMES_ACCOUNT_NUM NVARCHAR(11) NOT NULL,
	HOMES_PREMIUM DECIMAL(10,2) NOT NULL,
	HOMES_ADDRESS NVARCHAR(128) NOT NULL,
	HOMES_SEC1_DW DECIMAL(10,2) NULL,
	HOMES_SEC1_DWEX DECIMAL(10,2) NULL,
	HOMES_SEC1_PER_PROP DECIMAL(10,2) NULL,
	HOMES_SEC1_LOU DECIMAL(10,2) NULL,
	HOMES_SEC1_FD_SC DECIMAL(10,2) NULL,
	HOMES_SEC1_SL DECIMAL(10,2) NULL,
	HOMES_SEC1_BU_SD DECIMAL(12,2) NULL,
	HOMES_SEC2_PL DECIMAL(12,2) NULL,
	HOMES_SEC2_DPO DECIMAL(12,2) NULL,
	HOMES_SEC2_MPO DECIMAL(12,2) NULL,
	CONSTRAINT PK_Homes PRIMARY KEY CLUSTERED (HOMES_ID),
	CONSTRAINT FK_HomesAccNum FOREIGN KEY (HOMES_ACCOUNT_NUM)
	REFERENCES paca.ACCOUNTS (ACCOUNT_NUM)
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
SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

BEGIN TRY
CREATE CLUSTERED INDEX homes_idx ON paca.HOMES(HOMES_ACCOUNT_NUM ASC,HOMES_ADDRESS)
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

SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO


/**

TO-DO: POLICIES Enumerations

Policies:
Home
Car

**/

BEGIN TRY
CREATE TABLE paca.POLICIES
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

SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

GO

/**

TO-DO: Insert Test Data.
	Accounts: Done. Need; 3.
	Vehicles: Done. Need; 3.
	Homes: Done. Need; 3.
	Policies: Done. Need; 3.

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
CREATE TABLE paca.VEHICLE_COVERAGES
(
	VEHICLES_COVERAGE_ID INT IDENTITY(1,1), -- This needs to change as it is not great practice. This can jump from 1,2,3...10 to 1000 instead of sequential.
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
	REFERENCES paca.ACCOUNTS (ACCOUNT_NUM)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CHECK (LEN(VEHICLES_COVERAGE_ACCOUNT_NUM) = 11)
) ON [PRIMARY]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.
*/

SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

GO

BEGIN TRY
CREATE TABLE paca.VEHICLE_CLAIMS
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
	REFERENCES paca.ACCOUNTS (ACCOUNT_NUM)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CHECK (LEN(VEHICLE_CLAIMS_ACCOUNT_NUM) = 11),
	CHECK (LEN(VEHICLE_CLAIMS_INTERNAL_CASE_NUMBER) = 11) --This may or may not work, remove if it causes issues.
) ON [PRIMARY]
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.
*/

SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

GO

/*
	This is no longer being pursued.
*/

/*
CREATE QUEUE get_client_account
   WITH 
   STATUS = ON,
   RETENTION = OFF ,
   ACTIVATION (
		STATUS = ON,
		PROCEDURE_NAME = get_client_account ,
		MAX_QUEUE_READERS = 16384, 
		EXECUTE AS SELF),
   POISON_MESSAGE_HANDLING (STATUS = ON) 
   ON N'PRIMARY'
*/


/*

	INSERT OF OUR TEST ACCOUNTS.
	Using TRY...CATCH as that fits best practices.

*/

BEGIN TRY
INSERT INTO paca.ACCOUNTS VALUES (NULL,N'Robert',N'Plant',NULL,N'1346 Zeppelin Ct.',NULL,N'Kansas City',N'Kansas',66025,NULL,CURRENT_TIMESTAMP,DATEADD(DD,1,DATEADD(yy,1,CURRENT_TIMESTAMP)),N'Car Insurance - Standalone' );
INSERT INTO paca.ACCOUNTS VALUES (NULL,N'Jimmy',N'Page',NULL,N'1348 Zeppelin Ct.',NULL,N'Kansas City',N'Kansas',66025,NULL,CURRENT_TIMESTAMP,DATEADD(DD,1,DATEADD(yy,1,CURRENT_TIMESTAMP)),N'Car Insurance - Bundle Home' );
INSERT INTO paca.ACCOUNTS VALUES (NULL,N'John',N'Bonham',NULL,N'1350 Zeppelin Ct.',NULL,N'Kansas City',N'Kansas',66025,NULL,CURRENT_TIMESTAMP,DATEADD(DD,1,DATEADD(yy,1,CURRENT_TIMESTAMP)),N'Home - Standalone' );
INSERT INTO paca.ACCOUNTS VALUES (NULL,N'John Paul',N'Jones',NULL,N'1352 Zeppelin Ct.',NULL,N'Kansas City',N'Kansas',66025,NULL,CURRENT_TIMESTAMP,DATEADD(DD,1,DATEADD(yy,1,CURRENT_TIMESTAMP)),N'Home - Bundle Car Insurance' );
END TRY
BEGIN CATCH

/*

	Severity Levels 0-18 any user can specify.
	Severity Levels 19-25 can only be specified
		by members of the sysadmin fixed server
		role or users with ALTER TRACE permissions.

*/

SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
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

SET @rplant = (SELECT TOP 1 ACCOUNT_NUM FROM paca.ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'Robert' AND ACCOUNT_LAST_NAME = N'Plant');
SET @jpage = (SELECT TOP 1 ACCOUNT_NUM FROM paca.ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'Jimmy' AND ACCOUNT_LAST_NAME = N'Page');
SET @jbonham = (SELECT TOP 1 ACCOUNT_NUM FROM paca.ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'John' AND ACCOUNT_LAST_NAME = N'Bonham');
SET @jpauljones = (SELECT TOP 1 ACCOUNT_NUM FROM paca.ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'John Paul' AND ACCOUNT_LAST_NAME = N'Jones');

/*

	VEHICLE_ID INT IDENTITY(1,1) - NOT NEEDED
	VEHICLE_ACCOUNT_NUM NVARCHAR(11) - @firstinitialLastname, e.g. @jdoe
	VEHICLE_VIN NVARCHAR(32)
	VEHICLE_YEAR INT --Updated to INT, Late Change
	VEHICLE_MAKE	NVARCHAR(32)
	VEHICLE_MODEL	NVARCHAR(65)
	VEHICLE_PREMIUM	DECIMAL(5,2)
	VEHICLE_ANNUAL_MILEAGE INT
	VEHICLE_VEHICLE_USE	NVARCHAR(64)
	VEHICLE_ADDRESS1_GARAGED NVARCHAR(128)
	VEHICLE_ADDRESS2_GARAGED NVARCHAR(128)

*/

--Robert Plant needs a Vehicle
INSERT INTO paca.VEHICLES VALUES (@rplant,N'KM8SC13EX5U005568',2005,N'Hyundai',N'Santa Fe',174.90,10000,N'Work, Pleasure, or drive to work.',N'1346 Zeppelin Ct., Kansas City, Kansas, 66025',NULL);

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
INSERT INTO paca.VEHICLES VALUES (@jpage,N'5NPEB4AC0BH281769',2011,N'Hyundai',N'Sonata 2.4l',214.60,10000,N'Work, Pleasure, or drive to work.',N'1346 Zeppelin Ct., Kansas City, Kansas, 66025',NULL);

INSERT INTO paca.HOMES VALUES (@jpage,1374.28,N'1348 Zeppelin Ct., Kansas City, Kansas, 66025',100.00,100.00,214.60,10000.00,2500.00,3500.00,500.00,250.00,125.00,250.00);

--John Bonham needs a Home
INSERT INTO paca.HOMES VALUES (@jbonham,1374.28,N'1350 Zeppelin Ct., Kansas City, Kansas, 66025',100.00,100.00,214.60,10000.00,2500.00,3500.00,500.00,250.00,125.00,250.00);

--John Paul Jones needs a Home and a Vehicle
INSERT INTO paca.HOMES VALUES (@jpauljones,1374.28,N'1352 Zeppelin Ct., Kansas City, Kansas, 66025',100.00,100.00,214.60,10000.00,2500.00,3500.00,500.00,250.00,125.00,250.00);

INSERT INTO paca.VEHICLES VALUES (@jpauljones,N'5NPEB4AC0BH281770',2011,N'Hyundai',N'Sonata 2.4l',214.60,10000,N'Work, Pleasure, or drive to work.',N'1346 Zeppelin Ct., Kansas City, Kansas, 66025',NULL);
END TRY
BEGIN CATCH
SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

GO

/*

	POLICIES_ID AS N'P-' + RIGHT('00000000' + CAST(ACCOUNT_ID AS NVARCHAR(8)),8) PERSISTED NOT NULL,
	POLICIES_NAME NVARCHAR(128) NOT NULL,
	POLICIES_TYPE INT NOT NULL,
	POLICIES_DESC NVARCHAR(MAX) NULL,

*/

BEGIN TRY
INSERT INTO paca.POLICIES VALUES (N'Car - Basic',123,N'This is the minimum policy requirement for a car.');
INSERT INTO paca.POLICIES VALUES (N'Car - Advanced',425,N'This is the middle ground policy.');
INSERT INTO paca.POLICIES VALUES (N'Car - Premium',513,N'This is the best car policy');
INSERT INTO paca.POLICIES VALUES (N'Home - Basic',283,N'This is the minimum policy requirement for a home.');
INSERT INTO paca.POLICIES VALUES (N'Home - Advanced',549,N'This is the middle ground policy.');
INSERT INTO paca.POLICIES VALUES (N'Home - Premium',495,N'This is the best home policy');
INSERT INTO paca.POLICIES VALUES (N'Car and Home Bundle - Basic',124,N'This is the minimum policy requirement for a home and car.');
INSERT INTO paca.POLICIES VALUES (N'Car and Home Bundle - Advanced',284,N'This is the middle ground policy.');
INSERT INTO paca.POLICIES VALUES (N'Car and Home Bundle - Premium',496,N'This is the best home and car policy.');
END TRY
BEGIN CATCH
SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
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
		ACCOUNT_NUM
		INSERT INTO paca.VEHICLE_COVERAGES
		
*/

DECLARE @rplant NVARCHAR(11),
@jpage NVARCHAR(11),
@jbonham NVARCHAR(11),
@jpauljones NVARCHAR(11),
@vehicle_count int = 0;

--Moved John Paul Jones up, so that this section makes more sense.
SET @rplant = (SELECT TOP 1 ACCOUNT_NUM FROM paca.ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'Robert' AND ACCOUNT_LAST_NAME = N'Plant');
SET @jpage = (SELECT TOP 1 ACCOUNT_NUM FROM paca.ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'Jimmy' AND ACCOUNT_LAST_NAME = N'Page');
SET @jpauljones = (SELECT TOP 1 ACCOUNT_NUM FROM paca.ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'John Paul' AND ACCOUNT_LAST_NAME = N'Jones');

/*
John Bonham is not needed for this portion of our test data. He does not have a Car insurance policy.
@jbonham = (SELECT TOP 1 ACCOUNT_NUM FROM ACCOUNTS WHERE ACCOUNT_FIRST_NAME = N'John' AND ACCOUNT_LAST_NAME = N'Bonham'),
*/

SET @vehicle_count += 1; -- 1, 0 + 1

INSERT INTO paca.VEHICLE_COVERAGES VALUES (@rplant,@vehicle_count,10000.00,50000.00,1000.00,1000.00,500.00,125.00,100.00,50.00);

SET @vehicle_count += 1; -- 2, 1 + 1

INSERT INTO paca.VEHICLE_COVERAGES VALUES (@jpage,@vehicle_count,10000.00,50000.00,1000.00,1000.00,500.00,125.00,100.00,50.00);

/*

Proper usage of += operator.

Author Notes: For simplicity this is being performed. Otherwise each block would need declaration. It is not possible to do a
Trigger as it is not self-refernce-able (i.e. I cannot access the same data I am trying to interact with. I can just push-pull).

*/

SET @vehicle_count += 1; --3, 2 + 1

INSERT INTO paca.VEHICLE_COVERAGES VALUES (@jpauljones,@vehicle_count,10000.00,50000.00,1000.00,1000.00,500.00,125.00,100.00,50.00);

END TRY
BEGIN CATCH
SELECT 
  ERROR_NUMBER() AS ErrorNumber
  ,ERROR_SEVERITY() AS ErrorSeverity
  ,ERROR_STATE() AS ErrorState
  ,ERROR_PROCEDURE() AS ErrorProcedure
  ,ERROR_LINE() AS ErrorLine
  ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

GO