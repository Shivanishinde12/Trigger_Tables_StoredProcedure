USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlRule]

Purpose:
    To maintain records for DML operation performed on table [UI].[Rule] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  26/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE OR ALTER PROCEDURE [UI].[SpDmlRule]
AS
BEGIN
 SET NOCOUNT ON;
    --Local variables declaration
	DECLARE @Operation	int,@inserted int,@deleted int,@iRuleName VARCHAR(MAX),@dRuleName VARCHAR(MAX),@iRuleDesc VARCHAR(1000),@dRuleDesc VARCHAR(1000),
	@iResultSuccess VARCHAR(1000),@dResultSuccess VARCHAR(1000),@iResultFailure VARCHAR(1000),@dResultFailure VARCHAR(1000),@iIsResultSuccessElement bit,
	@dIsResultSuccessElement bit,@iIsResultFailureElement bit,@dIsResultFailureElement bit,@iMessage VARCHAR(1000),@dMessage VARCHAR(1000),@iRunOnLoad bit,
	@dRunOnLoad bit,@formDesignName VARCHAR(200), @formDesignVersionId int, @iIsStandard bit,  @dIsStandard bit, @username nvarchar(50)

	--Check if record inserted, deleted or updated
	SET @Operation = (SELECT TOP 1 __$operation FROM [cdc].[UI_Rule_CT])

	IF @Operation = 1  ---For Delete
	BEGIN
		INSERT INTO [Trgr].[Rule]
		(	RuleID,			RuleName,			RuleDescription,			RuleTargetTypeID,			ResultSuccess,			ResultFailure,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsResultSuccessElement,			IsResultFailureElement,			[Message],			RunOnLoad,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT	[cdc].[UI_Rule_CT].RuleID, [cdc].[UI_Rule_CT].RuleName, [cdc].[UI_Rule_CT].	RuleDescription,
		[cdc].[UI_Rule_CT].	RuleTargetTypeID, [cdc].[UI_Rule_CT].	ResultSuccess, [cdc].[UI_Rule_CT].	ResultFailure,
		[cdc].[UI_Rule_CT].	AddedBy, [cdc].[UI_Rule_CT].	AddedDate, [cdc].[UI_Rule_CT].	UpdatedBy, 
		[cdc].[UI_Rule_CT].	UpdatedDate, [cdc].[UI_Rule_CT].	IsResultSuccessElement, 
		[cdc].[UI_Rule_CT].IsResultFailureElement, [cdc].[UI_Rule_CT].[Message], [cdc].[UI_Rule_CT].	RunOnLoad,
		[cdc].[UI_Rule_CT].	MigrationID, [cdc].[UI_Rule_CT].	IsMigrated, [cdc].[UI_Rule_CT].IsMigrationOverriden,
		[cdc].[UI_Rule_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_Rule_CT] Where __$operation = 1

		SET @formDesignName = (SELECT TOP 1 ISNULL(DisplayText,'') FROM UI.FormDesign frm INNER JOIN [cdc].[UI_Rule_CT] d ON frm.FormID  = d.FormDesignID);

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(d.FormDesignID,0),ISNULL(d.RuleID , 0),d.RuleName + ' rule is deleted',d.AddedBy , d.AddedDate ,
		ISNULL(d.UpdatedBy, d.AddedBy) , GETDATE(), ISNULL(d.RuleName,''), ISNULL(@formDesignName, ''), 0
		FROM [cdc].[UI_Rule_CT] d ;
			
		IF EXISTS (SELECT * FROM dbo.ActivityLogForRM)
		BEGIN
			SELECT @username =  ISNULL(UserName,''), @formDesignVersionId = ISNULL(ActivityLoggerID ,0) FROM 	dbo.ActivityLogForRM;

			UPDATE ui.FormDesignVersionActivityLog SET FormDesignVersionId = @formDesignVersionId,UpdatedBy = @username, AddedBy = @username Where ActivityLoggerID = @@identity;							
			TRUNCATE TABLE dbo.ActivityLogForRM;
		END;
			
	END

	ELSE IF @operation = 2 ----- For Insert
	BEGIN  
		SET @formDesignName = (SELECT TOP 1 ISNULL(DisplayText,'') from UI.FormDesign frm INNER JOIN [cdc].[UI_Rule_CT] i ON frm.FormID  = i.FormDesignID);
		--SET @formDesignVersionId = ISNULL((Select max(fdv.FormDesignVersionID) from UI.FormDesignVersion fdv INNER JOIN inserted i  ON i.FormDesignID=fdv.FormDesignID ),0)
		INSERT INTO [Trgr].[Rule]
		(	RuleID,			RuleName,			RuleDescription,			RuleTargetTypeID,			ResultSuccess,			ResultFailure,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsResultSuccessElement,			IsResultFailureElement,			[Message],			RunOnLoad,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT	[cdc].[UI_Rule_CT].RuleID, [cdc].[UI_Rule_CT].RuleName, [cdc].[UI_Rule_CT].	RuleDescription,
		[cdc].[UI_Rule_CT].	RuleTargetTypeID, [cdc].[UI_Rule_CT].	ResultSuccess, [cdc].[UI_Rule_CT].	ResultFailure,
		[cdc].[UI_Rule_CT].	AddedBy, [cdc].[UI_Rule_CT].	AddedDate, [cdc].[UI_Rule_CT].	UpdatedBy, 
		[cdc].[UI_Rule_CT].	UpdatedDate, [cdc].[UI_Rule_CT].	IsResultSuccessElement, 
		[cdc].[UI_Rule_CT].IsResultFailureElement, [cdc].[UI_Rule_CT].[Message], [cdc].[UI_Rule_CT].	RunOnLoad,
		[cdc].[UI_Rule_CT].	MigrationID, [cdc].[UI_Rule_CT].	IsMigrated, [cdc].[UI_Rule_CT].IsMigrationOverriden,
		[cdc].[UI_Rule_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_Rule_CT] Where __$operation = 2

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ISNULL(ui.FormID,i.FormDesignID),0),ISNULL(ui.UIElementID,0), i.RuleName + ' rule with '+ t.TargetPropertyName +' rule type is added for '+ ISNULL(ui.Label,@formDesignName) +' field' ,i.AddedBy , GETDATE(), i.AddedBy ,GETDATE()
		, ISNULL(ui.UIElementName,''), ISNULL(ui.Label,@formDesignName), ISNULL(uimap.FormDesignVersionID,0)
		FROM [cdc].[UI_Rule_CT] i 
		LEFT JOIN UI.TargetProperty t ON t.TargetPropertyID = i.TargetTypeID 
		LEFT JOIN UI.PropertyRuleMap p ON p.RuleID=i.RuleID
		LEFT JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID
		LEFT JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ; 
		END;

		TRUNCATE TABLE dbo.ActivityLogForRM;
		INSERT INTO dbo.ActivityLogForRM VALUES (@@identity, NULL);
	
	IF @Operation = 3
	BEGIN
		INSERT INTO [Trgr].[Rule]
		(	RuleID,			RuleName,			RuleDescription,			RuleTargetTypeID,			ResultSuccess,			ResultFailure,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsResultSuccessElement,			IsResultFailureElement,			[Message],			RunOnLoad,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT	[cdc].[UI_Rule_CT].RuleID, [cdc].[UI_Rule_CT].RuleName, [cdc].[UI_Rule_CT].	RuleDescription,
		[cdc].[UI_Rule_CT].	RuleTargetTypeID, [cdc].[UI_Rule_CT].	ResultSuccess, [cdc].[UI_Rule_CT].	ResultFailure,
		[cdc].[UI_Rule_CT].	AddedBy, [cdc].[UI_Rule_CT].	AddedDate, [cdc].[UI_Rule_CT].	UpdatedBy,
		[cdc].[UI_Rule_CT].	UpdatedDate, [cdc].[UI_Rule_CT].	IsResultSuccessElement,
		[cdc].[UI_Rule_CT].IsResultFailureElement, [cdc].[UI_Rule_CT].[Message], [cdc].[UI_Rule_CT].	RunOnLoad,
		[cdc].[UI_Rule_CT].	MigrationID, [cdc].[UI_Rule_CT].	IsMigrated, [cdc].[UI_Rule_CT].IsMigrationOverriden,
		[cdc].[UI_Rule_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_Rule_CT] Where __$operation = 3

		INSERT INTO [Trgr].[Rule]
		(	RuleID,			RuleName,			RuleDescription,			RuleTargetTypeID,			ResultSuccess,			ResultFailure,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsResultSuccessElement,			IsResultFailureElement,			[Message],			RunOnLoad,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT	[cdc].[UI_Rule_CT].RuleID, [cdc].[UI_Rule_CT].RuleName, [cdc].[UI_Rule_CT].	RuleDescription,
		[cdc].[UI_Rule_CT].	RuleTargetTypeID, [cdc].[UI_Rule_CT].	ResultSuccess, [cdc].[UI_Rule_CT].	ResultFailure,
		[cdc].[UI_Rule_CT].	AddedBy, [cdc].[UI_Rule_CT].	AddedDate, [cdc].[UI_Rule_CT].	UpdatedBy, 
		[cdc].[UI_Rule_CT].	UpdatedDate, [cdc].[UI_Rule_CT].	IsResultSuccessElement, 
		[cdc].[UI_Rule_CT].IsResultFailureElement, [cdc].[UI_Rule_CT].[Message], [cdc].[UI_Rule_CT].	RunOnLoad,
		[cdc].[UI_Rule_CT].	MigrationID, [cdc].[UI_Rule_CT].	IsMigrated, [cdc].[UI_Rule_CT].IsMigrationOverriden,
		[cdc].[UI_Rule_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_Rule_CT] Where __$operation = 4

		SELECT @dRuleName =ISNULL(RuleName,''),@dRuleDesc =ISNULL(RuleDescription,''),@dResultSuccess =ISNULL(ResultSuccess,''),@dResultFailure =ISNULL(ResultFailure,''),
		@dIsResultSuccessElement =ISNULL(IsResultSuccessElement,0),@dIsResultFailureElement =ISNULL(IsResultFailureElement,0),@dMessage =ISNULL([Message],''),@dRunOnLoad =ISNULL(RunOnLoad,0),
		@dIsStandard = ISNULL(IsStandard,0) FROM [cdc].[UI_Rule_CT]

		SELECT @iRuleName =ISNULL(RuleName,''),@iRuleDesc =ISNULL(RuleDescription,''),@iResultSuccess =ISNULL(ResultSuccess,''),@iResultFailure =ISNULL(ResultFailure,''),
		@iIsResultSuccessElement =ISNULL(IsResultSuccessElement,0),@iIsResultFailureElement =ISNULL(IsResultFailureElement,0),@iMessage =ISNULL([Message],''),@iRunOnLoad =ISNULL(RunOnLoad,0),
		@iIsStandard = ISNULL(IsStandard,0) FROM [cdc].[UI_Rule_CT]

		If (@dRuleName<>@iRuleName)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),
			'Rule Name for Rule - '+ d.RuleName +' is changed from '+ ISNULL(d.RuleName,'None') + ' to '+ ISNULL(i.RuleName,'None')   ,
			d.AddedBy , d.AddedDate , ISNULL(i.UpdatedBy, d.AddedBy) , GETDATE(), ISNULL(ui.UIElementName,''), ISNULL(ui.Label,''), ISNULL(uimap.FormDesignVersionID,0)
			FROM [cdc].[UI_Rule_CT] d inner join [cdc].[UI_Rule_CT] i ON d.RuleID=i.RuleID 
			LEFT JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			LEFT JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID
			LEFT JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ; 
		END;

		If (@dRuleDesc<>@iRuleDesc)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),
			'Rule Description for Rule - '+ d.RuleName +' is changed from '+ ISNULL(d.RuleDescription,'None') + ' to '+ ISNULL(i.RuleDescription,'None')   ,
			d.AddedBy , d.AddedDate , ISNULL(i.UpdatedBy, d.AddedBy), GETDATE(), ISNULL(ui.UIElementName,''), ISNULL(ui.Label,''), ISNULL(uimap.FormDesignVersionID,0)
			FROM [cdc].[UI_Rule_CT] d inner join [cdc].[UI_Rule_CT] i ON d.RuleID=i.RuleID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID 
			JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ; 
		END;

		If (@dResultSuccess<>@iResultSuccess)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),
			'Rule - Result Success for Rule - '+ d.RuleName +' is changed from '+ ISNULL(d.ResultSuccess,'None') + ' to '+ ISNULL(i.ResultSuccess,'None')   ,
			d.AddedBy , d.AddedDate , ISNULL(i.UpdatedBy, d.AddedBy) , GETDATE(), ISNULL(ui.UIElementName,''), ISNULL(ui.Label,''), ISNULL(uimap.FormDesignVersionID,0)			 
			FROM [cdc].[UI_Rule_CT] d inner join [cdc].[UI_Rule_CT] i ON d.RuleID=i.RuleID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID
			JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ;  
		END;

		If (@dResultFailure<>@iResultFailure)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),			
			'Rule - Result Failure for Rule - '+ d.RuleName +' is changed from '+ ISNULL(d.ResultFailure,'None') + ' to '+ ISNULL(i.ResultFailure,'None')   ,		
			d.AddedBy , d.AddedDate , ISNULL(i.UpdatedBy, d.AddedBy) , GETDATE(), ISNULL(ui.UIElementName,''), ISNULL(ui.Label,''), ISNULL(uimap.FormDesignVersionID,0)		 
			FROM [cdc].[UI_Rule_CT] d inner join [cdc].[UI_Rule_CT] i ON d.RuleID=i.RuleID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID 
			JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ; 
		END;

		IF (@dIsResultSuccessElement<>@iIsResultSuccessElement)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),
			'Rule - Is Result Success Element for Rule - '+ d.RuleName +' is changed from '+ CAST((CASE ISNULL(d.IsResultSuccessElement,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX)) + ' to '+ CAST((CASE ISNULL(i.IsResultSuccessElement,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX))   ,
			d.AddedBy , d.AddedDate ,ISNULL(i.UpdatedBy, d.AddedBy) , GETDATE(), ISNULL(ui.UIElementName,''), ISNULL(ui.Label,''), ISNULL(uimap.FormDesignVersionID,0)		 
			FROM [cdc].[UI_Rule_CT] d inner join [cdc].[UI_Rule_CT] i ON d.RuleID=i.RuleID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID 
			JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ; 
		END;

		IF (@dIsResultFailureElement<>@iIsResultFailureElement)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),
			'Rule - Is Result Failure Element for Rule - '+ d.RuleName +' is changed from '+ CAST((CASE ISNULL(d.IsResultFailureElement,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX)) + ' to '+ CAST((CASE ISNULL(i.IsResultFailureElement,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX))  ,
			d.AddedBy , d.AddedDate , ISNULL(i.UpdatedBy, d.AddedBy) , GETDATE(), ISNULL(ui.UIElementName,''), ISNULL(ui.Label,''), ISNULL(uimap.FormDesignVersionID,0)
			FROM [cdc].[UI_Rule_CT] d inner join [cdc].[UI_Rule_CT] i ON d.RuleID=i.RuleID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID 
			JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ; 
		END;
			   
		IF (@dMessage<>@iMessage)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),		
			'Rule message for Rule - '+ d.RuleName +' is changed from '+ISNULL(d.[Message],'None')  + ' to '+ ISNULL(i.[Message],'None')   ,	
			d.AddedBy , d.AddedDate , ISNULL(i.UpdatedBy, d.AddedBy), GETDATE(), ISNULL(ui.UIElementName,''), ISNULL(ui.Label,''), ISNULL(uimap.FormDesignVersionID,0)		 
			FROM [cdc].[UI_Rule_CT] d inner join [cdc].[UI_Rule_CT] i ON d.RuleID=i.RuleID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID 
			JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ; 
		END;

		If (@dRunOnLoad<>@iRunOnLoad)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),			
			CASE ISNULL(@dRunOnLoad,0) WHEN 0 THEN 'Rule '+ d.RuleName +' should be executed on load' 
			ELSE 'Rule '+ d.RuleName +' should be not execute on load'  END  ,
			d.AddedBy , d.AddedDate , ISNULL(i.UpdatedBy, d.AddedBy) , GETDATE(), ISNULL(ui.UIElementName,''), ISNULL(ui.Label,''), ISNULL(uimap.FormDesignVersionID,0)		 
			FROM [cdc].[UI_Rule_CT] d inner join [cdc].[UI_Rule_CT] i ON d.RuleID=i.RuleID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID 
			JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ; 
		END;

		IF (@dIsStandard<>@iIsStandard)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),			
			CASE ISNULL(@iIsStandard,0) WHEN 1 THEN 'Is Standard property for rule '+ ISNULL(i.RuleName,'') +' is checked'  ELSE 'Is Standard property for rule '+ ISNULL(i.RuleName,'') +' is unchecked' END ,
			d.AddedBy , d.AddedDate , ISNULL(i.UpdatedBy, d.AddedBy) , GETDATE(), ISNULL(ui.UIElementName,''), ISNULL(ui.Label,''), ISNULL(uimap.FormDesignVersionID,0)		 
			FROM [cdc].[UI_Rule_CT] d inner join [cdc].[UI_Rule_CT] i ON d.RuleID=i.RuleID 
			JOIN UI.PropertyRuleMap p ON p.RuleID=d.RuleID
			JOIN UI.UIElement ui ON ui.UIElementID=p.UIElementID 
			JOIN [UI].FormDesignVersionUIElementMap uimap on uimap.UIElementID = ui.UIElementID ; 
		END;
	END
		
END

