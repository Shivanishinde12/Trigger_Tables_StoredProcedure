USE [eBS4_INT_QA2]
GO
/****** Object:  Trigger [UI].[DML_Trgr_DocumentRuleEventType]    Script Date: 10/4/2022 12:00:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE  [UI].[SPDmlDocumentRuleEventType]
AS
BEGIN
 SET NOCOUNT ON;

	DECLARE @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_DocumentRuleEventType_CT])

	IF @Operation = 1
	BEGIN
		INSERT INTO [Trgr].[DocumentRuleEventType]
		(		DocumentRuleEventTypeID,			DocumentRuleEventTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		select  [cdc].[UI_DocumentRuleEventType_CT].DocumentRuleEventTypeID, [cdc].[UI_DocumentRuleEventType_CT].	DocumentRuleEventTypeCode,
		[cdc].[UI_DocumentRuleEventType_CT].	DisplayText, [cdc].[UI_DocumentRuleEventType_CT].	[Description], 
		[cdc].[UI_DocumentRuleEventType_CT].	AddedBy, [cdc].[UI_DocumentRuleEventType_CT].	AddedDate,
		[cdc].[UI_DocumentRuleEventType_CT].	UpdatedBy, [cdc].[UI_DocumentRuleEventType_CT].	UpdatedDate,
		[cdc].[UI_DocumentRuleEventType_CT].	IsActive, [cdc].[UI_DocumentRuleEventType_CT].	MigrationID,
		[cdc].[UI_DocumentRuleEventType_CT].	IsMigrated, [cdc].[UI_DocumentRuleEventType_CT].	IsMigrationOverriden,
		[cdc].[UI_DocumentRuleEventType_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
		from [cdc].[UI_DocumentRuleEventType_CT] WHERE __$Operation = 1
	END

	ELSE IF @Operation = 2
	BEGIN
		INSERT INTO [Trgr].[DocumentRuleEventType]
		(		DocumentRuleEventTypeID,			DocumentRuleEventTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRuleEventType_CT].	DocumentRuleEventTypeID, 
		[cdc].[UI_DocumentRuleEventType_CT].	DocumentRuleEventTypeCode, [cdc].[UI_DocumentRuleEventType_CT].DisplayText,
		[cdc].[UI_DocumentRuleEventType_CT].	[Description], [cdc].[UI_DocumentRuleEventType_CT].AddedBy,
		[cdc].[UI_DocumentRuleEventType_CT].	AddedDate, [cdc].[UI_DocumentRuleEventType_CT].UpdatedBy, 
		[cdc].[UI_DocumentRuleEventType_CT].UpdatedDate, [cdc].[UI_DocumentRuleEventType_CT].	IsActive,
		[cdc].[UI_DocumentRuleEventType_CT].	MigrationID, [cdc].[UI_DocumentRuleEventType_CT].	IsMigrated,
		[cdc].[UI_DocumentRuleEventType_CT].	IsMigrationOverriden, [cdc].[UI_DocumentRuleEventType_CT].	MigrationDate,
		1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRuleEventType_CT] WHERE __$Operation = 2
	END

	ELSE IF @Operation = 3
	BEGIN
		INSERT INTO [Trgr].[DocumentRuleEventType]
		(		DocumentRuleEventTypeID,			DocumentRuleEventTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRuleEventType_CT].DocumentRuleEventTypeID, [cdc].[UI_DocumentRuleEventType_CT].	DocumentRuleEventTypeCode,
		[cdc].[UI_DocumentRuleEventType_CT].	DisplayText, [cdc].[UI_DocumentRuleEventType_CT].	[Description],
		[cdc].[UI_DocumentRuleEventType_CT].	AddedBy, [cdc].[UI_DocumentRuleEventType_CT].	AddedDate,
		[cdc].[UI_DocumentRuleEventType_CT].	UpdatedBy, [cdc].[UI_DocumentRuleEventType_CT].	UpdatedDate,
		[cdc].[UI_DocumentRuleEventType_CT].	IsActive, [cdc].[UI_DocumentRuleEventType_CT].	MigrationID, 
		[cdc].[UI_DocumentRuleEventType_CT].	IsMigrated, [cdc].[UI_DocumentRuleEventType_CT].	IsMigrationOverriden,
		[cdc].[UI_DocumentRuleEventType_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRuleEventType_CT] WHERE __$Operation = 3

		INSERT INTO [Trgr].[DocumentRuleEventType]
		(		DocumentRuleEventTypeID,			DocumentRuleEventTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRuleEventType_CT].DocumentRuleEventTypeID, [cdc].[UI_DocumentRuleEventType_CT].	DocumentRuleEventTypeCode,
		[cdc].[UI_DocumentRuleEventType_CT].	DisplayText, [cdc].[UI_DocumentRuleEventType_CT].	[Description],
		[cdc].[UI_DocumentRuleEventType_CT].	AddedBy, [cdc].[UI_DocumentRuleEventType_CT].	AddedDate,
		[cdc].[UI_DocumentRuleEventType_CT].	UpdatedBy, [cdc].[UI_DocumentRuleEventType_CT].	UpdatedDate,
		[cdc].[UI_DocumentRuleEventType_CT].	IsActive, [cdc].[UI_DocumentRuleEventType_CT].	MigrationID, 
		[cdc].[UI_DocumentRuleEventType_CT].	IsMigrated, [cdc].[UI_DocumentRuleEventType_CT].	IsMigrationOverriden,
		[cdc].[UI_DocumentRuleEventType_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRuleEventType_CT] WHERE __$Operation = 4
	END

END
