CREATE TABLE [shifts].[Data1CCache] (
  [DateT] [datetime] NULL,
  [INN] [varchar](50) NULL,
  [TimeT] [int] NULL,
  [TypeT] [varchar](3) NULL,
  [PCCNumber__] [varchar](20) NULL,
  [SumTime__] [int] NULL,
  [SumAmount__] [decimal](38, 4) NULL,
  [TOCode1C] [varchar](36) NULL,
  [TechnologicalOperationID] [int] NULL
)
ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IDX_Data1CCache_DateT_INN_PCCNumber__]
  ON [shifts].[Data1CCache] ([DateT], [INN], [PCCNumber__])
  ON [PRIMARY]
GO