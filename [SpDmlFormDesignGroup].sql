USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Name:
    [UI].[SpDmlFormDesignGroup]

Purpose:
    To maintain records for DML operation performed on table [UI].[FormDesignGroup] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  29/09/2022 by Shivani Shinde 
    Modified on ---------
*/

CREATE OR ALTER PROCEDURE [UI].[SpDmlFormDesignGroup]
AS
BEGIN
 SET NOCOUNT ON;

	DECLARE @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_FormDesignGroup_CT])

	IF @Operation = 1 --for delete
	BEGIN
		INSERT INTO [Trgr].[FormDesignGroup]
		(		FormDesignGroupID,			GroupName,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignGroup_CT].FormDesignGroupID, [cdc].[UI_FormDesignGroup_CT].	GroupName,
		[cdc].[UI_FormDesignGroup_CT].	TenantID, [cdc].[UI_FormDesignGroup_CT].	AddedBy, [cdc].[UI_FormDesignGroup_CT].	AddedDate,
		[cdc].[UI_FormDesignGroup_CT].	UpdatedBy, [cdc].[UI_FormDesignGroup_CT].	UpdatedDate, [cdc].[UI_FormDesignGroup_CT].	IsMasterList,
		[cdc].[UI_FormDesignGroup_CT].	MigrationID, [cdc].[UI_FormDesignGroup_CT].	IsMigrated, [cdc].[UI_FormDesignGroup_CT].IsMigrationOverriden,
		[cdc].[UI_FormDesignGroup_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignGroup_CT] WHERE __$Operation = 1
	END

	ELSE IF @Operation = 2 --for insert
	BEGIN
		INSERT INTO [Trgr].[FormDesignGroup]
		(		FormDesignGroupID,			GroupName,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignGroup_CT].	FormDesignGroupID, [cdc].[UI_FormDesignGroup_CT].GroupName,
		[cdc].[UI_FormDesignGroup_CT].TenantID, [cdc].[UI_FormDesignGroup_CT].	AddedBy, [cdc].[UI_FormDesignGroup_CT].	AddedDate,
		[cdc].[UI_FormDesignGroup_CT].UpdatedBy, [cdc].[UI_FormDesignGroup_CT].UpdatedDate, 
		[cdc].[UI_FormDesignGroup_CT].	IsMasterList, [cdc].[UI_FormDesignGroup_CT].	MigrationID,
		[cdc].[UI_FormDesignGroup_CT].	IsMigrated, [cdc].[UI_FormDesignGroup_CT].	IsMigrationOverriden, 
		[cdc].[UI_FormDesignGroup_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignGroup_CT] WHERE __$operation = 2
	END

	ELSE IF @Operation = 3 --for update
	BEGIN
		INSERT INTO [Trgr].[FormDesignGroup]
		(		FormDesignGroupID,			GroupName,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignGroup_CT].FormDesignGroupID, [cdc].[UI_FormDesignGroup_CT].	GroupName, 
		[cdc].[UI_FormDesignGroup_CT].	TenantID, [cdc].[UI_FormDesignGroup_CT].	AddedBy, [cdc].[UI_FormDesignGroup_CT].	AddedDate, 
		[cdc].[UI_FormDesignGroup_CT].	UpdatedBy, [cdc].[UI_FormDesignGroup_CT].	UpdatedDate, [cdc].[UI_FormDesignGroup_CT].	IsMasterList,
		[cdc].[UI_FormDesignGroup_CT].	MigrationID, [cdc].[UI_FormDesignGroup_CT].	IsMigrated, [cdc].[UI_FormDesignGroup_CT].IsMigrationOverriden,
		[cdc].[UI_FormDesignGroup_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignGroup_CT] WHERE __$Operation = 3

		INSERT INTO [Trgr].[FormDesignGroup]
		(		FormDesignGroupID,			GroupName,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignGroup_CT].FormDesignGroupID, [cdc].[UI_FormDesignGroup_CT].	GroupName, 
		[cdc].[UI_FormDesignGroup_CT].	TenantID, [cdc].[UI_FormDesignGroup_CT].	AddedBy, [cdc].[UI_FormDesignGroup_CT].	AddedDate, 
		[cdc].[UI_FormDesignGroup_CT].	UpdatedBy, [cdc].[UI_FormDesignGroup_CT].	UpdatedDate, [cdc].[UI_FormDesignGroup_CT].	IsMasterList,
		[cdc].[UI_FormDesignGroup_CT].	MigrationID, [cdc].[UI_FormDesignGroup_CT].	IsMigrated, [cdc].[UI_FormDesignGroup_CT].IsMigrationOverriden,
		[cdc].[UI_FormDesignGroup_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignGroup_CT] WHERE __$Operation = 4
	END
END
