CREATE TABLE [dbo].[ProductionCardCustomizeAssemblyInstructions] (
  [ID] [int] IDENTITY,
  [AssemblyInstructionHeaderID] [int] NOT NULL,
  [Data] [varbinary](max) NULL,
  [ModifyDate] [datetime] NOT NULL,
  [ModifyEmployeeID] [int] NOT NULL,
  [ProductionCustomizeID] [int] NOT NULL,
  CONSTRAINT [PK_ProductionCardCustomizeAssemblyInstructions_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeAssemblyInstructions_AssemblyInstructionHeaderID_ProductionCustomizeID]
  ON [dbo].[ProductionCardCustomizeAssemblyInstructions] ([AssemblyInstructionHeaderID], [ProductionCustomizeID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ProductionCardCustomizeAssemblyInstructions.ModifyDate'
GO

ALTER TABLE [dbo].[ProductionCardCustomizeAssemblyInstructions]
  ADD CONSTRAINT [FK_AssemblyInstructionsDetails_AssemblyInstructionHeaders_ID] FOREIGN KEY ([AssemblyInstructionHeaderID]) REFERENCES [dbo].[ProductionCardInstructionHeaders] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeAssemblyInstructions]
  ADD CONSTRAINT [FK_AssemblyInstructionsDetails_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAssemblyInstructions', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Раздел', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAssemblyInstructions', 'COLUMN', N'AssemblyInstructionHeaderID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Данные в ртф формате', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAssemblyInstructions', 'COLUMN', N'Data'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата модицикации', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAssemblyInstructions', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сотрудник, модифицировавший запись', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAssemblyInstructions', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAssemblyInstructions', 'COLUMN', N'ProductionCustomizeID'
GO