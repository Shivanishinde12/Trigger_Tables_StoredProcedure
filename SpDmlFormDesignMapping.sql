USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Name:
    [UI].[SpDmlFormDesignMapping]

Purpose:
    To maintain records for DML operation performed on table [UI].[FormDesignMapping] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  29/09/2022 by Shivani Shinde 
    Modified on ---------
*/

CREATE OR ALTER PROCEDURE [UI].[SpDmlFormDesignMapping]
AS
BEGIN
 SET NOCOUNT ON;

	DECLARE @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_FormDesignMapping_CT])

	IF @Operation = 1 --for delete
	BEGIN
		INSERT INTO [Trgr].[FormDesignMapping]
		(		FormDesignMapID,			AnchorDesignID,			TargetDesignID,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignMapping_CT].FormDesignMapID, [cdc].[UI_FormDesignMapping_CT].	AnchorDesignID,
		[cdc].[UI_FormDesignMapping_CT].TargetDesignID, [cdc].[UI_FormDesignMapping_CT].MigrationID, 
		[cdc].[UI_FormDesignMapping_CT].	IsMigrated, [cdc].[UI_FormDesignMapping_CT].	IsMigrationOverriden, 
		[cdc].[UI_FormDesignMapping_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignMapping_CT] WHERE __$Operation = 1
	END
	
	ELSE IF @Operation = 2 --for insert
	BEGIN
		INSERT INTO [Trgr].[FormDesignMapping]
		(		FormDesignMapID,			AnchorDesignID,				TargetDesignID,				MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignMapping_CT] .	FormDesignMapID, [cdc].[UI_FormDesignMapping_CT] .	AnchorDesignID,
		[cdc].[UI_FormDesignMapping_CT] .	TargetDesignID, [cdc].[UI_FormDesignMapping_CT] .	MigrationID,
		[cdc].[UI_FormDesignMapping_CT] .	IsMigrated, [cdc].[UI_FormDesignMapping_CT] .	IsMigrationOverriden, 
		[cdc].[UI_FormDesignMapping_CT] .	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignMapping_CT] WHERE __$Operation = 2
	END

	ELSE IF @Operation = 3 --for update 
	BEGIN
		INSERT INTO [Trgr].[FormDesignMapping]
		(		FormDesignMapID,			AnchorDesignID,			TargetDesignID,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignMapping_CT].FormDesignMapID, [cdc].[UI_FormDesignMapping_CT].	AnchorDesignID,
		[cdc].[UI_FormDesignMapping_CT].TargetDesignID, [cdc].[UI_FormDesignMapping_CT].MigrationID,
		[cdc].[UI_FormDesignMapping_CT].	IsMigrated, [cdc].[UI_FormDesignMapping_CT].	IsMigrationOverriden,
		[cdc].[UI_FormDesignMapping_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignMapping_CT] WHERE __$Operation = 3

		INSERT INTO [Trgr].[FormDesignMapping]
		(		FormDesignMapID,			AnchorDesignID,			TargetDesignID,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignMapping_CT].FormDesignMapID, [cdc].[UI_FormDesignMapping_CT].	AnchorDesignID,
		[cdc].[UI_FormDesignMapping_CT].TargetDesignID, [cdc].[UI_FormDesignMapping_CT].MigrationID,
		[cdc].[UI_FormDesignMapping_CT].	IsMigrated, [cdc].[UI_FormDesignMapping_CT].	IsMigrationOverriden,
		[cdc].[UI_FormDesignMapping_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignMapping_CT] WHERE __$Operation = 4
	END	
END
