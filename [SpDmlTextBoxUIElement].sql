USE [eBS4_INT_QA2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Name:
    [UI].[SpDmlTextBoxUIElement]

Purpose:
    To maintain records for DML operation performed on table [UI].[TextBoxUIElement] using CDC Table

Assumption:
    There must be single DML operation on table at a time
	There must be single row in CDC table 

   History:
    Created on  30/09/2022 by Shivani Shinde 
    Modified on ---------
*/

CREATE OR ALTER PROCEDURE [UI].[SpDmlTextBoxUIElement]
AS
BEGIN
 SET NOCOUNT ON;

    --Local Variables Declaration
	declare @Operation int, @iMaxlength	int, @inserted	int,  @deleted	int, @iIsMultiline bit, @dIsMultiline bit, @iDefValue VARCHAR(4000), @dDefValue VARCHAR(4000),
    @dMaxlength int, @iIsLabel bit, @dIsLabel bit, @iUIElementTypeId int, @dUIElementTypeId int

	--Check if current record is inserted, updated or deleted
	SET @Operation = (SELECT TOP 1 __$Operation FROM [cdc].[UI_TextBoxUIElement_CT])

	IF @Operation = 1 -- For deleted records
	BEGIN
		INSERT INTO [Trgr].[TextBoxUIElement]
		(		UIElementID,			UIElementTypeID,			IsMultiline,			DefaultValue,			[MaxLength],			IsLabel,			SpellCheck,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_TextBoxUIElement_CT].	UIElementID, [cdc].[UI_TextBoxUIElement_CT].	UIElementTypeID,
		[cdc].[UI_TextBoxUIElement_CT].	IsMultiline, [cdc].[UI_TextBoxUIElement_CT].	DefaultValue, 
		[cdc].[UI_TextBoxUIElement_CT].	[MaxLength], [cdc].[UI_TextBoxUIElement_CT].	IsLabel,
		[cdc].[UI_TextBoxUIElement_CT].	SpellCheck, [cdc].[UI_TextBoxUIElement_CT].MigrationID,
		[cdc].[UI_TextBoxUIElement_CT].	IsMigrated, [cdc].[UI_TextBoxUIElement_CT].IsMigrationOverriden,
		[cdc].[UI_TextBoxUIElement_CT].	MigrationDate,  4 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TextBoxUIElement_CT] WHERE __$Operation = 1

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),'Textbox element '+ ui.Label +' is deleted',ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0) FROM [cdc].[UI_TextBoxUIElement_CT] d JOIN UI.UIElement ui ON ui.UIElementID=d.UIElementID
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 
	END

	ELSE IF @operation = 2 ----- For Inserted records
	BEGIN	 
		INSERT INTO [Trgr].[TextBoxUIElement]
		(	UIElementID,			UIElementTypeID,			IsMultiline,			DefaultValue,			[MaxLength],			IsLabel,			SpellCheck,				MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_TextBoxUIElement_CT].UIElementID, [cdc].[UI_TextBoxUIElement_CT].	UIElementTypeID, 
		[cdc].[UI_TextBoxUIElement_CT].	IsMultiline, [cdc].[UI_TextBoxUIElement_CT].	DefaultValue,
		[cdc].[UI_TextBoxUIElement_CT].	[MaxLength], [cdc].[UI_TextBoxUIElement_CT].	IsLabel,
		[cdc].[UI_TextBoxUIElement_CT].	SpellCheck, [cdc].[UI_TextBoxUIElement_CT].	MigrationID, 
		[cdc].[UI_TextBoxUIElement_CT].	IsMigrated, [cdc].[UI_TextBoxUIElement_CT].	IsMigrationOverriden, 
		[cdc].[UI_TextBoxUIElement_CT].	MigrationDate,  1 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TextBoxUIElement_CT] WHERE __$Operation = 2

		INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
		[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
		SELECT ISNULL(ui.FormID,0),ISNULL(i.UIElementID,0),'Textbox element '+ ui.Label +' is added',ui.AddedBy , GETDATE(), ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE()
		, ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
		FROM [cdc].[UI_TextBoxUIElement_CT] i LEFT JOIN UI.UIElement ui ON ui.UIElementID=i.UIElementID LEFT JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;

		TRUNCATE TABLE dbo.ActivityLogForRM;
		INSERT INTO dbo.ActivityLogForRM VALUES (@@identity, NULL);
	END;

	ELSE IF  @Operation = 3 --For Updated records
	BEGIN
		INSERT INTO [Trgr].[TextBoxUIElement]
		(	UIElementID,			UIElementTypeID,			IsMultiline,			DefaultValue,			[MaxLength],			IsLabel,			SpellCheck,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,			DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_TextBoxUIElement_CT].	UIElementID, [cdc].[UI_TextBoxUIElement_CT].	UIElementTypeID,
		[cdc].[UI_TextBoxUIElement_CT].	IsMultiline, [cdc].[UI_TextBoxUIElement_CT].	DefaultValue, 
		[cdc].[UI_TextBoxUIElement_CT].	[MaxLength], [cdc].[UI_TextBoxUIElement_CT].	IsLabel,
		[cdc].[UI_TextBoxUIElement_CT].	SpellCheck, [cdc].[UI_TextBoxUIElement_CT].MigrationID, 
		[cdc].[UI_TextBoxUIElement_CT].	IsMigrated, [cdc].[UI_TextBoxUIElement_CT].IsMigrationOverriden,
		[cdc].[UI_TextBoxUIElement_CT].	MigrationDate,  2 as	DMLOperation, getdate() as	OperationDate
		from [cdc].[UI_TextBoxUIElement_CT] WHERE __$Operation = 3;

		INSERT INTO [Trgr].[TextBoxUIElement]
		(	UIElementID,			UIElementTypeID,			IsMultiline,			DefaultValue,			[MaxLength],			IsLabel,			SpellCheck,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,			DMLOperation,				OperationDate	)
		SELECT [cdc].[UI_TextBoxUIElement_CT].	UIElementID, [cdc].[UI_TextBoxUIElement_CT].	UIElementTypeID,
		[cdc].[UI_TextBoxUIElement_CT].	IsMultiline, [cdc].[UI_TextBoxUIElement_CT].	DefaultValue, 
		[cdc].[UI_TextBoxUIElement_CT].	[MaxLength], [cdc].[UI_TextBoxUIElement_CT].	IsLabel,
		[cdc].[UI_TextBoxUIElement_CT].	SpellCheck, [cdc].[UI_TextBoxUIElement_CT].MigrationID, 
		[cdc].[UI_TextBoxUIElement_CT].	IsMigrated, [cdc].[UI_TextBoxUIElement_CT].IsMigrationOverriden,
		[cdc].[UI_TextBoxUIElement_CT].	MigrationDate,  3 as	DMLOperation, getdate() as	OperationDate
		FROM [cdc].[UI_TextBoxUIElement_CT] WHERE __$Operation = 4;

		SELECT @dIsMultiline =ISNULL(IsMultiline,0), @dIsLabel =ISNULL(IsLabel,0), @dDefValue =ISNULL(DefaultValue,''),
		@dMaxlength =ISNULL([MaxLength],0), @dUIElementTypeId =ISNULL(UIElementTypeID,0)  FROM [cdc].[UI_TextBoxUIElement_CT];

		SELECT @iIsMultiline =ISNULL(IsMultiline,0), @iIsLabel =ISNULL(IsLabel,0), @iDefValue =ISNULL(DefaultValue,''),
		@iMaxlength =ISNULL([MaxLength],0),@iUIElementTypeId =ISNULL(UIElementTypeID,0)  FROM [cdc].[UI_TextBoxUIElement_CT]

		IF (@dUIElementTypeId<>@iUIElementTypeId)
		BEGIN			   
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId] )
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),			
			CASE WHEN (@dUIElementTypeId = 13 and @iUIElementTypeId = 4) THEN 'Rich Textbox element '+ ui.Label +' is changed to Multiline TextBox'
			WHEN (@dUIElementTypeId = 13 and @iUIElementTypeId = 3) THEN 'Rich Textbox element '+ ui.Label +' is changed to TextBox'
			WHEN (@dUIElementTypeId = 4 and @iUIElementTypeId = 13) THEN 'Multiline Textbox element '+ ui.Label +' is changed to Rich TextBox'
			WHEN (@dUIElementTypeId = 3 and @iUIElementTypeId = 13) THEN 'Textbox element '+ ui.Label +' is changed to Rich TextBox'
			WHEN (@dUIElementTypeId = 3 and @iUIElementTypeId = 4) THEN 'Textbox element '+ ui.Label +' is changed to Multiline TextBox'
			WHEN (@dUIElementTypeId = 4 and @iUIElementTypeId = 3) THEN 'Multiline TextBox element '+ ui.Label +' is changed to TextBox'
			WHEN (@dUIElementTypeId = 10 and @iUIElementTypeId = 3) THEN 'Label element '+ ui.Label +' is changed to TextBox'
			WHEN (@dUIElementTypeId = 10 and @iUIElementTypeId = 4) THEN 'Label element '+ ui.Label +' is changed to Multiline TextBox'
			WHEN (@dUIElementTypeId = 10 and @iUIElementTypeId = 13) THEN 'Label element '+ ui.Label +' is changed to Rich TextBox'
			WHEN (@dUIElementTypeId = 3 and @iUIElementTypeId = 10) THEN 'TextBox element '+ ui.Label +' is changed to Label'
			WHEN (@dUIElementTypeId = 4 and @iUIElementTypeId = 10) THEN 'Multiline TextBox element '+ ui.Label +' is changed to Label'
			WHEN (@dUIElementTypeId = 13 and @iUIElementTypeId = 10) THEN 'Rich Textbox element '+ ui.Label +' is changed to Label'
		END,			
		ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)			 
		FROM [cdc].[UI_TextBoxUIElement_CT] d inner join [cdc].[UI_TextBoxUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID
		JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID;   						    

				TRUNCATE TABLE dbo.ActivityLogForRM;
			INSERT INTO dbo.ActivityLogForRM VALUES (@@identity, NULL);
					 
	END;
												
		IF (@dDefValue<>@iDefValue)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Default value for Textbox element '+ ui.Label +' is changed from '+ ISNULL(d.DefaultValue,'None')  + ' to '+ ISNULL(i.DefaultValue,'None')   ,		
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
			FROM [cdc].[UI_TextBoxUIElement_CT] d inner join [cdc].[UI_TextBoxUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 

			TRUNCATE TABLE dbo.ActivityLogForRM;
			INSERT INTO dbo.ActivityLogForRM VALUES (@@identity, NULL);
		END;

		IF (@dMaxlength<>@iMaxlength)
		BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
			'Maxlength for Textbox element '+ ui.Label +' is changed from '+ CAST(ISNULL(d.[MaxLength],0) AS VARCHAR(MAX))  + ' to '+ CAST(ISNULL(i.[MaxLength],0) AS VARCHAR(MAX))  ,	
			ui.AddedBy , ui.AddedDate , ISNULL(ui.UpdatedBy, ui.AddedBy) , GETDATE(), ui.UIElementName, ui.Label	, ISNULL(fdvui.FormDesignVersionID,0)		 
			FROM [cdc].[UI_TextBoxUIElement_CT] d inner join [cdc].[UI_TextBoxUIElement_CT] i ON d.UIElementID=i.UIElementID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID; 

			TRUNCATE TABLE dbo.ActivityLogForRM;
			INSERT INTO dbo.ActivityLogForRM VALUES (@@identity, NULL);
		END;

	END

END
