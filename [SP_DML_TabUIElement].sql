USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlTabUIElement]

Purpose:
    To maintain records for DML operation performed on table [UI].[TabUIElement] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  27/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlTabUIElement]
AS
BEGIN
 SET NOCOUNT ON;
   --Local variables declaration
	DECLARE @Operation	int,@inserted	int,@deleted	int
	
	--check if record inserted, updated or deleted
	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_TabUIElement_CT])

	IF @Operation = 1 --for deleted
	BEGIN
		INSERT INTO [Trgr].[TabUIElement]
		(	UIElementID,			UIElementTypeID,			ChildCount,			LayoutTypeID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_TabUIElement_CT].UIElementID, [cdc].[UI_TabUIElement_CT].	UIElementTypeID,
		[cdc].[UI_TabUIElement_CT].	ChildCount, [cdc].[UI_TabUIElement_CT].LayoutTypeID, [cdc].[UI_TabUIElement_CT].	MigrationID,
		[cdc].[UI_TabUIElement_CT].	IsMigrated, [cdc].[UI_TabUIElement_CT].IsMigrationOverriden,
		[cdc].[UI_TabUIElement_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TabUIElement_CT] Where @Operation = 1

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Tab element '+ ui.Label +' is deleted',ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy),GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0) FROM [cdc].[UI_TabUIElement_CT] d JOIN UI.UIElement ui ON ui.UIElementID=d.UIElementID 
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
	END

	ELSE IF @operation = 2 ----- For Insert
	BEGIN
		INSERT INTO [Trgr].[TabUIElement]
		(	UIElementID,			UIElementTypeID,			ChildCount,			LayoutTypeID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_TabUIElement_CT].UIElementID, [cdc].[UI_TabUIElement_CT].	UIElementTypeID,
		[cdc].[UI_TabUIElement_CT].	ChildCount, [cdc].[UI_TabUIElement_CT].LayoutTypeID, [cdc].[UI_TabUIElement_CT].	MigrationID,
		[cdc].[UI_TabUIElement_CT].	IsMigrated, [cdc].[UI_TabUIElement_CT].IsMigrationOverriden,
		[cdc].[UI_TabUIElement_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TabUIElement_CT] Where @Operation = 2

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(i.UIElementID,0),'Tab element '+ ui.Label +' is added',ui.AddedBy , GETDATE(), ui.AddedBy , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0) FROM [cdc].[UI_TabUIElement_CT] i JOIN UI.UIElement ui ON ui.UIElementID=i.UIElementID
		LEFT JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID ;

		TRUNCATE TABLE dbo.ActivityLogForRM;
		    INSERT INTO dbo.ActivityLogForRM VALUES (@@identity, NULL);
	END;

	ELSE IF @Operation = 3 --for update
	BEGIN
		INSERT INTO [Trgr].[TabUIElement]
		(	UIElementID,			UIElementTypeID,			ChildCount,			LayoutTypeID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_TabUIElement_CT].UIElementID, [cdc].[UI_TabUIElement_CT].	UIElementTypeID,
		[cdc].[UI_TabUIElement_CT].	ChildCount, [cdc].[UI_TabUIElement_CT].LayoutTypeID, 
		[cdc].[UI_TabUIElement_CT].	MigrationID, [cdc].[UI_TabUIElement_CT].	IsMigrated,
		[cdc].[UI_TabUIElement_CT].IsMigrationOverriden, [cdc].[UI_TabUIElement_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TabUIElement_CT] WHERE __$operation = 3

		INSERT INTO [Trgr].[TabUIElement]
		(	UIElementID,			UIElementTypeID,			ChildCount,			LayoutTypeID,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_TabUIElement_CT].UIElementID, [cdc].[UI_TabUIElement_CT].	UIElementTypeID,
		[cdc].[UI_TabUIElement_CT].	ChildCount, [cdc].[UI_TabUIElement_CT].LayoutTypeID, 
		[cdc].[UI_TabUIElement_CT].	MigrationID, [cdc].[UI_TabUIElement_CT].	IsMigrated,
		[cdc].[UI_TabUIElement_CT].IsMigrationOverriden, [cdc].[UI_TabUIElement_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TabUIElement_CT] WHERE __$operation = 4
	END
END

