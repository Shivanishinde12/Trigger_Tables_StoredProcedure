USE [eBS4_INT_QA2]
GO
/****** Object:  Trigger [UI].[DML_Trgr_DocumentLocation]    Script Date: 10/3/2022 10:52:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Name:
    [UI].[SPDmlDocumentLocation]

Purpose:
    To maintain records for DML operation performed on table [UI].[DocumentLocation] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  04/10/2022 by Shivani Shinde 
    Modified on ---------
*/

CREATE OR ALTER PROCEDURE  [UI].[SPDmlDocumentLocation]
AS
BEGIN
 SET NOCOUNT ON;

	DECLARE @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_DocumentLocation_CT])
	
	IF @Operation = 1
	BEGIN
		INSERT INTO [Trgr].[DocumentLocation]
		(		DocumentLocationID,			DocumentLocationCode,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentLocation_CT].DocumentLocationID, [cdc].[UI_DocumentLocation_CT].DocumentLocationCode,
		[cdc].[UI_DocumentLocation_CT].	MigrationID, [cdc].[UI_DocumentLocation_CT].	IsMigrated, 
		[cdc].[UI_DocumentLocation_CT].IsMigrationOverriden, [cdc].[UI_DocumentLocation_CT].	MigrationDate,
		4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentLocation_CT] WHERE __$Operation = 1 
	END

	ELSE IF @Operation = 2
	BEGIN
		INSERT INTO [Trgr].[DocumentLocation]
		(		DocumentLocationID,				DocumentLocationCode,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentLocation_CT].	DocumentLocationID, [cdc].[UI_DocumentLocation_CT].	DocumentLocationCode,
		[cdc].[UI_DocumentLocation_CT].	MigrationID, [cdc].[UI_DocumentLocation_CT].	IsMigrated,
		[cdc].[UI_DocumentLocation_CT].	IsMigrationOverriden, [cdc].[UI_DocumentLocation_CT].	MigrationDate,
		1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentLocation_CT] WHERE __$Operation = 2
	END

	ELSE IF @Operation = 3
	BEGIN
		INSERT INTO [Trgr].[DocumentLocation]
		(		DocumentLocationID,			DocumentLocationCode,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentLocation_CT].DocumentLocationID, [cdc].[UI_DocumentLocation_CT].DocumentLocationCode,
		[cdc].[UI_DocumentLocation_CT].	MigrationID, [cdc].[UI_DocumentLocation_CT].	IsMigrated, 
		[cdc].[UI_DocumentLocation_CT].IsMigrationOverriden, [cdc].[UI_DocumentLocation_CT].	MigrationDate,
		2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentLocation_CT] WHERE __$Operation = 3

		INSERT INTO [Trgr].[DocumentLocation]
		(		DocumentLocationID,			DocumentLocationCode,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentLocation_CT].DocumentLocationID, [cdc].[UI_DocumentLocation_CT].DocumentLocationCode,
		[cdc].[UI_DocumentLocation_CT].	MigrationID, [cdc].[UI_DocumentLocation_CT].	IsMigrated, 
		[cdc].[UI_DocumentLocation_CT].IsMigrationOverriden, [cdc].[UI_DocumentLocation_CT].	MigrationDate,
		3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentLocation_CT] WHERE __$Operation = 4
	END
END
