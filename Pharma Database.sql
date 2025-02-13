--TABLES

DROP TABLE VersionChange;
DROP TABLE UserReagentAction;
DROP TABLE UserSOPAction;
DROP TABLE UserSampleAction;
DROP TABLE TestReagentLink;
DROP TABLE WarehouseClientLink;
DROP TABLE TestEquipmentLink;
DROP TABLE SampleTestLink;
DROP TABLE MaintenanceLog;
DROP TABLE Test;
DROP TABLE InProcess;
DROP TABLE Stability;
DROP TABLE FinishedProduct;
DROP TABLE Equipment;
DROP TABLE Sample;
DROP TABLE Location;
DROP TABLE Warehouse;
DROP TABLE Reagent;
DROP TABLE Client;
DROP TABLE SOP;
DROP TABLE Analyst;
DROP TABLE Administrator;
DROP TABLE UserAccount;

CREATE TABLE UserAccount (
UserAccountID DECIMAL(12) NOT NULL PRIMARY KEY,
AccountUsername VARCHAR(64) NOT NULL,
FirstName VARCHAR(64) NOT NULL,
LastName VARCHAR(64) NOT NULL,
Phone VARCHAR(16) NOT NULL,
Email VARCHAR(255) NOT NULL,
Department VARCHAR(255) NOT NULL,
TrainingCompleted BIT NOT NULL,
IsAnalyst CHAR(1) NOT NULL,
IsAdministrator CHAR(1) NOT NULL
);

CREATE TABLE Analyst (
UserAccountID DECIMAL(12) NOT NULL PRIMARY KEY,
AccessLevel DECIMAL(1) NOT NULL,
AnalystSupervisor VARCHAR(64) NOT NULL,
FOREIGN KEY (UserAccountID) REFERENCES UserAccount(UserAccountID)
);

CREATE TABLE Administrator (
UserAccountID DECIMAL(12) NOT NULL PRIMARY KEY,
IsSupervisor CHAR(1) NOT NULL,
FOREIGN KEY (UserAccountID) REFERENCES UserAccount(UserAccountID)
);

CREATE TABLE SOP (
SOPID DECIMAL(12) NOT NULL PRIMARY KEY,
SOPName VARCHAR(16) NOT NULL,
VersionNumber DECIMAL(3,1) NOT NULL,
EffectiveDate DATE NOT NULL
);

CREATE TABLE UserSOPAction (
UserSOPActionID DECIMAL(12) NOT NULL PRIMARY KEY,
UserAccountID DECIMAL(12) NOT NULL,
SOPID DECIMAL(12) NOT NULL,
QAAuthor VARCHAR(64) NOT NULL,
QAReviewer VARCHAR(64) NOT NULL,
QAApprover VARCHAR(64) NOT NULL,
FOREIGN KEY (UserAccountID) REFERENCES UserAccount(UserAccountID),
FOREIGN KEY (SOPID) REFERENCES SOP(SOPID)
);

CREATE TABLE Client (
ClientID DECIMAL(12) NOT NULL PRIMARY KEY,
ClientName VARCHAR(64) NOT NULL
);

CREATE TABLE Warehouse (
WarehouseID DECIMAL(12) NOT NULL PRIMARY KEY,
SOPID DECIMAL(12) NOT NULL,
WarehouseTechnician VARCHAR(64) NOT NULL,
WarehouseFacility VARCHAR(64) NOT NULL,
WarehouseCompany VARCHAR(64) NOT NULL,
FOREIGN KEY (SOPID) REFERENCES SOP(SOPID)
);

CREATE TABLE WarehouseClientLink (
WarehouseClientLinkID DECIMAL(12) NOT NULL PRIMARY KEY,
WarehouseID DECIMAL(12) NOT NULL,
ClientID DECIMAL(12) NOT NULL,
QuantityShipped DECIMAL(4) NOT NULL,
DeliveryService VARCHAR(64) NOT NULL,
ShippingTime DATETIME NOT NULL,
DeliveryTime DATETIME NOT NULL,
AcceptableDelivery BIT NOT NULL,
FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

CREATE TABLE Location (
LocationID DECIMAL(5) NOT NULL PRIMARY KEY,
LocationType VARCHAR(64) NULL,
RoomNumber DECIMAL(5) NOT NULL
);

CREATE TABLE Equipment (
EquipmentID DECIMAL(12) NOT NULL PRIMARY KEY,
LocationID DECIMAL(5) NOT NULL,
SOPID DECIMAL(12) NOT NULL,
EquipmentName VARCHAR(64) NOT NULL,
MinUseRange DECIMAL(10,6) NOT NULL,
MaxUseRange DECIMAL(10,6) NOT NULL,
InUse BIT NOT NULL,
FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
FOREIGN KEY (SOPID) REFERENCES SOP(SOPID)
);

CREATE TABLE MaintenanceLog (
MaintenanceLogID DECIMAL(12) NOT NULL PRIMARY KEY,
EquipmentID DECIMAL(12) NOT NULL,
SOPID DECIMAL(12) NOT NULL,
ServiceDate DATE NOT NULL,
ServiceDescription VARCHAR(4000) NOT NULL,
ServiceInterval VARCHAR(64) NOT NULL,
NextServiceDate DATE NOT NULL,
FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID),
FOREIGN KEY (SOPID) REFERENCES SOP(SOPID)
);

CREATE TABLE Sample (
SampleID DECIMAL(12) NOT NULL PRIMARY KEY,
LocationID DECIMAL(5) NOT NULL,
WarehouseID DECIMAL(12) NOT NULL,
SOPID DECIMAL(12) NOT NULL,
ProductName VARCHAR(64) NOT NULL,
ProductStage VARCHAR(64) NOT NULL,
Quantity DECIMAL(4) NOT NULL,
TimeReceived DATETIME NOT NULL,
SampleType CHAR(1) NOT NULL,
StorageConditions VARCHAR(5) NOT NULL,
FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
FOREIGN KEY (SOPID) REFERENCES SOP(SOPID)
);

CREATE TABLE InProcess (
SampleID DECIMAL(12) NOT NULL PRIMARY KEY,
TimeSampled DATETIME NOT NULL,
FOREIGN KEY (SampleID) References Sample(SampleID)
);

CREATE TABLE Stability (
SampleID DECIMAL(12) NOT NULL PRIMARY KEY,
StabilityConditions VARCHAR(64) NOT NULL,
FOREIGN KEY (SampleID) References Sample(SampleID)
);

CREATE TABLE FinishedProduct (
SampleID DECIMAL(12) NOT NULL PRIMARY KEY,
ProductLotNumber DECIMAL(16) NOT NULL,
FOREIGN KEY (SampleID) References Sample(SampleID)
);

CREATE TABLE UserSampleAction (
UserSampleActionID DECIMAL(12) NOT NULL PRIMARY KEY,
UserAccountID DECIMAL(12) NOT NULL,
SampleID DECIMAL(12) NOT NULL,
ReceivingAnalyst VARCHAR(64) NOT NULL,
AliquotingAnalyst VARCHAR(64) NULL,
FOREIGN KEY (UserAccountID) REFERENCES UserAccount(UserAccountID),
FOREIGN KEY (SampleID) REFERENCES Sample(SampleID)
);

CREATE TABLE Test (
TestID DECIMAL(12) NOT NULL PRIMARY KEY,
UserAccountID DECIMAL(12) NOT NULL,
SOPID DECIMAL(12) NOT NULL,
MinAcceptableResult DECIMAL(10,6) NULL,
MaxAcceptableResult DECIMAL(10,6) NULL,
FOREIGN KEY (UserAccountID) REFERENCES UserAccount(UserAccountID),
FOREIGN KEY (SOPID) REFERENCES SOP(SOPID)
);

