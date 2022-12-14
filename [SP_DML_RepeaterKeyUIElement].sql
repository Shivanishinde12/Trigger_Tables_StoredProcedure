USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlRepeaterKeyUIElement]

Purpose:
    To maintain records for DML operation performed on table UI].[RepeaterKeyUIElement] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  22/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlRepeaterKeyUIElement]
AS
BEGIN
 SET NOCOUNT ON;
 --Local variables declaration
	DECLARE @Operation	int,@inserted	int,@deleted	int
	
	--check if record inserted, updated or deleted
	SET @Operation = (SELECT TOP 1 __$operation FROM [cdc].[UI_RepeaterKeyUIElement_CT] )

	IF @Operation = 1 --For deleted
	BEGIN
		INSERT INTO [Trgr].[RepeaterKeyUIElement]
		(		RepeaterKeyElementID,			RepeaterUIElementID,			UIElementID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_RepeaterKeyUIElement_CT].	RepeaterKeyElementID, [cdc].[UI_RepeaterKeyUIElement_CT].	RepeaterUIElementID,
		[cdc].[UI_RepeaterKeyUIElement_CT].	UIElementID, [cdc].[UI_RepeaterKeyUIElement_CT].	MigrationID,
		[cdc].[UI_RepeaterKeyUIElement_CT].	IsMigrated, [cdc].[UI_RepeaterKeyUIElement_CT].IsMigrationOverriden,
		[cdc].[UI_RepeaterKeyUIElement_CT].	MigrationDate,
		4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RepeaterKeyUIElement_CT] Where __$operation = 1

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Repeater element key for element '+ ui.Label +' is deleted',ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy),GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_RepeaterKeyUIElement_CT] d JOIN UI.UIElement ui ON ui.UIElementID=d.UIElementID JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;
	END

	ELSE IF @operation = 2 ----- For Insert
	BEGIN       
		INSERT INTO [Trgr].[RepeaterKeyUIElement]
		(	RepeaterKeyElementID,			RepeaterUIElementID,			UIElementID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_RepeaterKeyUIElement_CT].	RepeaterKeyElementID, [cdc].[UI_RepeaterKeyUIElement_CT].	RepeaterUIElementID,
		[cdc].[UI_RepeaterKeyUIElement_CT].	UIElementID, [cdc].[UI_RepeaterKeyUIElement_CT].	MigrationID,
		[cdc].[UI_RepeaterKeyUIElement_CT].	IsMigrated, [cdc].[UI_RepeaterKeyUIElement_CT].IsMigrationOverriden, 
		[cdc].[UI_RepeaterKeyUIElement_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RepeaterKeyUIElement_CT] Where __$operation = 2
		
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(i.UIElementID,0),'Repeater element key for element '+ ui.Label +' is added',ui.AddedBy ,GETDATE(), ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_RepeaterKeyUIElement_CT] i JOIN UI.UIElement ui ON ui.UIElementID=i.UIElementID 
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;
	END;

	ELSE IF @Operation = 3
	BEGIN
		INSERT INTO [Trgr].[RepeaterKeyUIElement]
		(	RepeaterKeyElementID,			RepeaterUIElementID,			UIElementID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_RepeaterKeyUIElement_CT].	RepeaterKeyElementID, [cdc].[UI_RepeaterKeyUIElement_CT].	RepeaterUIElementID,
		[cdc].[UI_RepeaterKeyUIElement_CT].	UIElementID, [cdc].[UI_RepeaterKeyUIElement_CT].	MigrationID,
		[cdc].[UI_RepeaterKeyUIElement_CT].	IsMigrated, [cdc].[UI_RepeaterKeyUIElement_CT].IsMigrationOverriden, 
		[cdc].[UI_RepeaterKeyUIElement_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RepeaterKeyUIElement_CT] Where __$operation = 3

		INSERT INTO [Trgr].[RepeaterKeyUIElement]
		(	RepeaterKeyElementID,			RepeaterUIElementID,			UIElementID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_RepeaterKeyUIElement_CT].	RepeaterKeyElementID, [cdc].[UI_RepeaterKeyUIElement_CT].	RepeaterUIElementID,
		[cdc].[UI_RepeaterKeyUIElement_CT].	UIElementID, [cdc].[UI_RepeaterKeyUIElement_CT].	MigrationID,
		[cdc].[UI_RepeaterKeyUIElement_CT].	IsMigrated, [cdc].[UI_RepeaterKeyUIElement_CT].IsMigrationOverriden, 
		[cdc].[UI_RepeaterKeyUIElement_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RepeaterKeyUIElement_CT] Where __$operation = 4
	END
END

