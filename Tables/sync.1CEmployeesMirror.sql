CREATE TABLE [sync].[1CEmployeesMirror] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [VisibleCode] [varchar](30) NULL,
  [Code1C] [varchar](36) NOT NULL,
  [Name] [varchar](100) NULL,
  [OperationType] [tinyint] NOT NULL,
  [isActive] [bit] NULL,
  [ContractType] [varchar](50) NULL,
  [FCode1C] [varchar](36) NULL,
  [ModifyName] [varchar](100) NULL,
  [ModifyDate] [datetime] NULL,
  [Department1Code1C] [varchar](36) NULL,
  [Department1Name] [varchar](150) NULL,
  [Position1Code1C] [varchar](36) NULL,
  [Department2Code1C] [varchar](36) NULL,
  [Department2Name] [varchar](150) NULL,
  [Position2Code1C] [varchar](36) NULL,
  [RecDate2] [datetime] NULL,
  [DisDate2] [datetime] NULL,
  [Department3Code1C] [varchar](36) NULL,
  [Position3Code1C] [varchar](36) NULL,
  [RecDate3] [datetime] NULL,
  [DisDate3] [datetime] NULL,
  [WorkType] [varchar](51) NULL,
  CONSTRAINT [PK_1CEmployeesMirror_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO