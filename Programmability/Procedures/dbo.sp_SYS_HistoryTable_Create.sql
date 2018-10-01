SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   23.12.2016$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   23.12.2016$*/
/*$Version:    1.00$   $Description: Создание таблицы истории и триггеров на изменения для указанной таблицы*/
create PROCEDURE [dbo].[sp_SYS_HistoryTable_Create]
    @Scheme varchar(255),
    @TableName varchar(255)
as            
BEGIN
    SET NOCOUNT ON

    DECLARE @FullTableName varchar(510), @TableNameHistory varchar(255), @FullTableHistoryName varchar(510),  @ColumnsList varchar(8000),  @SelectList varchar(8000), @Query varchar(8000)

    SET @TableNameHistory = @TableName + 'History'
    SET @FullTableHistoryName = '[' + @Scheme + '].[' + @TableNameHistory + ']'
    SET @FullTableName = '[' + @Scheme + '].[' + @TableName + ']'    

    IF EXISTS(
          select * from information_schema.tables t
          WHERE t.TABLE_SCHEMA = @Scheme
                AND t.TABLE_NAME = @TableNameHistory)
    BEGIN
        EXEC(' DROP TABLE ' + @FullTableHistoryName)
    END

    SELECT @ColumnsList = IsNull(@ColumnsList,'') + char(10) + '  [' + COLUMN_NAME + '] ' + DATA_TYPE 
           + CASE WHEN CHARACTER_MAXIMUM_LENGTH is null THEN '' ELSE '(' + CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN 'MAX' ELSE convert(varchar(10),CHARACTER_MAXIMUM_LENGTH) END + ')' END
           + CASE WHEN lower(IS_NULLABLE)='yes' THEN ' NULL' ELSE ' NOT NULL' END + ','
           , @SelectList  = IsNull(@SelectList + ', ','') + '[' + COLUMN_NAME + ']'
    FROM information_schema.columns 
    WHERE TABLE_NAME = @TableName        
    
    SELECT @Query =
          'CREATE TABLE ' + @FullTableHistoryName + ' (' +
            @ColumnsList + '
          	[HistoryID] int IDENTITY(1, 1) NOT NULL,
		    [HistoryModifyDate] datetime NOT NULL,
		    [HistoryUserSID] varbinary(85) NOT NULL,
            [HistoryModifyEmployeeID] int NULL,
		    [HistoryIP] varchar(15) NOT NULL,
		    [HistoryCompName] varchar(100) NOT NULL,
            [HistoryOperationID] tinyint NOT NULL,   
            [HistoryMacAddress] nchar(12) DEFAULT [dbo].[fn_MacAddress]() NULL,
            CONSTRAINT [PK_' + @TableNameHistory + '_ID] PRIMARY KEY ([HistoryID])
           ) 
           
           EXEC sp_bindefault N''[dbo].[DF_CurrentDate]'', N''' + @FullTableHistoryName + '.[HistoryModifyDate]''
           EXEC sp_bindefault N''[dbo].[DF_SID]'', N''' + @FullTableHistoryName + '.[HistoryUserSID]''
           EXEC sp_bindefault N''[dbo].[DF_IP]'', N''' + @FullTableHistoryName + '.[HistoryIP]''
           EXEC sp_bindefault N''[dbo].[DF_CompName]'', N''' + @FullTableHistoryName + '.[HistoryCompName]''                                 
		   
           IF OBJECT_ID (''TR_' + @TableName + '_insert'', ''TR'') IS NOT NULL
           DROP TRIGGER TR_' + @TableName + '_insert
		             
           IF OBJECT_ID (''TR_' + @TableName + '_update'', ''TR'') IS NOT NULL
           DROP TRIGGER TR_' + @TableName + '_update
                   
           IF OBJECT_ID (''TR_' + @TableName + '_delete'', ''TR'') IS NOT NULL
           DROP TRIGGER TR_' + @TableName + '_delete           '
    EXEC(@Query)  
                   
    SELECT @Query =      
          'CREATE TRIGGER TR_' + @TableName + '_insert
           on ' + @FullTableName + '
           FOR insert
           as
           BEGIN
           	    DECLARE @EmployeeID int = null
                IF OBJECT_ID(''tempdb..#CurrentUser'') IS NOT NULL SELECT @EmployeeID = a.EmployeeID FROM #CurrentUser a
                INSERT INTO ' + @FullTableHistoryName + ' (' + @SelectList + ', [HistoryOperationID], [HistoryModifyEmployeeID])
                SELECT ' + @SelectList + ', 0, @EmployeeID
                FROM inserted
           END '           
    EXEC(@Query)
     
    SELECT @Query =           
          'CREATE TRIGGER TR_' + @TableName + '_update
           on ' + @FullTableName + '
           FOR UPDATE
           as
           BEGIN
           	    DECLARE @EmployeeID int = null
                IF OBJECT_ID(''tempdb..#CurrentUser'') IS NOT NULL SELECT @EmployeeID = a.EmployeeID FROM #CurrentUser a           
                INSERT INTO ' + @FullTableHistoryName + ' (' + @SelectList + ', [HistoryOperationID], [HistoryModifyEmployeeID])
                SELECT ' + @SelectList + ', 1, @EmployeeID
                FROM inserted
           END  '
    EXEC(@Query)           
    
    SELECT @Query =           
          'CREATE TRIGGER TR_' + @TableName + '_delete
           on ' + @FullTableName + '
           FOR DELETE
           as
           BEGIN
           	    DECLARE @EmployeeID int = null
                IF OBJECT_ID(''tempdb..#CurrentUser'') IS NOT NULL SELECT @EmployeeID = a.EmployeeID FROM #CurrentUser a           
                INSERT INTO ' + @FullTableHistoryName + ' (' + @SelectList + ', [HistoryOperationID], [HistoryModifyEmployeeID])
                SELECT ' + @SelectList + ', 2, @EmployeeID
                FROM deleted
           END  '                                    
    EXEC(@Query)         
    
END
GO