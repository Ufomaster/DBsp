SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   14.02.2013$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   26.06.2014$*/
/*$Version:    1.00$   $Description: Создаем группирующую таблицу для этапа$*/
CREATE PROCEDURE [manufacture].[sp_pTMC_CreateGroupTable]
  @JobStageID int,
  @ColumnCount tinyint
AS
BEGIN	
	SET NOCOUNT ON;
	/*Check table for exist*/
    DECLARE @TableName varchar(50)
            , @Table varchar(4000)
            , @Index varchar(4000)            
            , @ColumnName varchar(10)
            , @i tinyint   
    
	/*Create main table*/
    SET @TableName = 'G_' + Convert(varchar(30), @JobStageID)
    IF NOT EXISTS(
          select * from information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'StorageData'
                AND t.TABLE_NAME = @TableName)
    BEGIN
    
        SET @i = 1
        SET @Index = ''
        SET @Table = '
              CREATE TABLE [StorageData].['+@TableName+'] (
              [ID] int IDENTITY(1, 1) NOT NULL,
              [OperationID] int NULL,
              '
        WHILE @i <= @ColumnCount
        BEGIN    	
            SET @ColumnName = 'Column_' + Convert(varchar(3),@i)
            SET @Table = @Table + @ColumnName + ' int NULL,'
            
            SET @Index = @Index + '
                   CREATE NONCLUSTERED INDEX [IDX_'+@TableName+'_'+@ColumnName+'] ON [StorageData].['+@TableName+']
                      (['+@ColumnName+'])
                    WITH (
                      PAD_INDEX = OFF,
                      DROP_EXISTING = OFF,
                      STATISTICS_NORECOMPUTE = OFF,
                      SORT_IN_TEMPDB = OFF,
                      ONLINE = OFF,
                      ALLOW_ROW_LOCKS = ON,
                      ALLOW_PAGE_LOCKS = ON)'
                    
            SET @i = @i + 1
        END
    
        SET @Table = @Table + '
              CONSTRAINT [PK_'+@TableName+'_ID] PRIMARY KEY CLUSTERED ([ID]),
              CONSTRAINT [FK_'+@TableName+'_Operations_ID] FOREIGN KEY ([OperationID]) 
              REFERENCES [manufacture].[PTmcOperations] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION)
              
              ' + @Index

        EXEC (@Table)      
    END;
END;
GO