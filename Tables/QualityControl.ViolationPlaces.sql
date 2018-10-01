CREATE TABLE [QualityControl].[ViolationPlaces] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](50) NULL,
  CONSTRAINT [PK_ViolationPlaces_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ViolationPlaces', 'COLUMN', N'ID'
GO