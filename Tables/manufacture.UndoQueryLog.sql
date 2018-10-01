CREATE TABLE [manufacture].[UndoQueryLog] (
  [ID] [int] IDENTITY,
  [Q] [varchar](max) NULL,
  [StorageStructureID] [smallint] NULL,
  [ExecDate] [datetime] NULL,
  [JobStageID] [int] NULL,
  CONSTRAINT [PK_UndoQueryLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO