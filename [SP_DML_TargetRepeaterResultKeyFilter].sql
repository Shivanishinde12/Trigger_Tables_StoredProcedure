USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlTargetRepeaterResultKeyFilter]

Purpose:
    To maintain records for DML operation performed on table [UI].[TargetRepeaterResultKeyFilter] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  27/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlTargetRepeaterResultKeyFilter]
AS
BEGIN
--Local variables declaration
	DECLARE @Operation	int,@inserted	int,@iSuccessKeyValue NVARCHAR(500),@deleted	int,@dSuccessKeyValue NVARCHAR(500),@iFailureKeyValue NVARCHAR(500),@dFailureKeyValue NVARCHAR(500)
	
	--check if record inserted, updated or deleted
	SET @Operation = (SELECT TOP 1 __$operation FROM [cdc].[UI_TargetRepeaterResultKeyFilter_CT])
	
	IF @operation = 2 ----- For Insert
	BEGIN    
		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Rules - target result key filter for UIElement '+ ui.Label +' is added',p.AddedBy , GETDATE(), p.AddedBy , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_TargetRepeaterResultKeyFilter_CT] i JOIN UI.PropertyRuleMap p ON p.RuleID=i.RuleID
		JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;
    	END;

	ELSE IF @operation = 3 ------- For Update
	BEGIN

		SELECT @dSuccessKeyValue =ISNULL(SuccessKeyValue,''),@dFailureKeyValue =ISNULL(FailureKeyValue,'')  FROM [cdc].[UI_TargetRepeaterResultKeyFilter_CT]
		SELECT @iSuccessKeyValue =ISNULL(SuccessKeyValue,''),@iFailureKeyValue =ISNULL(FailureKeyValue,'') FROM [cdc].[UI_TargetRepeaterResultKeyFilter_CT]

	    If (@dSuccessKeyValue<>@iSuccessKeyValue)
	    BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),	
			'Rule - success result key filter for UIElement '+ ui.Label +' is changed from '+ ISNULL(d.SuccessKeyValue,'None') + ' to '+ ISNULL(i.SuccessKeyValue,'None')   ,
			p.AddedBy , p.AddedDate , p.UpdatedBy , GETDATE(), ui.UIElementName, ui.Label		, ISNULL(fdvui.FormDesignVersionID,0)	 
			FROM [cdc].[UI_TargetRepeaterResultKeyFilter_CT] d inner join [cdc].[UI_TargetRepeaterResultKeyFilter_CT] i ON d.TargetRepeaterResultKeyID=i.TargetRepeaterResultKeyID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID ;
	    END;

		IF (@dFailureKeyValue<>@iFailureKeyValue)
	    BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),	
			'Rule - Failure result key filter for UIElement '+ ui.Label +' is changed from '+ ISNULL(d.FailureKeyValue,'None') + ' to '+ ISNULL(i.FailureKeyValue,'None')   ,	
			p.AddedBy , p.AddedDate , p.UpdatedBy , GETDATE(), ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_TargetRepeaterResultKeyFilter_CT] d inner join [cdc].[UI_TargetRepeaterResultKeyFilter_CT] i ON d.TargetRepeaterResultKeyID=i.TargetRepeaterResultKeyID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID ;
	    END;
	END;
END;