CREATE TABLE SampleTestLink (
SampleTestLinkID DECIMAL(12) NOT NULL PRIMARY KEY,
SampleID DECIMAL(12) NOT NULL,
TestID DECIMAL(12) NOT NULL,
TestingAnalyst VARCHAR(64) NOT NULL,
ReviewingAnalyst VARCHAR(64) NOT NULL,
TestResult DECIMAL(10,6) NOT NULL,
Deadline DATETIME NOT NULL,
PassOrFail BIT NOT NULL,
FOREIGN KEY (SampleID) REFERENCES Sample(SampleID),
FOREIGN KEY (TestID) REFERENCES Test(TestID)
);

CREATE TABLE TestEquipmentLink (
TestEquipmentLinkID DECIMAL(12) NOT NULL PRIMARY KEY,
TestID DECIMAL(12) NOT NULL,
EquipmentID DECIMAL(12) NOT NULL,
FOREIGN KEY (TestID) REFERENCES Test(TestID),
FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);

CREATE TABLE Reagent (
ReagentID DECIMAL(12) NOT NULL PRIMARY KEY,
SOPID DECIMAL(12) NOT NULL,
ReagentName VARCHAR(255) NOT NULL,
CASNumber VARCHAR(12) NOT NULL,
LotNumber VARCHAR(255) NOT NULL,
Vendor VARCHAR(255) NOT NULL,
ManufacturingDate DATE NOT NULL,
ExpirationDate DATE NOT NULL,
FOREIGN KEY (SOPID) REFERENCES SOP(SOPID)
);

CREATE TABLE UserReagentAction (
UserReagentActionID DECIMAL(12) NOT NULL PRIMARY KEY,
UserAccountID DECIMAL(12) NOT NULL,
ReagentID DECIMAL(12) NOT NULL,
ReagentManager VARCHAR(64) NOT NULL,
FOREIGN KEY (UserAccountID) REFERENCES UserAccount(UserAccountID),
FOREIGN KEY (ReagentID) REFERENCES Reagent(ReagentID)
);

CREATE TABLE TestReagentLink (
TestReagentLinkID DECIMAL(12) NOT NULL PRIMARY KEY,
TestID DECIMAL(12) NOT NULL,
ReagentID DECIMAL(12) NOT NULL,
VolumeUsed DECIMAL (10,6) NOT NULL,
FOREIGN KEY (TestID) REFERENCES Test(TestID),
FOREIGN KEY (ReagentID) REFERENCES Reagent(ReagentID)
);

CREATE TABLE VersionChange (
VersionChangeID DECIMAL(12) NOT NULL PRIMARY KEY,
OldVersionNumber DECIMAL(3,1) NOT NULL,
NewVersionNumber DECIMAL(3,1) NOT NULL,
OldEffectiveDate DATE NOT NULL,
NewEffectiveDate DATE NOT NULL,
SOPID DECIMAL(12) NOT NULL,
ChangeDate DATE NOT NULL,
FOREIGN KEY (SOPID) REFERENCES SOP(SOPID)
);

--SEQUENCES

DROP SEQUENCE UserReagentActionSeq;
DROP SEQUENCE UserSOPActionSeq;
DROP SEQUENCE UserSampleActionSeq;
DROP SEQUENCE TestReagentLinkSeq;
DROP SEQUENCE WarehouseClientLinkSeq;
DROP SEQUENCE TestEquipmentLinkSeq;
DROP SEQUENCE SampleTestLinkSeq;
DROP SEQUENCE MaintenanceLogSeq;
DROP SEQUENCE TestSeq;
DROP SEQUENCE InProcessSeq;
DROP SEQUENCE StabilitySeq;
DROP SEQUENCE FinishedProductSeq;
DROP SEQUENCE EquipmentSeq;
DROP SEQUENCE SampleSeq;
DROP SEQUENCE LocationSeq;
DROP SEQUENCE WarehouseSeq;
DROP SEQUENCE ReagentSeq;
DROP SEQUENCE ClientSeq;
DROP SEQUENCE SOPSeq;
DROP SEQUENCE AnalystSeq;
DROP SEQUENCE AdministratorSeq;
DROP SEQUENCE UserAccountSeq;
DROP SEQUENCE VersionChangeSeq;

CREATE SEQUENCE UserReagentActionSeq START WITH 1;
CREATE SEQUENCE UserSOPActionSeq START WITH 1;
CREATE SEQUENCE UserSampleActionSeq START WITH 1;
CREATE SEQUENCE TestReagentLinkSeq START WITH 1;
CREATE SEQUENCE WarehouseClientLinkSeq START WITH 1;
CREATE SEQUENCE TestEquipmentLinkSeq START WITH 1;
CREATE SEQUENCE SampleTestLinkSeq START WITH 1;
CREATE SEQUENCE MaintenanceLogSeq START WITH 1;
CREATE SEQUENCE TestSeq START WITH 1;
CREATE SEQUENCE WarehouseSeq START WITH 1;
CREATE SEQUENCE EquipmentSeq START WITH 1;
CREATE SEQUENCE LocationSeq START WITH 1;
CREATE SEQUENCE SampleSeq START WITH 1;
CREATE SEQUENCE ReagentSeq START WITH 1;
CREATE SEQUENCE ClientSeq START WITH 1;
CREATE SEQUENCE SOPSeq START WITH 1;
CREATE SEQUENCE UserAccountSeq START WITH 1;
CREATE SEQUENCE VersionChangeSeq START WITH 1;

--INDEXES

--------------------------Foreign Key Indexes----------------------------

-- Indexes for UserSOPAction table
CREATE INDEX UserSOPActionUserAccountIdx 
ON UserSOPAction(UserAccountID);

CREATE INDEX UserSOPActionSOPIdx 
ON UserSOPAction(SOPID);

-- Indexes for Warehouse table
CREATE INDEX WarehouseSOPIdx 
ON Warehouse(SOPID);

-- Indexes for WarehouseClientLink table
CREATE INDEX WarehouseClientLinkWarehouseIdx 
ON WarehouseClientLink(WarehouseID);

CREATE INDEX WarehouseClientLinkClientIdx 
ON WarehouseClientLink(ClientID);

-- Indexes for Equipment table
CREATE INDEX EquipmentLocationIdx 
ON Equipment(LocationID);

CREATE INDEX EquipmentSOPIdx 
ON Equipment(SOPID);

-- Indexes for MaintenanceLog table
CREATE UNIQUE INDEX MaintenanceLogEquipmentIdx 
ON MaintenanceLog(EquipmentID);

CREATE UNIQUE INDEX MaintenanceLogSOPIdx 
ON MaintenanceLog(SOPID);

-- Indexes for Sample table
CREATE INDEX SampleLocationIdx 
ON Sample(LocationID);

CREATE INDEX SampleWarehouseIdx 
ON Sample(WarehouseID);

CREATE INDEX SampleSOPIdx 
ON Sample(SOPID);

-- Indexes for UserSampleAction table
CREATE INDEX UserSampleActionUserAccountIdx 
ON UserSampleAction(UserAccountID);

CREATE INDEX UserSampleActionSampleIdx 
ON UserSampleAction(SampleID);

-- Indexes for Test table
CREATE INDEX TestUserAccountIdx 
ON Test(UserAccountID);

CREATE UNIQUE INDEX TestSOPIdx 
ON Test(SOPID);

-- Indexes for SampleTestLink table
CREATE INDEX SampleTestLinkSampleIdx 
ON SampleTestLink(SampleID);

CREATE INDEX SampleTestLinkTestIdx 
ON SampleTestLink(TestID);

-- Indexes for TestEquipmentLink table
CREATE INDEX TestEquipmentLinkTestIdx 
ON TestEquipmentLink(TestID);

CREATE INDEX TestEquipmentLinkEquipmentIdx 
ON TestEquipmentLink(EquipmentID);

-- Indexes for Reagent table
CREATE INDEX ReagentSOPIdx 
ON Reagent(SOPID);

-- Indexes for UserReagentAction table
CREATE INDEX UserReagentActionUserAccountIdx 
ON UserReagentAction(UserAccountID);

