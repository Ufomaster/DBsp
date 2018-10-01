SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   10.03.2015$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   10.03.2015$*/
/*$Version:    1.00$   $Description: Генерация хранимых процедур на Инсерт*/
create PROCEDURE [dbo].[sp_SYS_GenerateProcedureForInsert]
  @Scheme varchar(255), @TableName varchar(255), @ProcedureName varchar(255), @RightName varchar(50), @WarinngMsg varchar(500)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE  @ColumnsList varchar(8000), @VariablesDeclareList varchar(8000), @SelectList varchar(8000)
             , @CurDate varchar(10), @VariablesList varchar(8000), @Query varchar(8000), @ExecList varchar(8000), @ParamList varchar(8000), @ParamNameList varchar(8000)
             
    SELECT @VariablesDeclareList =     	   
               IsNull(@VariablesDeclareList + ',','') + char(10) + '  @' + COLUMN_NAME + ' ' + DATA_TYPE 
               + CASE WHEN CHARACTER_MAXIMUM_LENGTH is null THEN '' ELSE '(' + CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN 'MAX' ELSE convert(varchar(10),CHARACTER_MAXIMUM_LENGTH) END + ')' END               
           , @VariablesList = IsNull(@VariablesList + ',','') + ' @' + COLUMN_NAME               
           , @SelectList  =  IsNull(@SelectList + ', ','') + '[' + COLUMN_NAME + ']'
           , @ExecList  =  IsNull(@ExecList + ', ','') + ':' + COLUMN_NAME 
           , @ParamList  =  IsNull(@ParamList + ', ','') + '''' + COLUMN_NAME + ''''
           , @ParamNameList  =  IsNull(@ParamNameList + ', ','') + 'FBN[''' + COLUMN_NAME + ''']'
    FROM information_schema.columns 
    WHERE TABLE_NAME = @TableName   
          AND UPPER(COLUMN_NAME) <> 'ID'
    
    SELECT @CurDate = CONVERT(varchar(10), GETDATE(), 104)
    
    SELECT @Query = 
'SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*$Create:     Zapadinskiy Anatoliy$	$Create date:   ' + @CurDate + '$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   ' + @CurDate + '$*/
/*$Version:    1.00$   $Description: Добавление ' + @TableName + '*/
CREATE PROCEDURE ' + @ProcedureName + @VariablesDeclareList

    SELECT @Query = @Query +
'
AS  
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON    
    DECLARE @ID integer, @UserRightID smallint, @Err Int
    DECLARE @T TABLE(ID Int)
    
    BEGIN TRAN
    BEGIN TRY    
    
        /*Check rights*/
        SELECT @UserRightID = ur.ID FROM UserRights ur WHERE ur.DelphiConst = ''' + @RightName + '''
        CREATE TABLE #sp_rights (RightValue tinyint, UserRightID smallint)    
        INSERT #sp_rights EXEC sp_RoleRights_Select @UserRightID
        
        IF (SELECT top 1 RightValue FROM #sp_rights) <> 3 OR not EXISTS(SELECT * FROM #sp_rights)
           RAISERROR ('''+ @WarinngMsg +''', 16, 1)    
        ELSE
        BEGIN 
			INSERT INTO ' + @Scheme + '.' + @TableName + ' (' + @SelectList + ')
            OUTPUT INSERTED.ID INTO @T                                
            SELECT ' + @VariablesList + '

            SELECT TOP 1 @ID = ID FROM @T
        END    
                
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
        SET @ID = -1
    END CATCH 
    
    DROP TABLE #sp_rights
    
    SELECT @ID       
END'

	SELECT @Query
    
    SELECT REPLICATE(' ', 8) + 'str := ''EXEC ' + @ProcedureName + ' ' + @ExecList + ''';' + '
' + REPLICATE(' ', 7) + ' ID := FastGetSQLValue(str,0,[' + @ParamList +'], 
' + REPLICATE(' ', 36) + '[' + @ParamNameList  +'], 
' + REPLICATE(' ', 36) + 'ADODataset.Connection);'

END
GO