USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlTargetRepeaterKeyFilter]

Purpose:
    To maintain records for DML operation performed on table [UI].[TargetRepeaterKeyFilter] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  27/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlTargetRepeaterKeyFilter]
AS
BEGIN
--Local variables declaration
	DECLARE @Operation	int, @inserted	int,@deleted	int,@iRepKeyValue NVARCHAR(500),@dRepKeyValue NVARCHAR(500)
	
	--Check if record inserted, updated or deleted
	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_TargetRepeaterKeyFilter_CT])
	
	IF @operation = 2 ----- For Insert
	BEGIN       
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Rule-target key filter for element '+ ui.Label +' is added',p.AddedBy , GETDATE(), p.AddedBy , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_TargetRepeaterKeyFilter_CT] i JOIN UI.PropertyRuleMap p ON p.PropertyRuleMapID=i.PropertyRuleMapID
		JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;
    	END;

	ELSE IF @operation = 3 ------- For Update
	BEGIN
		SELECT @dRepKeyValue =ISNULL(RepeaterKeyValue,'') FROM [cdc].[UI_TargetRepeaterKeyFilter_CT]
		SELECT @iRepKeyValue =ISNULL(RepeaterKeyValue,'') FROM [cdc].[UI_TargetRepeaterKeyFilter_CT]

		If (@dRepKeyValue<>@iRepKeyValue)
	    BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),		
			'Rule-target key filter for element '+ ui.Label +' is changed from '+ ISNULL(d.RepeaterKeyValue,'None')  + ' to '+ ISNULL(i.RepeaterKeyValue,'None') ,		
			p.AddedBy , p.AddedDate , p.UpdatedBy , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)			 
			FROM [cdc].[UI_TargetRepeaterKeyFilter_CT] d inner join [cdc].[UI_TargetRepeaterKeyFilter_CT] i ON d.TargetRepeaterKeyID=i.TargetRepeaterKeyID 
			inner join UI.PropertyRuleMap p ON p.PropertyRuleMapID=d.PropertyRuleMapID
			inner join UI.UIElement ui ON ui.UIElementID=p.UIElementID JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;
	    END;		
	END;
END;