CREATE INDEX UserReagentActionReagentIdx 
ON UserReagentAction(ReagentID);

-- Indexes for TestReagentLink table
CREATE INDEX TestReagentLinkTestIdx 
ON TestReagentLink(TestID);

CREATE INDEX TestReagentLinkReagentIdx 
ON TestReagentLink(ReagentID);

-----------Query-Driven Indexes-------------

-- Indexes for UserAccount table
CREATE INDEX UserAccountDepartmentIdx 
ON UserAccount(Department);

-- Index for WarehouseClientLink table
CREATE INDEX WarehouseClientLinkDeliveryServiceIdx 
ON WarehouseClientLink(DeliveryService);

-- Indexes for MaintenanceLog table
CREATE INDEX MaintenanceLogNextServiceDateIdx 
ON MaintenanceLog(NextServiceDate);

-- Index for Equipment table
CREATE INDEX EquipmentEquipmentNameIdx 
ON Equipment(EquipmentName);

--STORED PROCEDURES

DROP PROCEDURE AddUserAccount;
DROP PROCEDURE AddSample;
DROP PROCEDURE AddLocation;
DROP PROCEDURE AddSOP;
DROP PROCEDURE AddTest;
DROP PROCEDURE AddGenentechWarehouse;
DROP PROCEDURE AddSampleTestLink;
DROP PROCEDURE AddTestEquipmentLink;
DROP PROCEDURE AddClient;
DROP PROCEDURE AddWarehouseClientLink;
DROP PROCEDURE AddMaintenanceLog;


CREATE PROCEDURE AddUserAccount @AccountUsername VARCHAR(64), @FirstName VARCHAR(64), @LastName VARCHAR(64), 
	@Phone VARCHAR(16), @Email VARCHAR(255), @Department VARCHAR(255), @TrainingCompleted BIT, 
	@IsAnalyst CHAR(1), @IsAdministrator CHAR(1), @AccessLevel DECIMAL(1), @AnalystSupervisor VARCHAR(64), @IsSupervisor CHAR(1)
AS
BEGIN
    -- Check for required parameters.
    IF @AccountUsername IS NULL OR @FirstName IS NULL OR @LastName IS NULL OR @Phone IS NULL OR @Email IS NULL OR @Department IS NULL
		OR @TrainingCompleted is NULL
    BEGIN
        RAISERROR ('One or more required parameters are missing.', 16, 1)
        RETURN;
    END
    -- Check for valid email format.
    IF NOT @Email LIKE '%_@__%.__%' 
    BEGIN
        RAISERROR ('Invalid email format.', 16, 1)
        RETURN;
    END
    -- Check for valid values for IsAnalyst and IsAdministrator.
    IF @IsAnalyst NOT IN ('T', 'F')
    BEGIN
        RAISERROR ('IsAnalyst parameter must be "T" or "F".', 16, 1)
        RETURN;
    END
    IF @IsAdministrator NOT IN ('T', 'F')
    BEGIN
        RAISERROR ('IsAdministrator parameter must be "T" or "F".', 16, 1)
        RETURN;
    END
	    -- Check for valid AccessLevel (1-5 is valid).
    IF @IsAnalyst = 'T' AND (@AccessLevel < 1 OR @AccessLevel > 5)
    BEGIN
        RAISERROR ('AccessLevel must be between 1 and 5 for analysts.', 16, 1)
        RETURN;
    END
	    -- Check for valid value for AnalystSupervisor.
    IF @IsAnalyst = 'T' AND @AnalystSupervisor IS NULL
    BEGIN
        RAISERROR ('AnalystSupervisor must contain supervisor username.', 16, 1)
        RETURN;
    END
	    -- Check for valid value for IsAdministrator.
    IF @IsAdministrator = 'T' AND @IsSupervisor IS NULL
    BEGIN
        RAISERROR ('IsSupervisor parameter must be "T" or "F".', 16, 1)
        RETURN;
    END
	DECLARE @current_user_account_seq INT = NEXT VALUE FOR UserAccountSeq;
	-- Insert user account.
	INSERT INTO UserAccount(UserAccountID, AccountUsername, FirstName, LastName, Phone, Email, Department, 
		TrainingCompleted, IsAnalyst, IsAdministrator)
	VALUES(@current_user_account_seq, @AccountUsername, @FirstName, @LastName, @Phone, @Email, @Department, 
		@TrainingCompleted, @IsAnalyst, @IsAdministrator);
	-- Insert into Analyst table if user is an analyst.
	IF @IsAnalyst = 'T'
		INSERT INTO Analyst(UserAccountID, AccessLevel, AnalystSupervisor)
		VALUES(@current_user_account_seq, @AccessLevel, @AnalystSupervisor);
	-- Insert into Administrator table if user is an administrator.
	IF @IsAdministrator = 'T'
		INSERT INTO Administrator(UserAccountID, IsSupervisor)
		VALUES(@current_user_account_seq, @IsSupervisor);
END;
GO

CREATE PROCEDURE AddSample @ProductName VARCHAR(64), @ProductStage VARCHAR(64), @Quantity DECIMAL(4), @SampleType CHAR(1),
	@StorageConditions VARCHAR(5), @WarehouseFacility VARCHAR(64), @SOPName VARCHAR(16), @TimeSampled DATETIME, @StabilityConditions VARCHAR(64), 
		@ProductLotNumber DECIMAL(16)
AS
BEGIN
	-- Check for required parameters.
    IF @ProductName IS NULL OR @ProductStage IS NULL OR @Quantity IS NULL OR @SampleType IS NULL 
		OR @StorageConditions IS NULL OR @WarehouseFacility IS NULL OR @SOPName IS NULL
    BEGIN
        RAISERROR ('One or more required parameters are missing.', 16, 1)
        RETURN;
    END

    -- Check for valid SampleType.
    IF @SampleType NOT IN ('I', 'S', 'F')
    BEGIN
        RAISERROR ('Invalid SampleType. SampleType must be "I" (InProcess), "S" (Stability), or "F" (FinishedProduct).', 16, 1)
        RETURN;
    END
		-- Check for required parameter.
    IF @SampleType = 'I' AND @TimeSampled IS NULL
    BEGIN
        RAISERROR ('TimeSampled is required.', 16, 1)
        RETURN;
    END
			-- Check for required parameter.
    IF @SampleType = 'S' AND @StabilityConditions IS NULL
    BEGIN
        RAISERROR ('StabilityConditions is required.', 16, 1)
        RETURN;
    END
			-- Check for required parameter.
    IF @SampleType = 'F' AND @ProductLotNumber IS NULL
    BEGIN
        RAISERROR ('ProductLotNumber is required.', 16, 1)
        RETURN;
    END
	DECLARE @current_sample_seq INT = NEXT VALUE FOR SampleSeq;
	DECLARE @TimeReceived DATETIME = GETDATE();
	-- Insert Sample information.
	INSERT INTO Sample(SampleID, LocationID, WarehouseID, SOPID, ProductName, ProductStage, Quantity, TimeReceived, SampleType, StorageConditions)
	VALUES(@current_sample_seq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
		(SELECT WarehouseID FROM Warehouse WHERE WarehouseFacility = @WarehouseFacility), (SELECT SOPID FROM SOP WHERE SOPName = @SOPName), 
		 @ProductName, @ProductStage, @Quantity, @TimeReceived, @SampleType, @StorageConditions);
	-- Insert into InProcess table if sample is an inprocess sample.
	IF @SampleType = 'I'
		INSERT INTO InProcess(SampleID, TimeSampled)
		VALUES(@current_sample_seq, @TimeSampled);
	-- Insert into Stability table if sample is a stability sample.
	IF @SampleType = 'S'
		INSERT INTO Stability(SampleID, StabilityConditions)
		VALUES(@current_sample_seq, @StabilityConditions);
	-- Insert into FinishedProduct table if sample is a finished product sample.
	IF @SampleType = 'F'
		INSERT INTO FinishedProduct(SampleID, ProductLotNumber)
		VALUES(@current_sample_seq, @ProductLotNumber);
