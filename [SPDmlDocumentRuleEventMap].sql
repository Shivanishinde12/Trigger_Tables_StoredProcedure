USE [eBS4_INT_QA2]
GO
/****** Object:  Trigger [UI].[DML_Trgr_DocumentRuleEventMap]    Script Date: 10/4/2022 12:31:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE  [UI].[SPDmlDocumentRuleEventMap]
AS
BEGIN
 SET NOCOUNT ON;

	DECLARE  @Operation	int
	DECLARE @inserted	int
	DECLARE @deleted	int

	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_DocumentRuleEventMap_CT])

	IF @Operation = 1
	BEGIN
		INSERT INTO [Trgr].[DocumentRuleEventMap]
		(		DocumentRuleEventMapID,			DocumentRuleID,			DocumentRuleEventTypeID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRuleEventMap_CT].DocumentRuleEventMapID, [cdc].[UI_DocumentRuleEventMap_CT].DocumentRuleID,
		[cdc].[UI_DocumentRuleEventMap_CT].DocumentRuleEventTypeID, [cdc].[UI_DocumentRuleEventMap_CT].	MigrationID, 
		[cdc].[UI_DocumentRuleEventMap_CT].	IsMigrated, [cdc].[UI_DocumentRuleEventMap_CT].IsMigrationOverriden,
		[cdc].[UI_DocumentRuleEventMap_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRuleEventMap_CT] WHERE __$Operation = 1
	END

	ELSE IF @Operation = 2
	BEGIN
		INSERT INTO [Trgr].[DocumentRuleEventMap]
		(		DocumentRuleEventMapID,				DocumentRuleID,				DocumentRuleEventTypeID,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRuleEventMap_CT].	DocumentRuleEventMapID, [cdc].[UI_DocumentRuleEventMap_CT].	DocumentRuleID,
		[cdc].[UI_DocumentRuleEventMap_CT].	DocumentRuleEventTypeID, [cdc].[UI_DocumentRuleEventMap_CT].	MigrationID,
		[cdc].[UI_DocumentRuleEventMap_CT].	IsMigrated, [cdc].[UI_DocumentRuleEventMap_CT].	IsMigrationOverriden, 
		[cdc].[UI_DocumentRuleEventMap_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
		from [cdc].[UI_DocumentRuleEventMap_CT] WHERE __$Operation = 2
	END

	ELSE IF @Operation = 3
	BEGIN
		INSERT INTO [Trgr].[DocumentRuleEventMap]
		(		DocumentRuleEventMapID,			DocumentRuleID,			DocumentRuleEventTypeID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRuleEventMap_CT].DocumentRuleEventMapID, [cdc].[UI_DocumentRuleEventMap_CT].DocumentRuleID,
		[cdc].[UI_DocumentRuleEventMap_CT].DocumentRuleEventTypeID, [cdc].[UI_DocumentRuleEventMap_CT].	MigrationID,
		[cdc].[UI_DocumentRuleEventMap_CT].	IsMigrated, [cdc].[UI_DocumentRuleEventMap_CT].IsMigrationOverriden,
		[cdc].[UI_DocumentRuleEventMap_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRuleEventMap_CT] WHERE __$Operation = 3

		INSERT INTO [Trgr].[DocumentRuleEventMap]
		(		DocumentRuleEventMapID,			DocumentRuleID,			DocumentRuleEventTypeID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRuleEventMap_CT].DocumentRuleEventMapID, [cdc].[UI_DocumentRuleEventMap_CT].DocumentRuleID,
		[cdc].[UI_DocumentRuleEventMap_CT].DocumentRuleEventTypeID, [cdc].[UI_DocumentRuleEventMap_CT].	MigrationID,
		[cdc].[UI_DocumentRuleEventMap_CT].	IsMigrated, [cdc].[UI_DocumentRuleEventMap_CT].IsMigrationOverriden,
		[cdc].[UI_DocumentRuleEventMap_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRuleEventMap_CT] WHERE __$Operation = 4
	END
END
