CREATE TABLE [dbo].[ObjectTypesAttributes] (
  [ID] [int] IDENTITY,
  [ObjectTypeID] [int] NOT NULL,
  [AttributeID] [int] NOT NULL,
  CONSTRAINT [PK_ObjectTypesAttributes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_ObjectTypesAttributes_ObjectTypeID_AttributeID]
  ON [dbo].[ObjectTypesAttributes] ([ObjectTypeID], [AttributeID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ObjectTypesAttributes]
  ADD CONSTRAINT [FK_ObjectTypesAttributes_Attributes_ID] FOREIGN KEY ([AttributeID]) REFERENCES [dbo].[Attributes] ([ID])
GO

ALTER TABLE [dbo].[ObjectTypesAttributes]
  ADD CONSTRAINT [FK_ObjectTypesAttributes_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesAttributes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор тип объекта', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesAttributes', 'COLUMN', N'ObjectTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор аттрибута', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesAttributes', 'COLUMN', N'AttributeID'
GO