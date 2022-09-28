USE [eBS4_INT_QA2]
GO
/****** Object:  Trigger [UI].[DML_Trgr_RegexLibrary]    Script Date: 9/21/2022 2:34:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlRegexLibrary]

Purpose:
    To maintain records for DML operation performed on table [UI].[RegexLibrary] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  22/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlRegexLibrary]
AS

BEGIN
 SET NOCOUNT ON;

	DECLARE @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	--select @inserted=[cdc].[UI_RegexLibrary_CT].LibraryRegexID from [cdc].[UI_RegexLibrary_CT]
	--select @deleted=[cdc].[UI_RegexLibrary_CT].LibraryRegexID from [cdc].[UI_RegexLibrary_CT]

	SET @Operation = (SELECT top 1 __$operation FROM [cdc].[UI_RegexLibrary_CT])

	IF @Operation = 1 --For delete
	BEGIN
		INSERT INTO [Trgr].[RegexLibrary]
			(		LibraryRegexID,			LibraryRegexName,			RegexValue,			[Description],			IsActive,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			[Message],			Placeholder,			MaskExpression,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_RegexLibrary_CT].LibraryRegexID, [cdc].[UI_RegexLibrary_CT].LibraryRegexName, 
		[cdc].[UI_RegexLibrary_CT].	RegexValue, [cdc].[UI_RegexLibrary_CT].[Description], [cdc].[UI_RegexLibrary_CT].	IsActive,
		[cdc].[UI_RegexLibrary_CT].	AddedBy, [cdc].[UI_RegexLibrary_CT].	AddedDate, [cdc].[UI_RegexLibrary_CT].	UpdatedBy,
		[cdc].[UI_RegexLibrary_CT].	UpdatedDate, [cdc].[UI_RegexLibrary_CT].	[Message], [cdc].[UI_RegexLibrary_CT].	Placeholder,
		[cdc].[UI_RegexLibrary_CT].	MaskExpression, [cdc].[UI_RegexLibrary_CT].MigrationID, [cdc].[UI_RegexLibrary_CT].	IsMigrated, 
		[cdc].[UI_RegexLibrary_CT].IsMigrationOverriden, [cdc].[UI_RegexLibrary_CT].	MigrationDate,
		4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RegexLibrary_CT] where __$operation = 1
	END

	--added logic for insert
	ELSE IF @Operation = 2  --For insert
	BEGIN
		INSERT INTO [Trgr].[RegexLibrary]
			(		LibraryRegexID,			LibraryRegexName,			RegexValue,			[Description],			IsActive,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			[Message],			Placeholder,			MaskExpression,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_RegexLibrary_CT].LibraryRegexID, [cdc].[UI_RegexLibrary_CT].LibraryRegexName, 
		[cdc].[UI_RegexLibrary_CT].	RegexValue, [cdc].[UI_RegexLibrary_CT].[Description], [cdc].[UI_RegexLibrary_CT].	IsActive,
		[cdc].[UI_RegexLibrary_CT].	AddedBy, [cdc].[UI_RegexLibrary_CT].	AddedDate, [cdc].[UI_RegexLibrary_CT].	UpdatedBy,
		[cdc].[UI_RegexLibrary_CT].	UpdatedDate, [cdc].[UI_RegexLibrary_CT].	[Message], [cdc].[UI_RegexLibrary_CT].	Placeholder,
		[cdc].[UI_RegexLibrary_CT].	MaskExpression, [cdc].[UI_RegexLibrary_CT].MigrationID, [cdc].[UI_RegexLibrary_CT].	IsMigrated, 
		[cdc].[UI_RegexLibrary_CT].IsMigrationOverriden, [cdc].[UI_RegexLibrary_CT].	MigrationDate,
		1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RegexLibrary_CT] where __$operation = 2
	END
	ELSE IF @Operation = 3
	BEGIN
		INSERT INTO [Trgr].[RegexLibrary]
			(		LibraryRegexID,			LibraryRegexName,			RegexValue,			[Description],			IsActive,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			[Message],			Placeholder,			MaskExpression,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_RegexLibrary_CT].LibraryRegexID, [cdc].[UI_RegexLibrary_CT].LibraryRegexName,
		[cdc].[UI_RegexLibrary_CT].	RegexValue, [cdc].[UI_RegexLibrary_CT].[Description], 
		[cdc].[UI_RegexLibrary_CT].	IsActive, [cdc].[UI_RegexLibrary_CT].	AddedBy, 
		[cdc].[UI_RegexLibrary_CT].	AddedDate, [cdc].[UI_RegexLibrary_CT].	UpdatedBy,
		[cdc].[UI_RegexLibrary_CT].	UpdatedDate, [cdc].[UI_RegexLibrary_CT].	[Message], 
		[cdc].[UI_RegexLibrary_CT].	Placeholder, [cdc].[UI_RegexLibrary_CT].	MaskExpression, 
		[cdc].[UI_RegexLibrary_CT].MigrationID, [cdc].[UI_RegexLibrary_CT].	IsMigrated,
		[cdc].[UI_RegexLibrary_CT].IsMigrationOverriden, [cdc].[UI_RegexLibrary_CT].	MigrationDate,
		2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RegexLibrary_CT] where __$operation = 3

		INSERT INTO [Trgr].[RegexLibrary]
			(		LibraryRegexID,			LibraryRegexName,			RegexValue,			[Description],			IsActive,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			[Message],			Placeholder,			MaskExpression,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_RegexLibrary_CT].LibraryRegexID, [cdc].[UI_RegexLibrary_CT].LibraryRegexName,
		[cdc].[UI_RegexLibrary_CT].	RegexValue, [cdc].[UI_RegexLibrary_CT].[Description], 
		[cdc].[UI_RegexLibrary_CT].	IsActive, [cdc].[UI_RegexLibrary_CT].	AddedBy, 
		[cdc].[UI_RegexLibrary_CT].	AddedDate, [cdc].[UI_RegexLibrary_CT].	UpdatedBy,
		[cdc].[UI_RegexLibrary_CT].	UpdatedDate, [cdc].[UI_RegexLibrary_CT].	[Message], 
		[cdc].[UI_RegexLibrary_CT].	Placeholder, [cdc].[UI_RegexLibrary_CT].	MaskExpression, 
		[cdc].[UI_RegexLibrary_CT].MigrationID, [cdc].[UI_RegexLibrary_CT].	IsMigrated,
		[cdc].[UI_RegexLibrary_CT].IsMigrationOverriden, [cdc].[UI_RegexLibrary_CT].	MigrationDate,
		3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RegexLibrary_CT] where __$operation = 4
	END

	--	INSERT INTO [Trgr].[RegexLibrary]
	--		(		LibraryRegexID,				LibraryRegexName,			RegexValue,				[Description],			IsActive,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			[Message],			Placeholder,			MaskExpression,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
	--	SELECT  [cdc].[UI_RegexLibrary_CT].	LibraryRegexID, [cdc].[UI_RegexLibrary_CT].	LibraryRegexName, 
	--	[cdc].[UI_RegexLibrary_CT].	RegexValue, [cdc].[UI_RegexLibrary_CT].	[Description], [cdc].[UI_RegexLibrary_CT].IsActive,
	--	[cdc].[UI_RegexLibrary_CT].	AddedBy, [cdc].[UI_RegexLibrary_CT].	AddedDate, [cdc].[UI_RegexLibrary_CT].UpdatedBy,
	--	[cdc].[UI_RegexLibrary_CT].UpdatedDate, [cdc].[UI_RegexLibrary_CT].	[Message], [cdc].[UI_RegexLibrary_CT].Placeholder,
	--	[cdc].[UI_RegexLibrary_CT].	MaskExpression, [cdc].[UI_RegexLibrary_CT].MigrationID,
	--	[cdc].[UI_RegexLibrary_CT].	IsMigrated, [cdc].[UI_RegexLibrary_CT].	IsMigrationOverriden,
	--	[cdc].[UI_RegexLibrary_CT].	MigrationDate,
	--	@Operation as	DMLOperation, getdate() as	OperationDate
	--	FROM [cdc].[UI_RegexLibrary_CT]
	--END
END
