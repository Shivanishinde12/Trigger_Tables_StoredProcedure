USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlRepeaterUIElement]

Purpose:
    To maintain records for DML operation performed on table [UI].[RepeaterUIElement] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  26/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlRepeaterUIElement]
AS
BEGIN
 SET NOCOUNT ON;
    --Local variables declaration
	DECLARE @Operation	int,@inserted	int,@deleted	int,@iLayoutType VARCHAR(255),@dLayoutType VARCHAR(255),@iDisplayTopHeader bit,@dDisplayTopHeader bit,@iDisplayTitle bit,@dDisplayTitle bit,
	@iFrozenColCount int,@dFrozenColCount int,@iFrozenRowCount int,@dFrozenRowCount int,@iAllowPaging bit,@dAllowPaging bit,@iRowsPerPage int,@dRowsPerPage int,@iAllowExportToExcel bit,
	@dAllowExportToExcel bit,@iAllowExportToCSV bit,@dAllowExportToCSV bit,@iFilterMode VARCHAR(100),@dFilterMode VARCHAR(100),@iDataSourceId int,@dDataSourceId int
	
	--Check if record inserted, updated or deleted
	SET @Operation = (SELECT TOP 1 __$OPERATION FROM [cdc].[UI_RepeaterUIElement_CT])
	
		IF @Operation = 1 -- For deleted
		BEGIN
			INSERT INTO [Trgr].[RepeaterUIElement]
			(		UIElementID,			UIElementTypeID,			LayoutTypeID,			ChildCount,			DataSourceID,			LoadFromServer,			IsDataRequired,			AllowBulkUpdate,			DisplayTopHeader,			DisplayTitle,			FrozenColCount,			FrozenRowCount,			AllowPaging,			RowsPerPage,			AllowExportToExcel,			AllowExportToCSV,			FilterMode,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			SELECT  [cdc].[UI_RepeaterUIElement_CT].UIElementID, [cdc].[UI_RepeaterUIElement_CT].	UIElementTypeID, 
			[cdc].[UI_RepeaterUIElement_CT].	LayoutTypeID, [cdc].[UI_RepeaterUIElement_CT].	ChildCount,
			[cdc].[UI_RepeaterUIElement_CT].DataSourceID, [cdc].[UI_RepeaterUIElement_CT].	LoadFromServer,
			[cdc].[UI_RepeaterUIElement_CT].IsDataRequired, [cdc].[UI_RepeaterUIElement_CT].AllowBulkUpdate, 
			[cdc].[UI_RepeaterUIElement_CT].	DisplayTopHeader, [cdc].[UI_RepeaterUIElement_CT].	DisplayTitle, 
			[cdc].[UI_RepeaterUIElement_CT].	FrozenColCount, [cdc].[UI_RepeaterUIElement_CT].FrozenRowCount, 
			[cdc].[UI_RepeaterUIElement_CT].AllowPaging, [cdc].[UI_RepeaterUIElement_CT].	RowsPerPage,
			[cdc].[UI_RepeaterUIElement_CT].	AllowExportToExcel, [cdc].[UI_RepeaterUIElement_CT].AllowExportToCSV,
			[cdc].[UI_RepeaterUIElement_CT].	FilterMode, [cdc].[UI_RepeaterUIElement_CT].MigrationID,
			[cdc].[UI_RepeaterUIElement_CT].	IsMigrated, [cdc].[UI_RepeaterUIElement_CT].IsMigrationOverriden,
			[cdc].[UI_RepeaterUIElement_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
			FROM [cdc].[UI_RepeaterUIElement_CT] Where @Operation = 1

			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Repeater element '+ ui.Label +' is deleted',ui.AddedBy , ui.AddedDate , 
			ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_RepeaterUIElement_CT] d JOIN UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
		END
		
		ELSE IF @operation = 2 ----- For Insert
		BEGIN   
			INSERT INTO [Trgr].[RepeaterUIElement]
			(	UIElementID,			UIElementTypeID,			LayoutTypeID,			ChildCount,			DataSourceID,			LoadFromServer,			IsDataRequired,			AllowBulkUpdate,			DisplayTopHeader,			DisplayTitle,			FrozenColCount,			FrozenRowCount,			AllowPaging,			RowsPerPage,			AllowExportToExcel,			AllowExportToCSV,			FilterMode,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			SELECT  [cdc].[UI_RepeaterUIElement_CT].UIElementID, [cdc].[UI_RepeaterUIElement_CT].	UIElementTypeID, 
			[cdc].[UI_RepeaterUIElement_CT].	LayoutTypeID, [cdc].[UI_RepeaterUIElement_CT].	ChildCount,
			[cdc].[UI_RepeaterUIElement_CT].DataSourceID, [cdc].[UI_RepeaterUIElement_CT].	LoadFromServer,
			[cdc].[UI_RepeaterUIElement_CT].IsDataRequired, [cdc].[UI_RepeaterUIElement_CT].AllowBulkUpdate, 
			[cdc].[UI_RepeaterUIElement_CT].	DisplayTopHeader, [cdc].[UI_RepeaterUIElement_CT].	DisplayTitle, 
			[cdc].[UI_RepeaterUIElement_CT].	FrozenColCount, [cdc].[UI_RepeaterUIElement_CT].FrozenRowCount, 
			[cdc].[UI_RepeaterUIElement_CT].AllowPaging, [cdc].[UI_RepeaterUIElement_CT].	RowsPerPage,
			[cdc].[UI_RepeaterUIElement_CT].	AllowExportToExcel, [cdc].[UI_RepeaterUIElement_CT].AllowExportToCSV,
			[cdc].[UI_RepeaterUIElement_CT].	FilterMode, [cdc].[UI_RepeaterUIElement_CT].MigrationID,
			[cdc].[UI_RepeaterUIElement_CT].	IsMigrated, [cdc].[UI_RepeaterUIElement_CT].IsMigrationOverriden,
			[cdc].[UI_RepeaterUIElement_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
			FROM [cdc].[UI_RepeaterUIElement_CT] Where @Operation = 2

			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(i.UIElementID,0),'Repeater element '+ ui.Label +' is added',ui.AddedBy , GETDATE(), ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE()
			, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_RepeaterUIElement_CT] i LEFT JOIN UI.UIElement ui ON ui.UIElementID=i.UIElementID
			LEFT JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;  

			TRUNCATE TABLE dbo.ActivityLogForRM;
			INSERT INTO dbo.ActivityLogForRM VALUES (@@identity,NULL);
		END;

		ELSE IF @Operation = 3
		BEGIN
			INSERT INTO [Trgr].[RepeaterUIElement]
			(	UIElementID,			UIElementTypeID,			LayoutTypeID,			ChildCount,			DataSourceID,			LoadFromServer,			IsDataRequired,			AllowBulkUpdate,			DisplayTopHeader,			DisplayTitle,			FrozenColCount,			FrozenRowCount,			AllowPaging,			RowsPerPage,			AllowExportToExcel,			AllowExportToCSV,			FilterMode,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
			SELECT  [cdc].[UI_RepeaterUIElement_CT].UIElementID, [cdc].[UI_RepeaterUIElement_CT].	UIElementTypeID,
			[cdc].[UI_RepeaterUIElement_CT].	LayoutTypeID, [cdc].[UI_RepeaterUIElement_CT].	ChildCount, 
			[cdc].[UI_RepeaterUIElement_CT].DataSourceID, [cdc].[UI_RepeaterUIElement_CT].	LoadFromServer, 
			[cdc].[UI_RepeaterUIElement_CT].IsDataRequired, [cdc].[UI_RepeaterUIElement_CT].AllowBulkUpdate, 
			[cdc].[UI_RepeaterUIElement_CT].	DisplayTopHeader, [cdc].[UI_RepeaterUIElement_CT].	DisplayTitle,
			[cdc].[UI_RepeaterUIElement_CT].	FrozenColCount, [cdc].[UI_RepeaterUIElement_CT].FrozenRowCount,
			[cdc].[UI_RepeaterUIElement_CT].AllowPaging, [cdc].[UI_RepeaterUIElement_CT].	RowsPerPage,
			[cdc].[UI_RepeaterUIElement_CT].	AllowExportToExcel, [cdc].[UI_RepeaterUIElement_CT].AllowExportToCSV,
			[cdc].[UI_RepeaterUIElement_CT].	FilterMode, [cdc].[UI_RepeaterUIElement_CT].MigrationID,
			[cdc].[UI_RepeaterUIElement_CT].	IsMigrated, [cdc].[UI_RepeaterUIElement_CT].IsMigrationOverriden,
			[cdc].[UI_RepeaterUIElement_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
			FROM [cdc].[UI_RepeaterUIElement_CT] where __$operation = 3

			INSERT INTO [Trgr].[RepeaterUIElement]
			(	UIElementID,			UIElementTypeID,			LayoutTypeID,			ChildCount,			DataSourceID,			LoadFromServer,			IsDataRequired,			AllowBulkUpdate,			DisplayTopHeader,			DisplayTitle,			FrozenColCount,			FrozenRowCount,			AllowPaging,			RowsPerPage,			AllowExportToExcel,			AllowExportToCSV,			FilterMode,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
			SELECT  [cdc].[UI_RepeaterUIElement_CT].UIElementID, [cdc].[UI_RepeaterUIElement_CT].	UIElementTypeID,
			[cdc].[UI_RepeaterUIElement_CT].	LayoutTypeID, [cdc].[UI_RepeaterUIElement_CT].	ChildCount, 
			[cdc].[UI_RepeaterUIElement_CT].DataSourceID, [cdc].[UI_RepeaterUIElement_CT].	LoadFromServer, 
			[cdc].[UI_RepeaterUIElement_CT].IsDataRequired, [cdc].[UI_RepeaterUIElement_CT].AllowBulkUpdate, 
			[cdc].[UI_RepeaterUIElement_CT].	DisplayTopHeader, [cdc].[UI_RepeaterUIElement_CT].	DisplayTitle,
			[cdc].[UI_RepeaterUIElement_CT].	FrozenColCount, [cdc].[UI_RepeaterUIElement_CT].FrozenRowCount,
			[cdc].[UI_RepeaterUIElement_CT].AllowPaging, [cdc].[UI_RepeaterUIElement_CT].	RowsPerPage,
			[cdc].[UI_RepeaterUIElement_CT].	AllowExportToExcel, [cdc].[UI_RepeaterUIElement_CT].AllowExportToCSV,
			[cdc].[UI_RepeaterUIElement_CT].	FilterMode, [cdc].[UI_RepeaterUIElement_CT].MigrationID,
			[cdc].[UI_RepeaterUIElement_CT].	IsMigrated, [cdc].[UI_RepeaterUIElement_CT].IsMigrationOverriden,
			[cdc].[UI_RepeaterUIElement_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
			FROM [cdc].[UI_RepeaterUIElement_CT] where __$operation = 4

			SELECT @dLayoutType =ISNULL(l.DisplayText,'None') FROM [cdc].[UI_RepeaterUIElement_CT] d inner join UI.LayoutType l ON l.LayoutTypeID=d.LayoutTypeID
			SELECT @iLayoutType =ISNULL(l.DisplayText,'None') FROM [cdc].[UI_RepeaterUIElement_CT] i inner join UI.LayoutType l ON l.LayoutTypeID=i.LayoutTypeID

			SELECT @dDisplayTopHeader =ISNULL(DisplayTopHeader,0),@dDisplayTitle =ISNULL(DisplayTitle,0),@dFrozenColCount =ISNULL(FrozenColCount,0),@dFrozenRowCount =ISNULL(FrozenRowCount,0),
			@dAllowPaging =ISNULL(AllowPaging,0) ,@dRowsPerPage =ISNULL(RowsPerPage,0),@dAllowExportToExcel =ISNULL(AllowExportToExcel,0),@dAllowExportToCSV =ISNULL(AllowExportToCSV,0),
			@dFilterMode =ISNULL(FilterMode,'') ,@dDataSourceId =ISNULL(DataSourceID,0) FROM [cdc].[UI_RepeaterUIElement_CT]
					
			SELECT @iDisplayTopHeader =ISNULL(DisplayTopHeader,0),@iDisplayTitle =ISNULL(DisplayTitle,0),@iFrozenColCount =ISNULL(FrozenColCount,0),@iFrozenRowCount =ISNULL(FrozenRowCount,0),
			@iAllowPaging =ISNULL(AllowPaging,0),@iRowsPerPage =ISNULL(RowsPerPage,0),@iAllowExportToExcel =ISNULL(AllowExportToExcel,0),@iAllowExportToCSV =ISNULL(AllowExportToCSV,0),
			@iFilterMode =ISNULL(FilterMode,''),@iDataSourceId =ISNULL(DataSourceID,0)  FROM [cdc].[UI_RepeaterUIElement_CT]

					
			If (@dLayoutType<>@iLayoutType)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				'Layout for Repeater element '+ ui.Label +' is changed from '+ @dLayoutType  + ' to '+ @iLayoutType  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dDisplayTopHeader<>@iDisplayTopHeader)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				'Display top header for Repeater element '+ ui.Label +' is changed from '+ CAST((CASE ISNULL(d.DisplayTopHeader,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX))  + ' to '+ CAST((CASE ISNULL(i.DisplayTopHeader,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX))  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dDisplayTitle<>@iDisplayTitle)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				'Display title for Repeater element '+ ui.Label +' is changed from '+ CAST((CASE ISNULL(d.DisplayTitle,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX))  + ' to '+ CAST((CASE ISNULL(i.DisplayTitle,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX))  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dFrozenColCount<>@iFrozenColCount)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				'Frozen column count for Repeater element '+ ui.Label +' is changed from '+ CAST(ISNULL(d.FrozenColCount,0) AS VARCHAR(MAX))  + ' to '+ CAST(ISNULL(i.FrozenColCount,0)AS VARCHAR(MAX))  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dFrozenRowCount<>@iFrozenRowCount)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				'Frozen row count for Repeater element '+ ui.Label +' is changed from '+ CAST(ISNULL(d.FrozenRowCount,0) AS VARCHAR(MAX))  + ' to '+ CAST(ISNULL(i.FrozenRowCount,0)AS VARCHAR(MAX))  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dAllowPaging<>@iAllowPaging)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				CASE ISNULL(@dAllowPaging,0) WHEN 0 THEN 'Pagination is applied for element ' + cast(ui.Label as varchar(MAX)) 
				ELSE 'Pagination is removed for element ' + cast(ui.Label as varchar(MAX)) END  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dRowsPerPage<>@iRowsPerPage)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				'Rows per page for Repeater element '+ ui.Label +' is changed from '+ CAST(ISNULL(d.RowsPerPage,0) AS VARCHAR(MAX))  + ' to '+ CAST(ISNULL(i.RowsPerPage,0)AS VARCHAR(MAX))  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dAllowExportToExcel<>@iAllowExportToExcel)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				CASE ISNULL(@dAllowExportToExcel,0) WHEN 0 THEN 'Export to excel is allowed for element ' + cast(ui.Label as varchar(MAX)) 
				ELSE 'Export to excel is not allowed for element ' + cast(ui.Label as varchar(MAX)) END  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dAllowExportToCSV<>@iAllowExportToCSV)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				CASE ISNULL(@dAllowExportToCSV,0) WHEN 0 THEN 'Export to CSV is allowed for element ' + cast(ui.Label as varchar(MAX)) 
				ELSE 'Export to CSV is not allowed for element ' + cast(ui.Label as varchar(MAX)) END  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dFilterMode<>@iFilterMode)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				'Filter mode for Repeater element '+ ui.Label +' is changed from '+ ISNULL(d.FilterMode,'None')   + ' to '+ ISNULL(i.FilterMode,'None')  ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy), GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

			If (@dDataSourceId<>@iDataSourceId)
			BEGIN
				INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
				[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
				SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
				'Is Data Source for Repeater element '+ ui.Label +' is changed from '+ CASE ISNULL(@dDataSourceId,0) WHEN 0 THEN 'No' ELSE 'Yes' END  + ' to '+ CASE ISNULL(@iDataSourceId,0) WHEN 0 THEN 'No' ELSE 'Yes' END    ,
				ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
				FROM [cdc].[UI_RepeaterUIElement_CT] d inner join [cdc].[UI_RepeaterUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
				JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
			END;

		END
	END

