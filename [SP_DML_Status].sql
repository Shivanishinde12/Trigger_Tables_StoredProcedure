﻿USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlStatus]

Purpose:
    To maintain records for DML operation performed on table [UI].[Status] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  27/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlStatus]
AS
BEGIN
 SET NOCOUNT ON;

	DECLARE @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	SET @Operation = (SELECT TOP 1 __$operation FROM [cdc].[UI_Status_CT])

	IF @Operation = 1 --FOR DELETE
	BEGIN
		INSERT INTO [Trgr].[Status]
		(		StatusID,			[Status],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_Status_CT].StatusID, [cdc].[UI_Status_CT].	[Status], [cdc].[UI_Status_CT].	AddedBy, 
		[cdc].[UI_Status_CT].	AddedDate, [cdc].[UI_Status_CT].	UpdatedBy, [cdc].[UI_Status_CT].	UpdatedDate,
		[cdc].[UI_Status_CT].	IsActive, [cdc].[UI_Status_CT].	MigrationID, [cdc].[UI_Status_CT].	IsMigrated, 
		[cdc].[UI_Status_CT].IsMigrationOverriden, [cdc].[UI_Status_CT].	MigrationDate, 
		4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_Status_CT] Where __$operation = 1
	END
	
	ELSE IF @Operation = 2 --for insert
	BEGIN
		INSERT INTO [Trgr].[Status]
		(		StatusID,			[Status],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_Status_CT].	StatusID, [cdc].[UI_Status_CT].	[Status], [cdc].[UI_Status_CT].	AddedBy,
		[cdc].[UI_Status_CT].	AddedDate, [cdc].[UI_Status_CT].UpdatedBy, [cdc].[UI_Status_CT].UpdatedDate,
		[cdc].[UI_Status_CT].	IsActive, [cdc].[UI_Status_CT].	MigrationID, [cdc].[UI_Status_CT].	IsMigrated,
		[cdc].[UI_Status_CT].	IsMigrationOverriden, [cdc].[UI_Status_CT].	MigrationDate,
		1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_Status_CT] where __$operation = 2
	END
	
	ELSE IF @Operation = 3 --for update
	BEGIN
		INSERT INTO [Trgr].[Status]
		(	StatusID,			[Status],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_Status_CT].StatusID, [cdc].[UI_Status_CT].	[Status], [cdc].[UI_Status_CT].	AddedBy, 
		[cdc].[UI_Status_CT].	AddedDate, [cdc].[UI_Status_CT].	UpdatedBy, [cdc].[UI_Status_CT].	UpdatedDate,
		[cdc].[UI_Status_CT].	IsActive, [cdc].[UI_Status_CT].	MigrationID, [cdc].[UI_Status_CT].	IsMigrated,
		[cdc].[UI_Status_CT].IsMigrationOverriden, [cdc].[UI_Status_CT].	MigrationDate,
		2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_Status_CT] Where __$operation = 3

		INSERT INTO [Trgr].[Status]
		(	StatusID,			[Status],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_Status_CT].StatusID, [cdc].[UI_Status_CT].	[Status], [cdc].[UI_Status_CT].	AddedBy, 
		[cdc].[UI_Status_CT].	AddedDate, [cdc].[UI_Status_CT].	UpdatedBy, [cdc].[UI_Status_CT].	UpdatedDate,
		[cdc].[UI_Status_CT].	IsActive, [cdc].[UI_Status_CT].	MigrationID, [cdc].[UI_Status_CT].	IsMigrated,
		[cdc].[UI_Status_CT].IsMigrationOverriden, [cdc].[UI_Status_CT].	MigrationDate,
		3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_Status_CT] Where __$operation = 4
	END
END
