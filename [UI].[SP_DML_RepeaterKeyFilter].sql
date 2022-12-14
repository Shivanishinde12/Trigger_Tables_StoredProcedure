USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlRepeaterKeyFilter]

Purpose:
    To maintain records for DML operation performed on table [UI].[RepeaterKeyFilter] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  22/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlRepeaterKeyFilter]
AS
BEGIN
--Local varaiables declaration
	DECLARE @Operation	int,@inserted	int,@deleted	int,@iRepKeyValue NVARCHAR(500),@dRepKeyValue NVARCHAR(500)
	
	SET @Operation = (SELECT TOP 1 __$operation FROM [cdc].[UI_RepeaterKeyFilter_CT])
	
	IF @operation = 2 ----- For Insert
	BEGIN
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Rule-repeater key filter for element '+ ui.Label +' is added',p.AddedBy , GETDATE(), p.AddedBy , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_RepeaterKeyFilter_CT] i JOIN UI.PropertyRuleMap p ON p.PropertyRuleMapID=i.PropertyRuleMapID
		JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID LEFT JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;
    	END;

	ELSE 
	IF @operation = 3 ------- For Update
	BEGIN
		SELECT @dRepKeyValue =ISNULL(RepeaterKeyValue,'') FROM [cdc].[UI_RepeaterKeyFilter_CT]
		SELECT @iRepKeyValue =ISNULL(RepeaterKeyValue,'') FROM [cdc].[UI_RepeaterKeyFilter_CT]

		If (@dRepKeyValue<>@iRepKeyValue)
	    BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Rule-key filter for element '+ ui.Label +' is changed from '+ ISNULL(d.RepeaterKeyValue,'None')  + ' to '+ ISNULL(i.RepeaterKeyValue,'None') ,
			p.AddedBy , p.AddedDate , p.UpdatedBy , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_RepeaterKeyFilter_CT] d inner join [cdc].[UI_RepeaterKeyFilter_CT] i ON d.RepeaterKeyID=i.RepeaterKeyID 
			inner join UI.PropertyRuleMap p ON p.PropertyRuleMapID=d.PropertyRuleMapID inner join UI.UIElement ui ON ui.UIElementID=p.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
	    END;
	END;

	ELSE IF @operation = 1 ------ For Delete
	BEGIN
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Rule-repeater key filter for element '+ ui.Label +' is deleted',p.AddedBy , p.AddedDate , p.UpdatedBy , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_RepeaterKeyFilter_CT] d JOIN UI.PropertyRuleMap p ON p.PropertyRuleMapID=d.PropertyRuleMapID JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID 
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
	END;
END
