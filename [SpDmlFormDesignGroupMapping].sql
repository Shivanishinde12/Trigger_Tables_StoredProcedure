USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlFormDesignGroupMapping]

Purpose:
    To maintain records for DML operation performed on table [UI].[FormDesignGroupMapping] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  29/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlFormDesignGroupMapping]
AS
BEGIN
 SET NOCOUNT ON;

	DECLARE @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_FormDesignGroupMapping_CT])

	IF @Operation = 1 --For Delete
	BEGIN
			INSERT INTO [Trgr].[FormDesignGroupMapping]
			(		FormDesignGroupMappingID,			FormDesignGroupID,			FormID,			[Sequence],			AllowMultipleInstance,			AccessibleToRoles,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			SELECT [cdc].[UI_FormDesignGroupMapping_CT].	FormDesignGroupMappingID, [cdc].[UI_FormDesignGroupMapping_CT].	FormDesignGroupID,
			[cdc].[UI_FormDesignGroupMapping_CT].	FormID, [cdc].[UI_FormDesignGroupMapping_CT].[Sequence], 
			[cdc].[UI_FormDesignGroupMapping_CT].AllowMultipleInstance, [cdc].[UI_FormDesignGroupMapping_CT].	AccessibleToRoles,
			[cdc].[UI_FormDesignGroupMapping_CT].	MigrationID, [cdc].[UI_FormDesignGroupMapping_CT].	IsMigrated, 
			[cdc].[UI_FormDesignGroupMapping_CT].IsMigrationOverriden, [cdc].[UI_FormDesignGroupMapping_CT].	MigrationDate,
			4 as	DMLOperation, getdate() as	OperationDate
			FROM [cdc].[UI_FormDesignGroupMapping_CT] WHERE __$Operation = 1
	END
	
	ELSE IF @Operation = 2 --For Insert
	BEGIN
		INSERT INTO [Trgr].[FormDesignGroupMapping]
		(		FormDesignGroupMappingID,			FormDesignGroupID,			FormID,				[Sequence],				AllowMultipleInstance,			AccessibleToRoles,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_FormDesignGroupMapping_CT].FormDesignGroupMappingID, [cdc].[UI_FormDesignGroupMapping_CT].	FormDesignGroupID,
		[cdc].[UI_FormDesignGroupMapping_CT].FormID, [cdc].[UI_FormDesignGroupMapping_CT].	[Sequence], 
		[cdc].[UI_FormDesignGroupMapping_CT].	AllowMultipleInstance, [cdc].[UI_FormDesignGroupMapping_CT].AccessibleToRoles,
		[cdc].[UI_FormDesignGroupMapping_CT].MigrationID, [cdc].[UI_FormDesignGroupMapping_CT].	IsMigrated,
		[cdc].[UI_FormDesignGroupMapping_CT].	IsMigrationOverriden, [cdc].[UI_FormDesignGroupMapping_CT].	MigrationDate,
		1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignGroupMapping_CT] WHERE __$Operation = 2
	END

	ELSE IF @Operation = 3
	BEGIN
			INSERT INTO [Trgr].[FormDesignGroupMapping]
			(		FormDesignGroupMappingID,			FormDesignGroupID,			FormID,			[Sequence],			AllowMultipleInstance,			AccessibleToRoles,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
			SELECT [cdc].[UI_FormDesignGroupMapping_CT].	FormDesignGroupMappingID, [cdc].[UI_FormDesignGroupMapping_CT].	FormDesignGroupID,
			[cdc].[UI_FormDesignGroupMapping_CT].	FormID, [cdc].[UI_FormDesignGroupMapping_CT].[Sequence],
			[cdc].[UI_FormDesignGroupMapping_CT].AllowMultipleInstance, [cdc].[UI_FormDesignGroupMapping_CT].	AccessibleToRoles,
			[cdc].[UI_FormDesignGroupMapping_CT].	MigrationID, [cdc].[UI_FormDesignGroupMapping_CT].	IsMigrated,
			[cdc].[UI_FormDesignGroupMapping_CT].IsMigrationOverriden, [cdc].[UI_FormDesignGroupMapping_CT].	MigrationDate, 
			2 as	DMLOperation, getdate() as	OperationDate
			FROM [cdc].[UI_FormDesignGroupMapping_CT] WHERE __$Operation = 3

			INSERT INTO [Trgr].[FormDesignGroupMapping]
			(		FormDesignGroupMappingID,			FormDesignGroupID,			FormID,			[Sequence],			AllowMultipleInstance,			AccessibleToRoles,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
			SELECT [cdc].[UI_FormDesignGroupMapping_CT].	FormDesignGroupMappingID, [cdc].[UI_FormDesignGroupMapping_CT].	FormDesignGroupID,
			[cdc].[UI_FormDesignGroupMapping_CT].	FormID, [cdc].[UI_FormDesignGroupMapping_CT].[Sequence],
			[cdc].[UI_FormDesignGroupMapping_CT].AllowMultipleInstance, [cdc].[UI_FormDesignGroupMapping_CT].	AccessibleToRoles,
			[cdc].[UI_FormDesignGroupMapping_CT].	MigrationID, [cdc].[UI_FormDesignGroupMapping_CT].	IsMigrated,
			[cdc].[UI_FormDesignGroupMapping_CT].IsMigrationOverriden, [cdc].[UI_FormDesignGroupMapping_CT].	MigrationDate, 
			3 as	DMLOperation, getdate() as	OperationDate
			FROM [cdc].[UI_FormDesignGroupMapping_CT] WHERE __$Operation = 4
	END
End
