USE [eBS4_INT_QA2]
GO
/****** Object:  Trigger [UI].[DML_Trgr_DocumentRule]    Script Date: 10/3/2022 11:09:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE  [UI].[SPDmlDocumentRule]
AS
BEGIN
 SET NOCOUNT ON;
    --Local variables declaration
	DECLARE @Operation	int,@inserted	int,@deleted	int,@iDispText VARCHAR(5000),@dDispText VARCHAR(5000),@iDesc VARCHAR(5000),@dDesc VARCHAR(5000),@iRuleJSON VARCHAR(MAX),@dRuleJSON VARCHAR(MAX)
	
	--Check if record inserted, updated or deleted
	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_DocumentRule_CT])

	IF @Operation = 1 --for deleted
	BEGIN
		INSERT INTO [Trgr].[DocumentRule]
		(		DocumentRuleID,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			DocumentRuleTypeID,			DocumentRuleTargetTypeID,			RuleJSON,			FormDesignID,			FormDesignVersionID,			TargetUIElementID,			TargetElementPath,			CompiledRuleJSON,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRule_CT].DocumentRuleID, [cdc].[UI_DocumentRule_CT].DisplayText, 
		[cdc].[UI_DocumentRule_CT].	[Description], [cdc].[UI_DocumentRule_CT].	AddedBy,[cdc].[UI_DocumentRule_CT].	AddedDate,
		[cdc].[UI_DocumentRule_CT].	UpdatedBy, [cdc].[UI_DocumentRule_CT].	UpdatedDate, [cdc].[UI_DocumentRule_CT].	IsActive,
		[cdc].[UI_DocumentRule_CT].	DocumentRuleTypeID, [cdc].[UI_DocumentRule_CT].DocumentRuleTargetTypeID, 
		[cdc].[UI_DocumentRule_CT].	RuleJSON, [cdc].[UI_DocumentRule_CT].	FormDesignID, 
		[cdc].[UI_DocumentRule_CT].	FormDesignVersionID, [cdc].[UI_DocumentRule_CT].	TargetUIElementID,
		[cdc].[UI_DocumentRule_CT].	TargetElementPath, [cdc].[UI_DocumentRule_CT].	CompiledRuleJSON,
		[cdc].[UI_DocumentRule_CT].	MigrationID, [cdc].[UI_DocumentRule_CT].	IsMigrated, 
		[cdc].[UI_DocumentRule_CT].IsMigrationOverriden, [cdc].[UI_DocumentRule_CT].	MigrationDate, 
		4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRule_CT] WHERE __$Operation = 1

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(d.FormDesignID,0),ISNULL(ui.UIElementID,0),'Document rule for element '+ ui.Label +' is deleted',d.AddedBy , d.AddedDate , ISNULL(d.UpdatedBy, d.AddedBy) , GETDATE()
		, ui.UIElementName, ui.Label ,ISNULL(d.FormDesignVersionID,0)
		FROM [cdc].[UI_DocumentRule_CT] d JOIN UI.UIElement ui ON ui.UIElementID=d.TargetUIElementID 
	END

	ELSE IF @operation = 2 ----- For Insert
	BEGIN

		INSERT INTO [Trgr].[DocumentRule]
		(		DocumentRuleID,				DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			DocumentRuleTypeID,				DocumentRuleTargetTypeID,			RuleJSON,			FormDesignID,			FormDesignVersionID,			TargetUIElementID,			TargetElementPath,			CompiledRuleJSON,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRule_CT].	DocumentRuleID, [cdc].[UI_DocumentRule_CT].	DisplayText,
		[cdc].[UI_DocumentRule_CT].	[Description], [cdc].[UI_DocumentRule_CT].AddedBy, [cdc].[UI_DocumentRule_CT].	AddedDate,
		[cdc].[UI_DocumentRule_CT].UpdatedBy, [cdc].[UI_DocumentRule_CT].UpdatedDate, 
		[cdc].[UI_DocumentRule_CT].	IsActive, [cdc].[UI_DocumentRule_CT].	DocumentRuleTypeID,
		[cdc].[UI_DocumentRule_CT].	DocumentRuleTargetTypeID, [cdc].[UI_DocumentRule_CT].	RuleJSON,
		[cdc].[UI_DocumentRule_CT].	FormDesignID, [cdc].[UI_DocumentRule_CT].	FormDesignVersionID,
		[cdc].[UI_DocumentRule_CT].	TargetUIElementID, [cdc].[UI_DocumentRule_CT].TargetElementPath,
		[cdc].[UI_DocumentRule_CT].CompiledRuleJSON, [cdc].[UI_DocumentRule_CT].	MigrationID,
		[cdc].[UI_DocumentRule_CT].	IsMigrated, [cdc].[UI_DocumentRule_CT].	IsMigrationOverriden,
		[cdc].[UI_DocumentRule_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRule_CT] WHERE  __$Operation = 2

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(i.FormDesignID,0),ISNULL(i.TargetUIElementID,0),'Document rule for element '+ ui.Label +' is added',i.AddedBy , GETDATE(), i.AddedBy , GETDATE()
		, ui.UIElementName, ui.Label ,ISNULL(i.FormDesignVersionID,0)
		FROM [cdc].[UI_DocumentRule_CT] i JOIN UI.UIElement ui ON ui.UIElementID=i.TargetUIElementID ;
	END;

	ELSE IF @Operation = 3
	BEGIN

	SELECT @dDispText =ISNULL(DisplayText,''),@dDesc =ISNULL([Description],''),@dRuleJSON =ISNULL(RuleJSON,'') FROM [cdc].[UI_DocumentRule_CT]
	SELECT @iDispText =ISNULL(DisplayText,''),@iDesc =ISNULL([Description],''),@iRuleJSON =ISNULL(RuleJSON,'') FROM [cdc].[UI_DocumentRule_CT]

		IF (@dDispText<>@iDispText)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormDesignID,0),ISNULL(ui.UIElementID,0),
			'Expression rule display text for element '+ ui.Label +' is changed from '+ ISNULL(d.DisplayText,'None')  + ' to '+ ISNULL(i.DisplayText,'None') ,	
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, d.UpdatedBy) , GETDATE(), ui.UIElementName, ui.Label,ISNULL(i.FormDesignVersionID,0)	 
			FROM [cdc].[UI_DocumentRule_CT] d inner join [cdc].[UI_DocumentRule_CT] i ON d.DocumentRuleID=i.DocumentRuleID inner join UI.UIElement ui ON ui.UIElementID=d.TargetUIElementID 
		END;

		If (@dDesc<>@iDesc)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormDesignID,0),ISNULL(ui.UIElementID,0),
			'Expression rule description for element '+ ui.Label +' is changed from '+ ISNULL(d.[Description],'None')  + ' to '+ ISNULL(i.[Description],'None') ,
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, d.UpdatedBy) , GETDATE(), ui.UIElementName, ui.Label,ISNULL(i.FormDesignVersionID,0)
			FROM [cdc].[UI_DocumentRule_CT] d inner join [cdc].[UI_DocumentRule_CT] i ON d.DocumentRuleID=i.DocumentRuleID inner join UI.UIElement ui ON ui.UIElementID=d.TargetUIElementID 
		END;

		If (@dRuleJSON<>@iRuleJSON)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormDesignID,0),ISNULL(ui.UIElementID,0),	
			'Expression rule for element '+ ui.Label +' updated',	
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, d.UpdatedBy) , GETDATE(), ui.UIElementName, ui.Label,ISNULL(i.FormDesignVersionID,0)
			FROM [cdc].[UI_DocumentRule_CT] d inner join [cdc].[UI_DocumentRule_CT] i ON d.DocumentRuleID=i.DocumentRuleID inner join UI.UIElement ui ON ui.UIElementID=d.TargetUIElementID 
		END;

		INSERT INTO [Trgr].[DocumentRule]
		(		DocumentRuleID,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			DocumentRuleTypeID,			DocumentRuleTargetTypeID,			RuleJSON,			FormDesignID,			FormDesignVersionID,			TargetUIElementID,			TargetElementPath,			CompiledRuleJSON,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRule_CT].DocumentRuleID, [cdc].[UI_DocumentRule_CT].DisplayText,
		[cdc].[UI_DocumentRule_CT].	[Description], [cdc].[UI_DocumentRule_CT].	AddedBy, [cdc].[UI_DocumentRule_CT].	AddedDate,
		[cdc].[UI_DocumentRule_CT].	UpdatedBy, [cdc].[UI_DocumentRule_CT].	UpdatedDate, 
		[cdc].[UI_DocumentRule_CT].	IsActive, [cdc].[UI_DocumentRule_CT].	DocumentRuleTypeID, 
		[cdc].[UI_DocumentRule_CT].DocumentRuleTargetTypeID, [cdc].[UI_DocumentRule_CT].	RuleJSON,
		[cdc].[UI_DocumentRule_CT].	FormDesignID, [cdc].[UI_DocumentRule_CT].	FormDesignVersionID, 
		[cdc].[UI_DocumentRule_CT].	TargetUIElementID, [cdc].[UI_DocumentRule_CT].	TargetElementPath,
		[cdc].[UI_DocumentRule_CT].	CompiledRuleJSON, [cdc].[UI_DocumentRule_CT].	MigrationID,
		[cdc].[UI_DocumentRule_CT].	IsMigrated, [cdc].[UI_DocumentRule_CT].IsMigrationOverriden, 
		[cdc].[UI_DocumentRule_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRule_CT] WHERE __$Operation = 3

		INSERT INTO [Trgr].[DocumentRule]
		(		DocumentRuleID,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			DocumentRuleTypeID,			DocumentRuleTargetTypeID,			RuleJSON,			FormDesignID,			FormDesignVersionID,			TargetUIElementID,			TargetElementPath,			CompiledRuleJSON,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_DocumentRule_CT].DocumentRuleID, [cdc].[UI_DocumentRule_CT].DisplayText,
		[cdc].[UI_DocumentRule_CT].	[Description], [cdc].[UI_DocumentRule_CT].	AddedBy, [cdc].[UI_DocumentRule_CT].	AddedDate,
		[cdc].[UI_DocumentRule_CT].	UpdatedBy, [cdc].[UI_DocumentRule_CT].	UpdatedDate, 
		[cdc].[UI_DocumentRule_CT].	IsActive, [cdc].[UI_DocumentRule_CT].	DocumentRuleTypeID, 
		[cdc].[UI_DocumentRule_CT].DocumentRuleTargetTypeID, [cdc].[UI_DocumentRule_CT].	RuleJSON,
		[cdc].[UI_DocumentRule_CT].	FormDesignID, [cdc].[UI_DocumentRule_CT].	FormDesignVersionID, 
		[cdc].[UI_DocumentRule_CT].	TargetUIElementID, [cdc].[UI_DocumentRule_CT].	TargetElementPath,
		[cdc].[UI_DocumentRule_CT].	CompiledRuleJSON, [cdc].[UI_DocumentRule_CT].	MigrationID,
		[cdc].[UI_DocumentRule_CT].	IsMigrated, [cdc].[UI_DocumentRule_CT].IsMigrationOverriden, 
		[cdc].[UI_DocumentRule_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_DocumentRule_CT] WHERE __$Operation = 4
	END	
END