END;
GO

CREATE PROCEDURE AddLocation @LocationType VARCHAR(64), @RoomNumber DECIMAL(5)
AS
BEGIN
	-- Check for required parameter.
    IF @RoomNumber IS NULL OR @LocationType IS NULL
    BEGIN
        RAISERROR ('One or more required parameters is missing.', 16, 1)
        RETURN;
    END
	-- Insert Location information.
	INSERT INTO Location(LocationID, LocationType, RoomNumber)
	VALUES(NEXT VALUE FOR LocationSeq, @LocationType, @RoomNumber);
END;
GO

CREATE PROCEDURE AddSOP @SOPName VARCHAR(16), @VersionNumber DECIMAL(3,1), @EffectiveDate DATE
AS
BEGIN
    -- Check for required parameters
    IF @SOPName IS NULL OR @VersionNumber IS NULL OR @EffectiveDate IS NULL
    BEGIN
        RAISERROR ('One or more required parameters are missing.', 16, 1)
        RETURN;
    END

    -- Check for valid VersionNumber
    IF @VersionNumber <= 0
    BEGIN
        RAISERROR ('VersionNumber must be greater than zero.', 16, 1)
        RETURN;
    END
    -- Insert SOP information
    INSERT INTO SOP(SOPID, SOPName, VersionNumber, EffectiveDate)
    VALUES(NEXT VALUE FOR SOPSeq, @SOPName, @VersionNumber, @EffectiveDate);
END;
GO

-- Specifically adds a warehouse to the Genentech company database.
CREATE PROCEDURE AddGenentechWarehouse @WarehouseTechnician VARCHAR(64), @WarehouseFacility VARCHAR(64), @WarehouseCompany VARCHAR(64), @SOPName VARCHAR(16)
AS
BEGIN
	IF @WarehouseTechnician IS NULL OR @WarehouseFacility IS NULL OR @WarehouseCompany IS NULL OR @SOPName IS NULL
	BEGIN
		RAISERROR ('One or more required parameters are missing.', 16, 1)
		RETURN;
	END
	-- Insert into Warehouse table
	-- Warehouses across the company share the same shipping SOP which is why I use this subquery.
    INSERT INTO Warehouse(WarehouseID, SOPID, WarehouseTechnician, WarehouseFacility, WarehouseCompany)
    VALUES(NEXT VALUE FOR WarehouseSeq, (SELECT SOPID FROM SOP WHERE SOPName = @SOPName), @WarehouseTechnician, 
		@WarehouseFacility, @WarehouseCompany);
END;
GO

CREATE PROCEDURE AddTest @SOPName VARCHAR(16), @MinAcceptableResult DECIMAL(10,6), @MaxAcceptableResult DECIMAL(10,6), @AccountUserName VARCHAR(64)
AS
BEGIN
	IF @SOPName IS NULL OR @MinAcceptableResult IS NULL OR @MaxAcceptableResult IS NULL
	BEGIN
		RAISERROR ('One of more required parameters are missing.', 16, 1)
		RETURN;
	END

	    -- Check for MinAcceptableResult < MaxAcceptableResult
    IF @MinAcceptableResult >= @MaxAcceptableResult
    BEGIN
        RAISERROR ('MinAcceptableResult must be less than MaxAcceptableResult.', 16, 1)
        RETURN;
    END
	INSERT INTO Test(TestID, UserAccountID, SOPID, MinAcceptableResult, MaxAcceptableResult)
	VALUES(NEXT VALUE FOR TestSeq, (SELECT UserAccountID FROM UserAccount WHERE AccountUsername = @AccountUserName),
		(SELECT SOPID FROM SOP WHERE SOPName = @SOPName),@MinAcceptableResult, @MaxAcceptableResult);
END;
GO

CREATE PROCEDURE AddSampleTestLink @TestingAnalyst VARCHAR(64), @ReviewingAnalyst VARCHAR(64), @TestResult DECIMAL(10,6), @Deadline DATETIME, @SOPName VARCHAR(16)
AS
BEGIN
    -- Validate the input parameters
    IF @TestingAnalyst IS NULL OR @ReviewingAnalyst IS NULL OR @TestResult IS NULL OR @Deadline IS NULL OR @SOPName IS NULL
    BEGIN
        RAISERROR ('One or more required parameters are missing.', 16, 1)
        RETURN;
    END

    -- Variables to store the acceptable results fetched from the Test table
    DECLARE @MinAcceptableResult DECIMAL(10,6)
    DECLARE @MaxAcceptableResult DECIMAL(10,6)
	DECLARE @SOPID DECIMAL(12) = (SELECT SOPID FROM SOP WHERE SOPName = @SOPName)
    DECLARE @TestID DECIMAL(12) = (SELECT TestID FROM Test WHERE SOPID = @SOPID)

    -- Fetch the acceptable results from the Test table
    SELECT 
        @MinAcceptableResult = MinAcceptableResult,
        @MaxAcceptableResult = MaxAcceptableResult
    FROM Test
    WHERE TestID = @TestID

    -- Determine Pass or Fail based on the test results
    DECLARE @PassOrFail BIT
    IF @TestResult >= @MinAcceptableResult AND @TestResult <= @MaxAcceptableResult
        SET @PassOrFail = 1
    ELSE
        SET @PassOrFail = 0

    -- Insert the test link into SampleTestLink
    INSERT INTO SampleTestLink(SampleTestLinkID, SampleID, TestID, TestingAnalyst, ReviewingAnalyst, TestResult, Deadline, PassOrFail)
    VALUES(NEXT VALUE FOR SampleTestLinkSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'SampleSeq')),
        @TestID, @TestingAnalyst, @ReviewingAnalyst, @TestResult, @Deadline, @PassOrFail);
END;
GO

CREATE PROCEDURE AddTestEquipmentLink @SOPName VARCHAR(16)
AS
BEGIN
	IF @SOPName IS NULL
    BEGIN
        RAISERROR ('SOP name is required.', 16, 1);
        RETURN;
	END
	DECLARE @SOPID DECIMAL(12) = (SELECT SOPID FROM SOP WHERE SOPName = @SOPName)
    DECLARE @TestID DECIMAL(12) = (SELECT TestID FROM Test WHERE SOPID = @SOPID)

	INSERT INTO TestEquipmentLink(TestEquipmentLinkID, TestID, EquipmentID)
	VALUES(NEXT VALUE FOR TestEquipmentLinkSeq, @TestID,
		CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'EquipmentSeq')));
END;
GO

-------------------------------------NEW Stored Procedures---------------------------------------
CREATE PROCEDURE AddClient @ClientName VARCHAR(64)
AS
BEGIN
    IF @ClientName IS NULL
    BEGIN
        RAISERROR ('Client name is required.', 16, 1);
        RETURN;
    END

    INSERT INTO Client (ClientID, ClientName)
    VALUES (NEXT VALUE FOR ClientSeq, @ClientName);
END;
GO

CREATE PROCEDURE AddWarehouseClientLink @WarehouseFacility VARCHAR(64), @ClientName VARCHAR(64), @QuantityShipped DECIMAL(4), @DeliveryService VARCHAR(64), @ShippingTime DATETIME, @DeliveryTime DATETIME, @AcceptableDelivery BIT
AS
BEGIN
    IF @WarehouseFacility IS NULL OR @ClientName IS NULL OR @DeliveryService IS NULL OR @ShippingTime IS NULL OR @DeliveryTime IS NULL
    BEGIN
        RAISERROR ('All parameters are required except for QuantityShipped and AcceptableDelivery.', 16, 1);
        RETURN;
    END

    INSERT INTO WarehouseClientLink (WarehouseClientLinkID, WarehouseID, ClientID, QuantityShipped, DeliveryService, ShippingTime, DeliveryTime, AcceptableDelivery)
    VALUES (NEXT VALUE FOR WarehouseClientLinkSeq, (SELECT WarehouseID FROM Warehouse WHERE WarehouseFacility = @WarehouseFacility), (SELECT ClientID FROM Client WHERE ClientName = @ClientName), @QuantityShipped, @DeliveryService, @ShippingTime, @DeliveryTime, @AcceptableDelivery);
