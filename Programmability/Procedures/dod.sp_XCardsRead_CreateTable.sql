SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   07.09.2018$
--$Modify:     Poliatykin Oleksii$    $Modify date:   07.09.2018$
--$Version:    1.00$   $Decription: Создаем таблицу  XCardsData_XRead для считываемых значений $

CREATE PROCEDURE [dod].[sp_XCardsRead_CreateTable]
  @JobsSettingsID int
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TableName varchar(50)
           , @TableNameRead varchar(50)
  SET @TableName = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)
  SET @TableNameRead = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)+'Read'
  
  
    IF NOT EXISTS(
          select * from information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'dod'
                AND t.TABLE_NAME = @TableNameRead)
   BEGIN
  EXEC ('
              CREATE TABLE [dod].['+@TableNameRead+'] (
              [ID] int IDENTITY(1, 1) NOT NULL,
              [XCardsDataID] int NULL,
              [Sector] int NULL,
              [Block0] varchar(32) NULL,
              [Block1] varchar(32) NULL,
              [Block2] varchar(32) NULL,
              [Block3] varchar(32) NULL,
              [Block4] varchar(32) NULL,
              [Block5] varchar(32) NULL,
              [Block6] varchar(32) NULL,
              [Block7] varchar(32) NULL,
              [Block8] varchar(32) NULL,
              [Block9] varchar(32) NULL,
              [Block10] varchar(32) NULL,
              [Block11] varchar(32) NULL,
              [Block12] varchar(32) NULL,
              [Block13] varchar(32) NULL,
              [Block14] varchar(32) NULL,
              [Block15] varchar(32) NULL,
              
              CONSTRAINT [PK_'+@TableNameRead+'_ID] PRIMARY KEY CLUSTERED ([ID]),
              CONSTRAINT [FK_'+@TableNameRead+'_XCardsData_ID] FOREIGN KEY ([XCardsDataID]) 
              REFERENCES [dod].['+@TableName+'] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION )              

              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameRead+'Sector] ON [dod].['+@TableNameRead+']
                ([Sector])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)   
                
              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameRead+'XCardsDataID] ON [dod].['+@TableNameRead+']
                ([XCardsDataID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)                                       
            ')
   
   END 
  
END
GO