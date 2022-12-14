USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name:
    [UI].[SpDmlRadioButtonUIElement]

Purpose:
    To maintain records for DML operation performed on table [UI].[RadioButtonUIElement] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  22/09/2022 by Shivani Shinde 
    Modified on ---------
*/
CREATE or ALTER PROCEDURE [UI].[SpDmlRadioButtonUIElement]
AS
BEGIN
 SET NOCOUNT ON;
    --Local variables declaration
	DECLARE @Operation	int,@inserted	int,@deleted	int,@iOptionLabel NVARCHAR(200),@dOptionLabel NVARCHAR(200),@iDefValue VARCHAR(MAX),@dDefValue VARCHAR(MAX),@iIsYesNo bit,@dIsYesNo bit,
	@iOptionLabelNo NVARCHAR(100),@dOptionLabelNo NVARCHAR(100)
	
	--check if record inserted , updated or deleted
	SET @Operation = (SELECT TOP 1 __$operation FROM [cdc].[UI_RadioButtonUIElement_CT])

	IF @Operation = 1 --for deleted
	BEGIN
		INSERT INTO [Trgr].[RadioButtonUIElement]
		(	UIElementID,			UIElementTypeID,			OptionLabel,			DefaultValue,			IsYesNo,			OptionLabelNo,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_RadioButtonUIElement_CT].UIElementID, [cdc].[UI_RadioButtonUIElement_CT].	UIElementTypeID, 
		[cdc].[UI_RadioButtonUIElement_CT].	OptionLabel, [cdc].[UI_RadioButtonUIElement_CT].	DefaultValue,
		[cdc].[UI_RadioButtonUIElement_CT].	IsYesNo, [cdc].[UI_RadioButtonUIElement_CT].	OptionLabelNo, 
		[cdc].[UI_RadioButtonUIElement_CT].	MigrationID, [cdc].[UI_RadioButtonUIElement_CT].	IsMigrated, 
		[cdc].[UI_RadioButtonUIElement_CT].IsMigrationOverriden, [cdc].[UI_RadioButtonUIElement_CT].	MigrationDate,
		4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RadioButtonUIElement_CT] Where __$operation = 1

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Radiobutton element '+ ui.Label +' is deleted',ui.AddedBy , ui.AddedDate , 
		ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_RadioButtonUIElement_CT] d JOIN UI.UIElement ui ON ui.UIElementID=d.UIElementID 
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
	END 
	
	ELSE IF @operation = 2 ----- For Insert
	BEGIN	 
		INSERT INTO [Trgr].[RadioButtonUIElement]
		(		UIElementID,			UIElementTypeID,			OptionLabel,			DefaultValue,			IsYesNo,			OptionLabelNo,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_RadioButtonUIElement_CT].	UIElementID, [cdc].[UI_RadioButtonUIElement_CT].	UIElementTypeID,
		[cdc].[UI_RadioButtonUIElement_CT].	OptionLabel, [cdc].[UI_RadioButtonUIElement_CT].	DefaultValue, 
		[cdc].[UI_RadioButtonUIElement_CT].	IsYesNo, [cdc].[UI_RadioButtonUIElement_CT].	OptionLabelNo,
		[cdc].[UI_RadioButtonUIElement_CT].MigrationID, [cdc].[UI_RadioButtonUIElement_CT].	IsMigrated,
		[cdc].[UI_RadioButtonUIElement_CT].	IsMigrationOverriden, [cdc].[UI_RadioButtonUIElement_CT].	MigrationDate,
		1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RadioButtonUIElement_CT] Where __$operation = 2

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(i.UIElementID,0),'Radiobutton element '+ ui.Label +' is added',ui.AddedBy , GETDATE(), ui.AddedBy , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_RadioButtonUIElement_CT] i LEFT JOIN UI.UIElement ui ON ui.UIElementID=i.UIElementID
		LEFT JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID ;

		TRUNCATE TABLE dbo.ActivityLogForRM;
			    INSERT INTO dbo.ActivityLogForRM VALUES (@@identity, NULL);
	END;

	ELSE If @Operation = 3
	BEGIN
		INSERT INTO [Trgr].[RadioButtonUIElement]
		(		UIElementID,			UIElementTypeID,			OptionLabel,			DefaultValue,			IsYesNo,			OptionLabelNo,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_RadioButtonUIElement_CT].UIElementID, [cdc].[UI_RadioButtonUIElement_CT].	UIElementTypeID,
		[cdc].[UI_RadioButtonUIElement_CT].	OptionLabel, [cdc].[UI_RadioButtonUIElement_CT].	DefaultValue,
		[cdc].[UI_RadioButtonUIElement_CT].	IsYesNo, [cdc].[UI_RadioButtonUIElement_CT].	OptionLabelNo,
		[cdc].[UI_RadioButtonUIElement_CT].	MigrationID, [cdc].[UI_RadioButtonUIElement_CT].	IsMigrated, 
		[cdc].[UI_RadioButtonUIElement_CT].IsMigrationOverriden, [cdc].[UI_RadioButtonUIElement_CT].	MigrationDate,
		2 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RadioButtonUIElement_CT] WHERE  __$Operation = 3

		INSERT INTO [Trgr].[RadioButtonUIElement]
		(		UIElementID,			UIElementTypeID,			OptionLabel,			DefaultValue,			IsYesNo,			OptionLabelNo,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
		SELECT  [cdc].[UI_RadioButtonUIElement_CT].UIElementID, [cdc].[UI_RadioButtonUIElement_CT].	UIElementTypeID,
		[cdc].[UI_RadioButtonUIElement_CT].	OptionLabel, [cdc].[UI_RadioButtonUIElement_CT].	DefaultValue,
		[cdc].[UI_RadioButtonUIElement_CT].	IsYesNo, [cdc].[UI_RadioButtonUIElement_CT].	OptionLabelNo,
		[cdc].[UI_RadioButtonUIElement_CT].	MigrationID, [cdc].[UI_RadioButtonUIElement_CT].	IsMigrated, 
		[cdc].[UI_RadioButtonUIElement_CT].IsMigrationOverriden, [cdc].[UI_RadioButtonUIElement_CT].	MigrationDate,
		3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_RadioButtonUIElement_CT] WHERE __$operation = 4

		SELECT @dOptionLabel =ISNULL(OptionLabel,''),@dDefValue =ISNULL(CAST(DefaultValue AS VARCHAR(MAX)),'None'),@dIsYesNo =ISNULL(IsYesNo,0),@dOptionLabelNo =ISNULL(OptionLabelNo,'')  from [cdc].[UI_RadioButtonUIElement_CT]
		SELECT @iOptionLabel =ISNULL(OptionLabel,''),@iDefValue =ISNULL(CAST(DefaultValue AS VARCHAR(MAX)),'None'),@iIsYesNo =ISNULL(IsYesNo,0),@iOptionLabelNo =ISNULL(OptionLabelNo,'')  from [cdc].[UI_RadioButtonUIElement_CT]

		If (@dOptionLabel<>@iOptionLabel)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Option label for Radiobutton element '+ ui.Label +' is changed from '+ ISNULL(d.OptionLabel,'None')  + ' to '+ ISNULL(i.OptionLabel,'None')  ,
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_RadioButtonUIElement_CT] d inner join [cdc].[UI_RadioButtonUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
		END;

		If (@dDefValue<>@iDefValue)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Default value for Radiobutton element '+ ui.Label +' is changed from '+ CAST((CASE @dDefValue WHEN '0' THEN 'No' WHEN '1' THEN 'Yes' ELSE 'None' END) AS varchar(MAX))  + ' to '+ CAST((CASE @iDefValue WHEN '0' THEN 'No' WHEN '1' THEN 'Yes' ELSE 'None' END) AS varchar(MAX))  ,		
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_RadioButtonUIElement_CT] d inner join [cdc].[UI_RadioButtonUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
		END;

		If (@dIsYesNo<>@iIsYesNo)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Yes/No default for Radiobutton element '+ ui.Label +' is changed from '+ CAST((CASE ISNULL(d.IsYesNo,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX))  + ' to '+ CAST((CASE ISNULL(i.IsYesNo,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS varchar(MAX))  ,	
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_RadioButtonUIElement_CT] d inner join [cdc].[UI_RadioButtonUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
		END;

		IF (@dOptionLabelNo<>@iOptionLabelNo)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Option label No for Radiobutton element '+ ui.Label +' is changed from '+ ISNULL(d.OptionLabelNo,'None')  + ' to '+ ISNULL(i.OptionLabelNo,'None')  ,
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_RadioButtonUIElement_CT] d inner join [cdc].[UI_RadioButtonUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
		END;
	END
END