END;
GO

CREATE PROCEDURE AddMaintenanceLog @SOPName VARCHAR(16), @ServiceDate DATE, @ServiceDescription VARCHAR(4000), @ServiceInterval VARCHAR(64), @NextServiceDate DATE
AS
BEGIN
    IF @SOPName IS NULL OR @ServiceDate IS NULL OR @ServiceDescription IS NULL OR @ServiceInterval IS NULL OR @NextServiceDate IS NULL
    BEGIN
        RAISERROR ('All parameters are required.', 16, 1);
        RETURN;
    END

    INSERT INTO MaintenanceLog (MaintenanceLogID, EquipmentID, SOPID, ServiceDate, ServiceDescription, ServiceInterval, NextServiceDate)
    VALUES (NEXT VALUE FOR MaintenanceLogSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'EquipmentSeq')),(SELECT SOPID FROM SOP WHERE SOPName = @SOPName), @ServiceDate, @ServiceDescription, @ServiceInterval, @NextServiceDate);
END;
GO


--TRIGGERS

CREATE OR ALTER TRIGGER VersionChangeTrigger
ON SOP
AFTER UPDATE
AS
BEGIN
	DECLARE @OldVersionNumber DECIMAL(3,1) = (SELECT VersionNumber FROM DELETED);
	DECLARE @NewVersionNumber DECIMAL(3,1) = (SELECT VersionNumber FROM INSERTED);
	DECLARE @OldEffectiveDate DATE = (SELECT EffectiveDate FROM DELETED);
	DECLARE @NewEffectiveDate DATE = (SELECT EffectiveDate FROM INSERTED);

	IF (@OldVersionNumber <> @NewVersionNumber AND @OldEffectiveDate <> @NewEffectiveDate)
		INSERT INTO VersionChange(VersionChangeID, OldVersionNumber, NewVersionNumber, OldEffectiveDate, NewEffectiveDate, SOPID, ChangeDate)
		VALUES(NEXT VALUE FOR VersionChangeSeq, @OldVersionNumber, @NewVersionNumber, @OldEffectiveDate, @NewEffectiveDate,
			   (SELECT SOPID FROM INSERTED), GETDATE());
END;

--INSERTS
----------------------------------------------------------------UserAccounts-------------------------------------------------------------------
-- QC Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'hirmezb', 'Benel', 'Hirmez', '(209)676-7349', 'hirmezb@gene.com', 'Quality Control', 1, 'T', 'F', 3, 'michaelk', 'F';
COMMIT TRANSACTION AddUserAccount;
-- Warehouse Technician
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'diazl', 'Luis', 'Diaz', '(209)123-4567', 'diazl@gene.com', 'Warehouse Shipping', 1, 'T', 'F', 2, 'jacobs', 'F';
COMMIT TRANSACTION AddUserAccount;
-- Warehouse Technician
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'jeffreyc', 'Colt', 'Jeffrey', '(615)234-1827', 'jeffreyc@gene.com', 'Warehouse Shipping', 1, 'T', 'F', 3, 'marks', 'F';
COMMIT TRANSACTION AddUserAccount;
-- Warehouse Technician
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'dykej', 'Jeffrey', 'Dyke', '(631)821-3247', 'dykej@gene.com', 'Warehouse Shipping', 0, 'T', 'F', 2, 'johnw', 'F';
COMMIT TRANSACTION AddUserAccount;
-- Warehouse Technician
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'ackermanc', 'Colton', 'Ackerman', '(618)626-4531', 'ackermanc@gene.com', 'Warehouse Shipping', 1, 'T', 'F', 3, 'leeh', 'F';
COMMIT TRANSACTION AddUserAccount;
-- Warehouse Technician
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'jamesl', 'Landon', 'James', '(918)123-4567', 'jamesl@gene.com', 'Warehouse Shipping', 0, 'T', 'F', 2, 'lukes', 'F';
COMMIT TRANSACTION AddUserAccount;
-- QC Supervisor and Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'michaelk', 'Kevin', 'Michael', '(615)373-1820', 'michaelk@gene.com', 'Quality Control', 1, 'T', 'T', 5, 'leej', 'T';
COMMIT TRANSACTION AddUserAccount;
-- Warehouse Supervisor
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'jacobs', 'Sarah', 'Jacob', '(209)818-6231', 'jacobs@gene.com', 'Warehouse Shipping', 0, 'F', 'T', NULL, NULL, 'T';
COMMIT TRANSACTION AddUserAccount;
-- QC Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'leej', 'Jonathan', 'Lee', '(615)820-1346', 'leej@gene.com', 'Quality Control', 0, 'T', 'F', 4, 'michaelk', 'F';
COMMIT TRANSACTION AddUserAccount;
-- QC Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'smithj', 'John', 'Smith', '(615)234-5678', 'smithj@gene.com', 'Quality Control', 1, 'T', 'F', 3, 'miller', 'F';
COMMIT TRANSACTION AddUserAccount;
-- QC Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'leew', 'Wendy', 'Lee', '(615)345-6789', 'leew@gene.com', 'Quality Control', 0, 'T', 'F', 5, 'smithj', 'F';
COMMIT TRANSACTION AddUserAccount;
-- QC Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'brownm', 'Michael', 'Brown', '(615)456-7890', 'brownm@gene.com', 'Quality Control', 1, 'T', 'T', 5, 'leej', 'T';
COMMIT TRANSACTION AddUserAccount;

-------------------------------NEW UserAccount Entries-------------------------------------
-- QC Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'doej', 'John', 'Doe', '555-1234', 'john.doe@gene.com', 'Quality Control', 1, 'T', 'F', 2, 'smithj', NULL;
COMMIT TRANSACTION AddUserAccount;
-- Research Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'smithjane', 'Jane', 'Smith', '555-5678', 'jane.smith@gene.com', 'Research', 1, 'T', 'F', 3, 'coltonj', NULL;
COMMIT TRANSACTION AddUserAccount;
-- Logistics Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'browns', 'Sam', 'Brown', '555-9101', 'sam.brown@gene.com', 'Logistics', 1, 'T', 'F', 2, 'lewisk', NULL;
COMMIT TRANSACTION AddUserAccount;
-- QC Analyst
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'jonesl', 'Lisa', 'Jones', '555-1122', 'lisa.jones@gene.com', 'Quality Control', 1, 'T', 'F', 4, 'smithj', NULL;
COMMIT TRANSACTION AddUserAccount;
-- Research Supervisor (Administrator)
BEGIN TRANSACTION AddUserAccount
EXECUTE AddUserAccount 'wilsonm', 'Mark', 'Wilson', '555-1314', 'mark.wilson@gene.com', 'Research', 1, 'F', 'T', NULL, NULL, 'T';
COMMIT TRANSACTION AddUserAccount;

------------------------------------------------------------------SOPs----------------------------------------------------------------------
-- Testing SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'Q12398', 5.1,'12-Sep-2023';
COMMIT TRANSACTION AddSOP;

-- Testing SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'Q12318', 6.4,'08-Mar-2024';
COMMIT TRANSACTION AddSOP;

-- Testing SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'Q12727', 2.0,'06-Jul-2018';
COMMIT TRANSACTION AddSOP;

-- Testing SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'Q12440', 7.0,'18-Aug-2023';
COMMIT TRANSACTION AddSOP;

-- Testing SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'Q12425', 6.4,'08-Mar-2024';
COMMIT TRANSACTION AddSOP;

-- Balance Use SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'Q12280', 4.2,'05-May-2023';
COMMIT TRANSACTION AddSOP;

