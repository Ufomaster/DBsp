CREATE TABLE [dbo].[Calendar] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [isWeekend] [bit] NOT NULL,
  CONSTRAINT [PK_Calendar_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO