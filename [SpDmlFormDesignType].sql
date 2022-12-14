USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Name:
    [UI].[SpDmlFormDesignType]

Purpose:
    To maintain records for DML operation performed on table [UI].[FormDesignType] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  29/09/2022 by Shivani Shinde 
    Modified on ---------
*/

CREATE OR ALTER PROCEDURE [UI].[SpDmlFormDesignType]
AS
BEGIN
 SET NOCOUNT ON;

	DECLARE @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_FormDesignType_CT])

	IF @Operation = 1 --for delete
	BEGIN
		INSERT INTO [Trgr].[FormDesignType]
		(	FormDesignTypeID,			DisplayText,			AddedBy,			AddedDate,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignType_CT].FormDesignTypeID, [cdc].[UI_FormDesignType_CT].	DisplayText,
		[cdc].[UI_FormDesignType_CT].	AddedBy, [cdc].[UI_FormDesignType_CT].	AddedDate,
		[cdc].[UI_FormDesignType_CT].	MigrationID, [cdc].[UI_FormDesignType_CT].	IsMigrated,
		[cdc].[UI_FormDesignType_CT].IsMigrationOverriden, [cdc].[UI_FormDesignType_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
		from [cdc].[UI_FormDesignType_CT] WHERE __$Operation = 1
	END

	ELSE IF @Operation = 2 --for insert
	BEGIN
		INSERT INTO [Trgr].[FormDesignType]
		(	FormDesignTypeID,			DisplayText,			AddedBy,			AddedDate,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_FormDesignType_CT].FormDesignTypeID, [cdc].[UI_FormDesignType_CT].	DisplayText, 
		[cdc].[UI_FormDesignType_CT].	AddedBy, [cdc].[UI_FormDesignType_CT].	AddedDate, [cdc].[UI_FormDesignType_CT].MigrationID,
		[cdc].[UI_FormDesignType_CT].	IsMigrated, [cdc].[UI_FormDesignType_CT].	IsMigrationOverriden,
		[cdc].[UI_FormDesignType_CT].	MigrationDate, @Operation as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignType_CT]
	END

	ELSE IF @Operation = 3 --for update
	BEGIN
		INSERT INTO [Trgr].[FormDesignType]
		(	FormDesignTypeID,			DisplayText,			AddedBy,			AddedDate,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignType_CT].FormDesignTypeID, [cdc].[UI_FormDesignType_CT].	DisplayText,
		[cdc].[UI_FormDesignType_CT].	AddedBy, [cdc].[UI_FormDesignType_CT].	AddedDate, [cdc].[UI_FormDesignType_CT].	MigrationID,
		[cdc].[UI_FormDesignType_CT].	IsMigrated, [cdc].[UI_FormDesignType_CT].IsMigrationOverriden,
		[cdc].[UI_FormDesignType_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignType_CT] WHERE __$Operation = 3

		INSERT INTO [Trgr].[FormDesignType]
		(	FormDesignTypeID,			DisplayText,			AddedBy,			AddedDate,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_FormDesignType_CT].FormDesignTypeID, [cdc].[UI_FormDesignType_CT].	DisplayText,
		[cdc].[UI_FormDesignType_CT].	AddedBy, [cdc].[UI_FormDesignType_CT].	AddedDate, [cdc].[UI_FormDesignType_CT].	MigrationID,
		[cdc].[UI_FormDesignType_CT].	IsMigrated, [cdc].[UI_FormDesignType_CT].IsMigrationOverriden,
		[cdc].[UI_FormDesignType_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_FormDesignType_CT] WHERE __$Operation = 4
	END

END