-- Pipette Use SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'Q12290', 3.0,'05-May-2022';
COMMIT TRANSACTION AddSOP;

-- Warehouse Shipping SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112520', 2.4,'22-Feb-2020';
COMMIT TRANSACTION AddSOP;

-- NEW Warehouse Shipping SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112521', 2.2,'22-Feb-2021';
COMMIT TRANSACTION AddSOP;

-- NEW Warehouse Shipping SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112522', 1.4,'22-Feb-2019';
COMMIT TRANSACTION AddSOP;

-- NEW Warehouse Shipping SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112523', 2.5,'16-Mar-2021';
COMMIT TRANSACTION AddSOP;

-- NEW Warehouse Shipping SOP
BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112524', 3.1,'18-Jan-2023';
COMMIT TRANSACTION AddSOP;

-------------NEW Equipment Maintenance SOP Entries-----------------------

BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112525', 1.0, '2023-01-01';
COMMIT TRANSACTION AddSOP;

BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112526', 1.1, '2023-02-01';
COMMIT TRANSACTION AddSOP;

BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112527', 1.2, '2023-03-01';
COMMIT TRANSACTION AddSOP;

BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112528', 1.3, '2023-04-01';
COMMIT TRANSACTION AddSOP;

BEGIN TRANSACTION AddSOP
EXECUTE AddSOP 'SAM-0112529', 1.4, '2023-05-01';
COMMIT TRANSACTION AddSOP;
------------------------------------------------------------------Warehouses--------------------------------------------------------------------
-- Warehouses across the company share the same SOP for shipping

-- Vacaville Warehouse
BEGIN TRANSACTION AddGenentechWarehouse
EXECUTE AddGenentechWarehouse 'diazl', 'Vacaville', 'Genentech Roche', 'SAM-0112520';
COMMIT TRANSACTION AddWarehouse;

-- South San Francisco Warehouse
BEGIN TRANSACTION AddGenentechWarehouse
EXECUTE AddGenentechWarehouse 'jeffreyc', 'South San Francisco', 'Genentech Roche', 'SAM-0112521';
COMMIT TRANSACTION AddWarehouse;

-- Oceanside Warehouse
BEGIN TRANSACTION AddGenentechWarehouse
EXECUTE AddGenentechWarehouse 'dykej', 'Oceanside', 'Genentech Roche', 'SAM-0112522';
COMMIT TRANSACTION AddWarehouse;

-- Hillsboro Warehouse
BEGIN TRANSACTION AddGenentechWarehouse
EXECUTE AddGenentechWarehouse 'ackermanc', 'Hillsboro', 'Genentech Roche', 'SAM-0112523';
COMMIT TRANSACTION AddGenentechWarehouse;

-- Louisville Warehouse
BEGIN TRANSACTION AddGenentechWarehouse
EXECUTE AddGenentechWarehouse 'jamesl', 'Louisville', 'Genentech Roche', 'SAM-0112524';
COMMIT TRANSACTION AddGenentechWarehouse;

----------------NEW Client Entries------------------------
BEGIN TRANSACTION AddClient
EXECUTE AddClient 'Client A';
COMMIT TRANSACTION AddClient;

BEGIN TRANSACTION AddClient
EXECUTE AddClient 'Client B';
COMMIT TRANSACTION AddClient;

BEGIN TRANSACTION AddClient
EXECUTE AddClient 'Client C';
COMMIT TRANSACTION AddClient;

BEGIN TRANSACTION AddClient
EXECUTE AddClient 'Client D';
COMMIT TRANSACTION AddClient;

BEGIN TRANSACTION AddClient
EXECUTE AddClient 'Client E';
COMMIT TRANSACTION AddClient;
---------------------------------------Test Queries-------------------------------------------------------------------------

-- Test #1
BEGIN TRANSACTION AddTest
EXECUTE AddTest 'Q12398', 4.280, 4.290, 'hirmezb';
COMMIT TRANSACTION AddTest;
-- Test #2
BEGIN TRANSACTION AddTest
EXECUTE AddTest 'Q12318', 0.670, 0.675, 'leej';
COMMIT TRANSACTION AddTest;
-- Test #3
BEGIN TRANSACTION AddTest
EXECUTE AddTest 'Q12727', 12.50, 12.54, 'smithj';
COMMIT TRANSACTION AddTest;
-- Test #4
BEGIN TRANSACTION AddTest
EXECUTE AddTest 'Q12440', 1.270, 1.275, 'leej';
COMMIT TRANSACTION AddTest;
-- Test #5
BEGIN TRANSACTION AddTest
EXECUTE AddTest 'Q12425', 3.250, 3.258, 'smithj';
COMMIT TRANSACTION AddTest;

-------------------------------------Compound Queries-----------------------------------------------

-- Sample Storage Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation '-80C Freezer', 82223;
COMMIT TRANSACTION AddLocation;
-- InProcess Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'rhuMAb 2C4', 'SSEPHL1', 16, 'I', '-80C', 'Vacaville', 'Q12398', '2024-04-14T14:26:10', NULL, NULL;
COMMIT TRANSACTION AddSample;
-- SampleTestLink depends on Sample
BEGIN TRANSACTION
EXECUTE AddSampleTestLink 'hirmezb', 'leej', 4.286, '2024-04-14T16:26:10', 'Q12398';
COMMIT TRANSACTION AddSampleTestLink;

-- InProcess Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'rhuMAb 2C4', 'SSEPHL2', 8, 'I', '-80C', 'Vacaville', 'Q12318', '2024-04-14T16:18:19', NULL, NULL;
COMMIT TRANSACTION AddSample;
-- SampleTestLink depends on Sample
BEGIN TRANSACTION
EXECUTE AddSampleTestLink 'leej', 'hirmezb', 0.669, '2024-04-14T16:18:19', 'Q12318';
COMMIT TRANSACTION AddSampleTestLink;

-- InProcess Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'rhuMAb 2C4', 'CLARCC', 4, 'I', '-80C', 'Vacaville', 'Q12727', '2024-04-14T14:42:14', NULL, NULL;
COMMIT TRANSACTION AddSample;
-- SampleTestLink depends on Sample
BEGIN TRANSACTION
EXECUTE AddSampleTestLink 'smithj', 'leew', 12.51, '2024-04-14T17:42:14', 'Q12727';
COMMIT TRANSACTION AddSampleTestLink;

-- Sample Storage Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation '-20C Freezer', 82224;
COMMIT TRANSACTION AddLocation;
-- InProcess Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'Tocilizumab IV', 'PROTAPL', 12, 'I', '-80C', 'Vacaville', 'Q12398', '2024-04-14T12:26:34', NULL, NULL;
COMMIT TRANSACTION AddSample;
-- InProcess Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'Tocilizumab IV', 'VFPL', 12, 'I', '-80C', 'Vacaville', 'Q12440', '2024-04-14T13:20:06', NULL, NULL;
COMMIT TRANSACTION AddSample;

-- Sample Storage Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation '2-8C Refrigerator', 42228;
COMMIT TRANSACTION AddLocation;
-- Stability Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'Tocilizumab SC', '30KDPL', 13, 'S', '-80C', 'Vacaville', 'Q12425', NULL, '5C_30Days', NULL;
COMMIT TRANSACTION AddSample;
-- SampleTestLink depends on Sample
BEGIN TRANSACTION
EXECUTE AddSampleTestLink 'smithj', 'michaelk', 3.252, '2024-05-13T23:59:59', 'Q12425';
COMMIT TRANSACTION AddSampleTestLink;

