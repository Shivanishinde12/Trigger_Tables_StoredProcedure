USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlTargetProperty]

Purpose:
    To maintain records for DML operation performed on table [UI].[TargetProperty] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  27/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE or ALTER PROCEDURE [UI].[SpDmlTargetProperty]
AS
BEGIN
 SET NOCOUNT ON;
	DECLARE @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_TargetProperty_CT])

	IF @Operation = 1 --for delete
	BEGIN
		INSERT INTO [Trgr].[TargetProperty]
		(	TargetPropertyID,			TargetPropertyName,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_TargetProperty_CT].TargetPropertyID, [cdc].[UI_TargetProperty_CT].	TargetPropertyName,
		[cdc].[UI_TargetProperty_CT].MigrationID, [cdc].[UI_TargetProperty_CT].	IsMigrated, 
		[cdc].[UI_TargetProperty_CT].IsMigrationOverriden, [cdc].[UI_TargetProperty_CT].	MigrationDate,
		4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TargetProperty_CT] Where @Operation = 1
	END

	ELSE IF @Operation = 2  --for insert
	BEGIN
		INSERT INTO [Trgr].[TargetProperty]
		(		TargetPropertyID,			TargetPropertyName,				MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_TargetProperty_CT].	TargetPropertyID, [cdc].[UI_TargetProperty_CT].	TargetPropertyName,
		[cdc].[UI_TargetProperty_CT].	MigrationID, [cdc].[UI_TargetProperty_CT].	IsMigrated, 
		[cdc].[UI_TargetProperty_CT].	IsMigrationOverriden, [cdc].[UI_TargetProperty_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TargetProperty_CT] WHERE __$operation = 2 
	END

	ELSE IF @Operation = 3 --for update
	BEGIN
		INSERT INTO [Trgr].[TargetProperty]
		(	TargetPropertyID,			TargetPropertyName,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_TargetProperty_CT].TargetPropertyID, [cdc].[UI_TargetProperty_CT].	TargetPropertyName,
		[cdc].[UI_TargetProperty_CT].MigrationID, [cdc].[UI_TargetProperty_CT].	IsMigrated, 
		[cdc].[UI_TargetProperty_CT].IsMigrationOverriden, [cdc].[UI_TargetProperty_CT].	MigrationDate,
		2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TargetProperty_CT] where __$operation = 3

		INSERT INTO [Trgr].[TargetProperty]
		(	TargetPropertyID,			TargetPropertyName,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_TargetProperty_CT].TargetPropertyID, [cdc].[UI_TargetProperty_CT].	TargetPropertyName,
		[cdc].[UI_TargetProperty_CT].MigrationID, [cdc].[UI_TargetProperty_CT].	IsMigrated, 
		[cdc].[UI_TargetProperty_CT].IsMigrationOverriden, [cdc].[UI_TargetProperty_CT].	MigrationDate,
		3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TargetProperty_CT] where __$operation = 4
	END
END
