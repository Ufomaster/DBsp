CREATE TABLE [dbo].[TechOperationsClasses] (
  [ID] [smallint] IDENTITY,
  [Name] [varchar](255) NULL,
  [TOID] [int] NULL,
  CONSTRAINT [PK_TechOperationsClasses_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_TechOperationsClasses_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TechOperationsClasses]
  ADD CONSTRAINT [FK_TechOperationsClasses_TechnologicalOperations_ID] FOREIGN KEY ([TOID]) REFERENCES [manufacture].[TechnologicalOperations] ([ID])
GO