-- Stability Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'Tocilizumab SC', '30KDTOC', 13, 'S', '-80C', 'Vacaville', 'Q12425', NULL, '5C_30Days', NULL;
COMMIT TRANSACTION AddSample;
-- Stability Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample '2H7', 'VFPL', 12, 'S', '-80C', 'Vacaville', 'Q12398', NULL, '5C_120Days', NULL;
COMMIT TRANSACTION AddSample;
-- Stability Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'rhuMAb 2C4', 'CONBUF', 16, 'S', '-80C', 'Vacaville', 'Q12318', NULL, '5C_180Days', NULL;
COMMIT TRANSACTION AddSample;
-- Stability Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'rhuMAb 2C4', 'CONBUF2', 16, 'S', '-80C', 'Vacaville', 'Q12318', NULL, '5C_180Days', NULL;
COMMIT TRANSACTION AddSample;

-- Sample Storage Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation '-80C Freezer', 42228;
COMMIT TRANSACTION AddLocation;
-- FinishedProduct Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'Tocilizumab IV', 'FILTBFS', 12, 'F', '-80C', 'Vacaville', 'Q12440', NULL, NULL, 123456789;
COMMIT TRANSACTION AddSample;
-- SampleTestLink depends on Sample
BEGIN TRANSACTION
EXECUTE AddSampleTestLink 'leej', 'michaelk', 1.273, '2024-04-14T11:40:12', 'Q12440';
COMMIT TRANSACTION AddSampleTestLink;

-- FinishedProduct Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'Tocilizumab IV', 'FILTBFS-C', 12, 'F', '-80C', 'Vacaville', 'Q12440', NULL, NULL, 987654321;
COMMIT TRANSACTION AddSample;
-- FinishedProduct Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'rhuMAb 2C4', 'FILTBFS', 12, 'F', '-80C', 'Vacaville', 'Q12440', NULL, NULL, 246891113;
COMMIT TRANSACTION AddSample;
-- FinishedProduct Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'rhuMAb 2C4', 'FILTBFS', 12, 'F', '-80C', 'Vacaville', 'Q12440', NULL, NULL, 369121518;
COMMIT TRANSACTION AddSample;
-- FinishedProduct Sample depends on location
BEGIN TRANSACTION AddSample
EXECUTE AddSample 'rhuMAb 2C4', 'FILTBFS-C', 12, 'F', '-80C', 'Vacaville', 'Q12440', NULL, NULL, 481216201;
COMMIT TRANSACTION AddSample;

-- Equipment Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation 'Room', 82225;
COMMIT TRANSACTION AddLocation;
-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'Q12280'), 'Micro Balance', 0.002, 0.100, 1);
-- TestEquipmentLink depends on equipment
BEGIN TRANSACTION AddTestEquipmentLink
EXECUTE AddTestEquipmentLink 'Q12398';
COMMIT TRANSACTION AddTestEquipmentLink;

-- Equipment Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation 'Room', 82227;
COMMIT TRANSACTION AddLocation;
-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'Q12280'), 'Balance', 0.500, 1.200, 1);
-- TestEquipmentLink depends on equipment
BEGIN TRANSACTION AddTestEquipmentLink
EXECUTE AddTestEquipmentLink 'Q12318';
COMMIT TRANSACTION AddTestEquipmentLink;

-- Equipment Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation 'Room', 83225;
COMMIT TRANSACTION AddLocation;
-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'Q12280'), 'Balance', 100.00, 500.00, 1);
-- TestEquipmentLink depends on equipment
BEGIN TRANSACTION AddTestEquipmentLink
EXECUTE AddTestEquipmentLink 'Q12727';
COMMIT TRANSACTION AddTestEquipmentLink;

-- Equipment Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation 'Room', 52238;
COMMIT TRANSACTION AddLocation;
-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'Q12290'), '10uL Pipette', 1.000, 10.00, 1);
-- TestEquipmentLink depends on equipment
BEGIN TRANSACTION AddTestEquipmentLink
EXECUTE AddTestEquipmentLink 'Q12440';
COMMIT TRANSACTION AddTestEquipmentLink;

-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'Q12290'), '500uL Pipette', 100.00, 500.00, 1);
-- TestEquipmentLink depends on equipment
BEGIN TRANSACTION AddTestEquipmentLink
EXECUTE AddTestEquipmentLink 'Q12425';
COMMIT TRANSACTION AddTestEquipmentLink;

---------------------NEW Equipment and MaintenanceLog Entries---------------------------------------
-- Equipment Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation 'Lab Aisle', 101;
COMMIT TRANSACTION AddLocation;
-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'SAM-0112525'), 'Microscope', 0.500, 1.200, 1);
-- MaintenanceLog depends on Equipment
BEGIN TRANSACTION AddMaintenanceLog
EXECUTE AddMaintenanceLog 'SAM-0112525', '2024-04-01', 'Routine check', 'Monthly', '2024-05-01';
COMMIT TRANSACTION AddMaintenanceLog;

-- Equipment Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation 'Lab Aisle', 102;
COMMIT TRANSACTION AddLocation;
-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'SAM-0112526'), 'Biological Safety Cabinet', 0.500, 1.200, 1);
-- MaintenanceLog depends on Equipment
BEGIN TRANSACTION AddMaintenanceLog
EXECUTE AddMaintenanceLog 'SAM-0112526', '2023-10-02', 'Clean and calibrate', 'Bi-Weekly', '2023-10-16';
COMMIT TRANSACTION AddMaintenanceLog;

-- Equipment Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation 'Lab Aisle', 103;
COMMIT TRANSACTION AddLocation;
-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'SAM-0112527'), 'HPLC', 0.500, 1.200, 1);
-- MaintenanceLog depends on Equipment
BEGIN TRANSACTION AddMaintenanceLog
EXECUTE AddMaintenanceLog 'SAM-0112527', '2023-10-03', 'Software update', 'Yearly', '2024-10-03';
COMMIT TRANSACTION AddMaintenanceLog;

-- Equipment Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation 'Lab Aisle', 104;
COMMIT TRANSACTION AddLocation;
-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'SAM-0112528'), 'LAL Analyzer', 0.500, 1.200, 1);
-- MaintenanceLog depends on Equipment
BEGIN TRANSACTION AddMaintenanceLog
EXECUTE AddMaintenanceLog 'SAM-0112528', '2023-10-04', 'Pressure test', 'Annual', '2024-10-04';
COMMIT TRANSACTION AddMaintenanceLog;

-- Equipment Location
BEGIN TRANSACTION AddLocation
EXECUTE AddLocation 'Lab Aisle', 105;
COMMIT TRANSACTION AddLocation;
-- Equipment depends on location
INSERT INTO Equipment(EquipmentID, LocationID, SOPID, EquipmentName, MinUseRange, MaxUseRange, InUse)
VALUES(NEXT VALUE FOR EquipmentSeq, CONVERT(DECIMAL(38,0), (SELECT current_value FROM sys.sequences WHERE name = 'LocationSeq')),
	(SELECT SOPID FROM SOP WHERE SOPName = 'SAM-0112529'), 'UV Spectrophotometer', 0.500, 1.200, 1);
-- MaintenanceLog depends on Equipment
BEGIN TRANSACTION AddMaintenanceLog
EXECUTE AddMaintenanceLog 'SAM-0112529', '2023-10-05', 'Accuracy verification', 'Quarterly', '2024-01-05';
COMMIT TRANSACTION AddMaintenanceLog;

--------------NEW WarehouseClientLink Insertions--------------------
BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'Vacaville', 'Client A', 160, 'FastTrack Logistics', '2023-10-01 08:00:00', '2023-10-01 12:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;

BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'South San Francisco', 'Client B', 120, 'Fedex', '2023-10-02 09:00:00', '2023-10-02 13:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;

BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'Oceanside', 'Client C', 140, 'Fedex', '2023-10-03 07:00:00', '2023-10-03 10:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;

BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'Hillsboro', 'Client D', 90, 'FastTrack Logistics', '2023-10-04 10:00:00', '2023-10-04 15:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;

BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'Hillsboro', 'Client D', 110, 'FastTrack Logistics', '2022-07-04 13:00:00', '2022-07-04 15:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;

BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'Louisville', 'Client E', 1200, 'FastTrack Logistics', '2023-10-05 06:00:00', '2023-10-05 08:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;

BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'Louisville', 'Client A', 200, 'FastTrack Logistics', '2023-10-05 03:00:00', '2023-10-05 08:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;

BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'Oceanside', 'Client E', 140, 'FastTrack Logistics', '2023-10-03 07:00:00', '2023-10-03 10:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;

BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'Oceanside', 'Client A', 140, 'Fedex', '2023-10-03 07:00:00', '2023-10-03 10:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;

BEGIN TRANSACTION AddWarehouseClientLink
EXECUTE AddWarehouseClientLink 'Oceanside', 'Client B', 140, 'Fedex', '2023-10-03 07:00:00', '2023-10-03 10:00:00', 1;
COMMIT TRANSACTION AddWarehouseClientLink;


--QUERIES

--------Query for Question 1--------

SELECT W.WarehouseFacility, C.ClientName, SOP.SOPName,
    AVG(DATEDIFF(hour, WL.ShippingTime, WL.DeliveryTime)) AS AverageDeliveryTimeInHours
FROM WarehouseClientLink WL
JOIN Warehouse W ON WL.WarehouseID = W.WarehouseID
JOIN Client C ON WL.ClientID = C.ClientID
JOIN SOP ON W.SOPID = SOP.SOPID
WHERE WL.DeliveryService = 'FastTrack Logistics'
GROUP BY W.WarehouseFacility, C.ClientName, SOP.SOPName
ORDER BY AverageDeliveryTimeInHours;

----Proof That Above Query works-------
SELECT W.WarehouseFacility, C.ClientName, WL.DeliveryService, SOP.SOPName,
    WL.ShippingTime, WL.DeliveryTime
FROM WarehouseClientLink WL
JOIN Warehouse W ON WL.WarehouseID = W.WarehouseID
JOIN Client C ON WL.ClientID = C.ClientID
JOIN SOP ON W.SOPID = SOP.SOPID;

--------Query for Question 2--------

SELECT U.AccountUsername, U.FirstName, U.LastName, U.Email,
    A.AccessLevel AS AnalystAccessLevel, A.AnalystSupervisor,
    CASE 
		WHEN U.TrainingCompleted = 1 THEN 'Completed' 
		ELSE 'Pending' 
	END AS TrainingStatus
FROM UserAccount U
LEFT JOIN Analyst A ON U.UserAccountID = A.UserAccountID
LEFT JOIN UserSOPAction S ON U.UserAccountID = S.UserAccountID
WHERE U.IsAnalyst = 'T' AND U.Department = 'Quality Control'
GROUP BY U.AccountUsername, U.FirstName, U.LastName, U.Email, U.TrainingCompleted, A.AccessLevel, A.AnalystSupervisor
ORDER BY U.LastName, U.FirstName;

----------Proof That Above Query Works-----------------
SELECT U.AccountUsername, U.FirstName, U.LastName, U.Email, U.TrainingCompleted, U.Department, 
	U.IsAnalyst, U.IsAdministrator, A.AccessLevel AS AnalystAccessLevel, A.AnalystSupervisor,
    CASE 
		WHEN U.TrainingCompleted = 1 THEN 'Completed' 
		ELSE 'Pending' 
	END AS TrainingStatus
FROM UserAccount U
LEFT JOIN Analyst A ON U.UserAccountID = A.UserAccountID
LEFT JOIN UserSOPAction S ON U.UserAccountID = S.UserAccountID
GROUP BY U.AccountUsername, U.FirstName, U.LastName, U.Email, U.TrainingCompleted, U.Department, U.IsAnalyst, U.IsAdministrator, A.AccessLevel, A.AnalystSupervisor
ORDER BY U.LastName, U.FirstName;

--------Query for Question 3--------

DROP VIEW EquipmentMaintenanceForecast;

-- Creating the view (Must be executed first before using view below)
CREATE VIEW EquipmentMaintenanceForecast AS
SELECT E.EquipmentName, ML.ServiceDate, ML.NextServiceDate,
    ML.ServiceInterval, DATEDIFF(day, GETDATE(), ML.NextServiceDate) AS DaysUntilNextService,
    AVG(DATEDIFF(day, ML.ServiceDate, ML.NextServiceDate)) OVER (PARTITION BY E.EquipmentName) AS AvgServicePeriod
FROM MaintenanceLog ML
JOIN Equipment E ON ML.EquipmentID = E.EquipmentID
WHERE ML.NextServiceDate > GETDATE();  -- Using WHERE to restrict to upcoming services

-- Using the view in a query
SELECT *,
    CASE 
        WHEN DaysUntilNextService <= AvgServicePeriod THEN 'Service Soon'
        ELSE 'Service on Schedule'
    END AS ServiceStatus
FROM EquipmentMaintenanceForecast
ORDER BY DaysUntilNextService;

--------Proof That Above VIEW Works----------------

SELECT E.EquipmentName, ML.ServiceDate, ML.NextServiceDate, ML.ServiceInterval
FROM MaintenanceLog ML
JOIN Equipment E ON ML.EquipmentID = E.EquipmentID;

-------------Queries for VersionChange (history table) Verification----------------
SELECT *
FROM SOP;

UPDATE SOP
SET VersionNumber = 2.5, EffectiveDate = '20-Mar-2023'
WHERE SOPID = 1;

UPDATE SOP
SET VersionNumber = 2.6, EffectiveDate = '20-Apr-2024'
WHERE SOPID = 1;

SELECT *
FROM VersionChange;

------------------Data Visualization Query #1--------------------------

SELECT WarehouseFacility, COUNT(*) AS TotalClients
FROM Warehouse
JOIN WarehouseClientLink ON Warehouse.WarehouseID = WarehouseClientLink.WarehouseID
GROUP BY WarehouseFacility
ORDER BY TotalClients DESC;

------------------Data Visualization History Table Updates--------------------------

-- Execute the first TWO updates only if you did not update them already above!!
SELECT *
FROM SOP;

UPDATE SOP
SET VersionNumber = 2.5, EffectiveDate = '20-Mar-2023'
WHERE SOPID = 1;
UPDATE SOP
SET VersionNumber = 2.6, EffectiveDate = '20-Apr-2024'
WHERE SOPID = 1;


UPDATE SOP
SET VersionNumber = 2.3, EffectiveDate = '21-Apr-2024'
WHERE SOPID = 2;
UPDATE SOP
SET VersionNumber = 1.5, EffectiveDate = '21-Apr-2024'
WHERE SOPID = 3;
UPDATE SOP
SET VersionNumber = 2.6, EffectiveDate = '21-Apr-2024'
WHERE SOPID = 4;
UPDATE SOP
SET VersionNumber = 3.2, EffectiveDate = '21-Apr-2022'
WHERE SOPID = 5;
UPDATE SOP
SET VersionNumber = 3.3, EffectiveDate = '21-Jul-2023'
WHERE SOPID = 5;
UPDATE SOP
SET VersionNumber = 3.4, EffectiveDate = '21-Apr-2024'
WHERE SOPID = 5;
UPDATE SOP
SET VersionNumber = 1.1, EffectiveDate = '21-Apr-2024'
WHERE SOPID = 6;
UPDATE SOP
SET VersionNumber = 1.2, EffectiveDate = '21-Jan-2021'
WHERE SOPID = 7;
UPDATE SOP
SET VersionNumber = 1.3, EffectiveDate = '21-Apr-2024'
WHERE SOPID = 7;
UPDATE SOP
SET VersionNumber = 1.3, EffectiveDate = '21-Apr-2024'
WHERE SOPID = 8;

SELECT *
FROM VersionChange;

------------Data Visualization Query #2-----------------
SELECT SOPName,
    AVG(DATEDIFF(day, OldEffectiveDate, NewEffectiveDate)) AS AverageDaysBetweenEffectiveDates
FROM 
    VersionChange
JOIN SOP ON VersionChange.SOPID = SOP.SOPID
GROUP BY 
    SOPName
ORDER BY 
    SOPName;
