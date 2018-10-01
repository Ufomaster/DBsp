CREATE TABLE [manufacture].[StressTestSettings] (
  [ID] [int] IDENTITY,
  [StartFrom] [int] NULL,
  [Step] [int] NULL,
  [Prefix] [char](3) NULL,
  [Size] [int] NULL DEFAULT (1),
  CONSTRAINT [PK_StressTestSettings_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create TRIGGER [TR_StressTestSettings__iu] ON [manufacture].[StressTestSettings]

FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON
    UPDATE StressTestSettings
    SET Prefix = REPLACE(Prefix, ' ', '_')
    WHERE ID = (SELECT ID FROM INSERTED)
END
GO