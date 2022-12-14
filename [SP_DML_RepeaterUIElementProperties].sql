USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlRepeaterUIElementProperties]

Purpose:
    To maintain records for DML operation performed on table [UI].[RepeaterUIElementProperties] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  26/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlRepeaterUIElementProperties]
AS
BEGIN
	DECLARE @Operation	int,@inserted	int,@deleted	int,@iRowTemplate NVARCHAR(MAX),@dRowTemplate NVARCHAR(MAX),@iHeaderTemplate NVARCHAR(MAX),@dHeaderTemplate NVARCHAR(MAX),
	 @iFooterTemplate NVARCHAR(MAX),@dFooterTemplate NVARCHAR(MAX)
	
	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_RepeaterUIElementProperties_CT])
	
	IF @Operation = 2 ----- For Insert
	BEGIN        
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(i.RepeaterUIElementID,0),'Repeater attributes for element '+ ui.Label +' are added',ui.AddedBy , GETDATE(), ui.AddedBy , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_RepeaterUIElementProperties_CT] i JOIN UI.UIElement ui ON ui.UIElementID=i.RepeaterUIElementID
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID ;
   	END;

	ELSE IF @Operation = 3 ------- For Update
	BEGIN
		SELECT @dRowTemplate =ISNULL(RowTemplate,''),@dHeaderTemplate =ISNULL(HeaderTemplate,''),@dFooterTemplate =ISNULL(FooterTemplate,'')  FROM [cdc].[UI_RepeaterUIElementProperties_CT]
		SELECT @iRowTemplate =ISNULL(RowTemplate,''),@iHeaderTemplate =ISNULL(HeaderTemplate,''),@iFooterTemplate =ISNULL(FooterTemplate,'') FROM [cdc].[UI_RepeaterUIElementProperties_CT]

	    IF (@dRowTemplate<>@iRowTemplate)
	    BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),			
			'Row template for element '+ ui.Label +' is changed from '+ ISNULL(d.RowTemplate,'None')  + ' to '+ ISNULL(i.RowTemplate,'None')  ,			
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy), GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)		 
			FROM [cdc].[UI_RepeaterUIElementProperties_CT] d inner join [cdc].[UI_RepeaterUIElementProperties_CT] i ON d.RepeaterUIElementPropertyID=i.RepeaterUIElementPropertyID inner join UI.UIElement ui ON ui.UIElementID=d.RepeaterUIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
	    END;

	    IF (@dHeaderTemplate<>@iHeaderTemplate)
	    BEGIN
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
		'Header template for element '+ ui.Label +' is changed from '+ ISNULL(d.HeaderTemplate,'None')  + ' to '+ ISNULL(i.HeaderTemplate,'None')  ,	
		ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)	 
		FROM [cdc].[UI_RepeaterUIElementProperties_CT] d inner join [cdc].[UI_RepeaterUIElementProperties_CT] i ON d.RepeaterUIElementPropertyID=i.RepeaterUIElementPropertyID inner join UI.UIElement ui ON ui.UIElementID=d.RepeaterUIElementID 
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
	    END;

	    If (@dFooterTemplate<>@iFooterTemplate)
	    BEGIN
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
		'Footer template for element '+ ui.Label +' is changed from '+ ISNULL(d.FooterTemplate,'None')  + ' to '+ ISNULL(i.FooterTemplate,'None')  ,		
		ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)		 
		FROM [cdc].[UI_RepeaterUIElementProperties_CT] d inner join [cdc].[UI_RepeaterUIElementProperties_CT] i ON d.RepeaterUIElementPropertyID=i.RepeaterUIElementPropertyID  inner join UI.UIElement ui ON ui.UIElementID=d.RepeaterUIElementID 
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
	    END;
			 
	END;

	ELSE IF @operation = 1 ------ For Delete
	BEGIN
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Repeater attributes for element '+ ui.Label +' are deleted',ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_RepeaterUIElementProperties_CT] d JOIN UI.UIElement ui ON ui.UIElementID=d.RepeaterUIElementID 
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
	END;
END;
