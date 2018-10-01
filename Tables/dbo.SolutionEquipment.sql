CREATE TABLE [dbo].[SolutionEquipment] (
  [ID] [int] IDENTITY,
  [SolutionID] [int] NOT NULL,
  [EquipmentID] [int] NOT NULL,
  CONSTRAINT [PK_SolutionEquipment_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SolutionEquipment]
  ADD CONSTRAINT [FK_SolutionEquipment_EquipmentID_ID] FOREIGN KEY ([EquipmentID]) REFERENCES [dbo].[Equipment] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SolutionEquipment]
  ADD CONSTRAINT [FK_SolutionEquipment_Solutions_ID] FOREIGN KEY ([SolutionID]) REFERENCES [dbo].[Solutions] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionEquipment', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionEquipment', 'COLUMN', N'SolutionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор оборудования', 'SCHEMA', N'dbo', 'TABLE', N'SolutionEquipment', 'COLUMN', N'EquipmentID'
GO