/**
	Name of Script: paca-stored-procedure-testing.sql
    Author: Jacob Shuster
    Role: Consultant - 1099
    Umbrella Company: N/A
    Creation Date: 2024-08-08
    Script Cost: N/A
    Rate: 100.00 (Based on 2019*)

    Changelog:
        2024-08-08: Added Select Execute stored procedure statements to the TRY...CATCH Block.
        2024-08-08: 
		
    TO DO (Requested):
		N/A - No current modification requests pending.
	
	TO DO (SELF):
		Policies Enumerations. - DONE
		Bundle Enumeration for Car and Home. For non-goal. - DONE
    Plan for additional tables; such as CLAIMS
    Need to add Stored Procedure for Homes Inserts.
		
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
        @acctHonorifics: Account Holder's Honorofics. Null by default.
        @acctFirstName: Account Holder's First Name.
        @acctLastName: Account Holder's Last Name.
        @acctSuffix: Account Holder's Suffix. Null by default.
        @acctStreetAdd1: Account Holder's Address Line 1.
        @acctStreetAdd2: Account Holder's Address Line 2.
        @acctCity: Account Holder's City.
        @acctState: Account Holder's State.
        @acctZip: Account Holder's Zip Code.
        @acctPOBox: Account Holder's PO Box.
        @acctDateStart: Account Holder's Account Inception Date.
        @acctType: Account Holder's Account Type.
        @vehicleAcctNum: Account Number associated with this Vehicle.
        @vehicleVin: VIN Number of the Vehicle.
        @vehicleYear: Year of the Vehicle.
        @vehicleMake: Make of the Vehicle.
        @vehicleModel: Model of the Vehicle.
        @vehiclePremium: Premium cost for the Vehicle.
        @vehicleAnnualMileage: Annual Mileage estimate of the Vehicle.
        @vehicleVehicleUse: Vehicle use cases.
        @vehicleAddress1Garaged: Vehicle Physical Location. Where it is housed at when not in operation.
        @vehicleAddress2Garaged: Vehicle Physical Location 2. Where it is housed at when not in operation if not a house. Null by default.
        @vehicleClaimAccountNum: Account Number associated with the Vehicle Claim.
        @vehicleClaimVin: Vehicle Claim Associated VIN Number.
        @vehicleClaimTitle: Vehicle Title, What happened (Subject)?
        @vehicleClaimDescription: Vehicle Claim Description, expansion of Subject.
        @vehicleClaimClaimType: Vehicle Claim Type.
        @vehicleClaimExternalCaseNumber: Vehicle Claim External Number for; Tow, Windshield, etc.
        @vehicleClaimDeductible: Vehicle Claim Minimum Deductible.
        @vehicleClaimTotalEstimate: Vehicle Claim Estimate.
        @vehicleClaimStatus: Vehicle Claim Status.
        @vehicleClaimMedia: Vehicle Claim Media Available.
        @vehicleClaimTowCompany Vehicle Claim Tow Company, if used.
        @homeAccountNum: Account Number associated with the Home.
        @homeAccountPremium: Premium for the Home.
        @homeAddress: Address for the Home.
        @homeSec1DW: Home, Section 1, Dwelling.
        @homeSec1DWEX: Home, Section 1, Dwelling extension up to.
        @homeSec1PP: Home, Section 1, Personal Property.
        @homeSec1LOU: Home, Section 1 Loss of Use.
        @homeSec1FDSC: Home, Section 1, Fire Department Service Charge.
        @homeSec1SI: Home, Section 1, Service Line Coverage.
        @homeSec1BUSD: Home, Section 1, Back-up of Sewer or Drain 5%.
        @homeSec2PL: Home, Section 2, Personal Liability (Each Occurrence).
        @homeSec2DPO: Home, Section 2, Damage to Property of Others. 
        @homeSec2MPO: Home, Section 2, Medical Payments to Others (Each Person).
		
	Citations:
		1. CREATE PROCEDURE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver16
    2. NO COUNT (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver16
    3. ERROR_MESSAGE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/functions/error-message-transact-sql?view=sql-server-ver16
    4. CASE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-ver16
    5. IF...ELSE (Transact-SQL), https://learn.microsoft.com/en-us/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16
    6. Tutorial: Signing Stored Procedures With a Certificate, https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-signing-stored-procedures-with-a-certificate?view=sql-server-ver16

	Author Notes:
		Inspired by my time at Hyland working with Phil Mosher and Brandon Rossin.
		GO Keyword does not require a semi-colon. As it would be redundant.
		BEGIN...END Blocks have been phased out completely for TRY...CATCH and GO.
        BEGIN TRANSACTION...COMMIT TRANSACTION Blocks to be used. As it is intended
            for the application to be running these statements.
    These will need to be transitioned into Stored Procedures. This is necessary for
      exposing an external Web service.
    SET NOCOUNT ON is used to lessen the output to the MS SQL Server Logs.
    It is recommended that it ALWAYS follows the AS Clause, and before
      any other lines of code.

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

/*

Select Stored Procedures First.

*/

DECLARE @accountNum NVARCHAR(11) = N'ICA00000001',
@homeAddress NVARCHAR(128) = N'1346 Zeppelin Ct., Kansas City, Kansas, 66025',
@firstName NVARCHAR(128) = N'Robert',
@lastName NVARCHAR(128) = N'Plant',
@intent INT = 1


BEGIN TRY
EXEC paca.getHomes_v1
EXEC paca.getHomes_v2 @firstName,@lastName,@intent
EXEC paca.getHomes_v3 @accountNum
EXEC paca.getAccounts_v1
EXEC paca.getAccounts_v2 @firstName,@lastName,@intent
EXEC paca.getAccounts_v3 @accountNum
EXEC paca.getAccounts_v4 @accountNum
EXEC paca.getAccounts_v5 @accountNum
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

/*
    Next we need to do the update stored procedures
*/