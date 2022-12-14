USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlSectionUIElement]

Purpose:
    To maintain records for DML operation performed on table [UI].[SectionUIElement] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  26/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE or alter  PROCEDURE [UI].[SpDmlSectionUIElement]
AS
BEGIN
 SET NOCOUNT ON;
     --Local variables declaration
	DECLARE @Operation	int,@inserted	int,@deleted	int,@iLayoutType VARCHAR(255),@dLayoutType VARCHAR(255),@iCustomHTML NVARCHAR(MAX),@dCustomHTML NVARCHAR(MAX),@iDataSourceId int,
	@dDataSourceId int
	
	--Check if record inserted, updated or deleted
	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_SectionUIElement_CT])

	IF @Operation = 1 --For deleted 
	BEGIN
		INSERT INTO [Trgr].[SectionUIElement]
		(		UIElementID,			UIElementTypeID,			ChildCount,			LayoutTypeID,			DataSourceID,			CustomHtml,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_SectionUIElement_CT].UIElementID, [cdc].[UI_SectionUIElement_CT].	UIElementTypeID,
		[cdc].[UI_SectionUIElement_CT].	ChildCount, [cdc].[UI_SectionUIElement_CT].LayoutTypeID, 
		[cdc].[UI_SectionUIElement_CT].	DataSourceID, [cdc].[UI_SectionUIElement_CT].	CustomHtml, 
		[cdc].[UI_SectionUIElement_CT].MigrationID, [cdc].[UI_SectionUIElement_CT].	IsMigrated, 
		[cdc].[UI_SectionUIElement_CT].IsMigrationOverriden, [cdc].[UI_SectionUIElement_CT].	MigrationDate,
		4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_SectionUIElement_CT] WHERE @Operation = 1	

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Section element '+ ui.Label +' is deleted',ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy), GETDATE()
		,ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_SectionUIElement_CT] d JOIN UI.UIElement ui ON ui.UIElementID=d.UIElementID 
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
	END
	
	ELSE IF @operation = 2 ----- For Insert
	BEGIN      
		INSERT INTO [Trgr].[SectionUIElement]
		(		UIElementID,			UIElementTypeID,			ChildCount,			LayoutTypeID,			DataSourceID,			CustomHtml,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_SectionUIElement_CT].UIElementID, [cdc].[UI_SectionUIElement_CT].	UIElementTypeID,
		[cdc].[UI_SectionUIElement_CT].	ChildCount, [cdc].[UI_SectionUIElement_CT].LayoutTypeID, 
		[cdc].[UI_SectionUIElement_CT].	DataSourceID, [cdc].[UI_SectionUIElement_CT].	CustomHtml, 
		[cdc].[UI_SectionUIElement_CT].MigrationID, [cdc].[UI_SectionUIElement_CT].	IsMigrated, 
		[cdc].[UI_SectionUIElement_CT].IsMigrationOverriden, [cdc].[UI_SectionUIElement_CT].	MigrationDate,
		1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_SectionUIElement_CT] WHERE @Operation = 2
			
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(i.UIElementID,0),'Section element '+ ui.Label +' is added',ui.AddedBy , GETDATE(), ui.AddedBy , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_SectionUIElement_CT] i LEFT JOIN UI.UIElement ui ON ui.UIElementID=i.UIElementID
		LEFT JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;  

		TRUNCATE TABLE dbo.ActivityLogForRM;
		INSERT INTO dbo.ActivityLogForRM VALUES (@@identity,NULL);
	END;

	ELSE IF @Operation = 3
	BEGIN
		INSERT INTO [Trgr].[SectionUIElement]
		(		UIElementID,			UIElementTypeID,			ChildCount,			LayoutTypeID,			DataSourceID,			CustomHtml,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_SectionUIElement_CT].UIElementID, [cdc].[UI_SectionUIElement_CT].	UIElementTypeID,
		[cdc].[UI_SectionUIElement_CT].	ChildCount, [cdc].[UI_SectionUIElement_CT].LayoutTypeID,
		[cdc].[UI_SectionUIElement_CT].	DataSourceID, [cdc].[UI_SectionUIElement_CT].	CustomHtml,
		[cdc].[UI_SectionUIElement_CT].MigrationID, [cdc].[UI_SectionUIElement_CT].	IsMigrated, 
		[cdc].[UI_SectionUIElement_CT].IsMigrationOverriden, [cdc].[UI_SectionUIElement_CT].	MigrationDate,
		2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_SectionUIElement_CT] WHERE __$operation = 3

		INSERT INTO [Trgr].[SectionUIElement]
		(		UIElementID,			UIElementTypeID,			ChildCount,			LayoutTypeID,			DataSourceID,			CustomHtml,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_SectionUIElement_CT].UIElementID, [cdc].[UI_SectionUIElement_CT].	UIElementTypeID,
		[cdc].[UI_SectionUIElement_CT].	ChildCount, [cdc].[UI_SectionUIElement_CT].LayoutTypeID,
		[cdc].[UI_SectionUIElement_CT].	DataSourceID, [cdc].[UI_SectionUIElement_CT].	CustomHtml,
		[cdc].[UI_SectionUIElement_CT].MigrationID, [cdc].[UI_SectionUIElement_CT].	IsMigrated, 
		[cdc].[UI_SectionUIElement_CT].IsMigrationOverriden, [cdc].[UI_SectionUIElement_CT].	MigrationDate,
		3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_SectionUIElement_CT] WHERE __$operation = 4

		SELECT @dLayoutType =ISNULL(l.DisplayText,'None') FROM [cdc].[UI_SectionUIElement_CT] d inner join UI.LayoutType l ON l.LayoutTypeID=d.LayoutTypeID
		SELECT @iLayoutType =ISNULL(l.DisplayText,'None') FROM [cdc].[UI_SectionUIElement_CT] i inner join UI.LayoutType l ON l.LayoutTypeID=i.LayoutTypeID

		SELECT @dCustomHTML =ISNULL(CustomHtml,''),@dDataSourceId =ISNULL(DataSourceID,0) FROM [cdc].[UI_SectionUIElement_CT]
		SELECT @iCustomHTML =ISNULL(CustomHtml,''),@iDataSourceId =ISNULL(DataSourceID,0) FROM [cdc].[UI_SectionUIElement_CT]

		IF (@dLayoutType<>@iLayoutType)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Layout for Section element '+ ui.Label +' is changed from '+ @dLayoutType + ' to '+ @iLayoutType  ,
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_SectionUIElement_CT] d inner join [cdc].[UI_SectionUIElement_CT] i ON d.UIElementID=i.UIElementID  inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
		END;

		IF (@dCustomHTML<>@iCustomHTML)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Custom Html for Section element '+ ui.Label +' is changed from '+ ISNULL(d.CustomHtml,'None')  + ' to '+ ISNULL(i.CustomHtml,'None')   ,
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_SectionUIElement_CT] d inner join [cdc].[UI_SectionUIElement_CT] i ON d.UIElementID=i.UIElementID 
			inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
		END;

		IF (@dDataSourceId<>@iDataSourceId)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Is Data Source for Section element '+ ui.Label +' is changed from '+ CASE ISNULL(@dDataSourceId,0) WHEN 0 THEN 'No' ELSE 'Yes' END  + ' to '+ CASE ISNULL(@iDataSourceId,0) WHEN 0 THEN 'No' ELSE 'Yes' END    ,
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_SectionUIElement_CT] d inner join [cdc].[UI_SectionUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
		END;
	END
END

