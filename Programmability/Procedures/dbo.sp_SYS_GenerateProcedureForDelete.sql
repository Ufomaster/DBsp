SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   10.03.2015$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   10.03.2015$*/
/*$Version:    1.00$   $Description: Генерация хранимых процедур на Удаление*/
create PROCEDURE [dbo].[sp_SYS_GenerateProcedureForDelete]
  @Scheme varchar(255), @TableName varchar(255), @ProcedureName varchar(255), @RightName varchar(50), @WarinngMsg varchar(500)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE  @ColumnsList varchar(8000), @VariablesDeclareList varchar(8000), @UpdateListWithoutID varchar(8000)
             , @CurDate varchar(10), @VariablesList varchar(8000), @Query varchar(8000)
    
    SELECT @VariablesDeclareList =     	   
               IsNull(@VariablesDeclareList + ',','') + char(10) + '  @' + COLUMN_NAME + ' ' + DATA_TYPE 
               + CASE WHEN CHARACTER_MAXIMUM_LENGTH is null THEN '' ELSE '(' + CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN 'MAX' ELSE convert(varchar(10),CHARACTER_MAXIMUM_LENGTH) END + ')' END                         
           , @UpdateListWithoutID  = CASE WHEN UPPER(COLUMN_NAME) <> 'ID' THEN IsNull(@UpdateListWithoutID + ', ','') + char(10) + REPLICATE(' ', 12) + '[' + COLUMN_NAME + ']' + ' =  @' + COLUMN_NAME
                                     ELSE @UpdateListWithoutID END
    FROM information_schema.columns 
    WHERE TABLE_NAME = @TableName   
          AND UPPER(COLUMN_NAME) = 'ID'        
             
    SELECT @CurDate = CONVERT(varchar(10), GETDATE(), 104)

    
    SELECT @Query = 
'SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*$Create:     Zapadinskiy Anatoliy$	$Create date:   ' + @CurDate + '$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   ' + @CurDate + '$*/
/*$Version:    1.00$   $Description: Удаление ' + @TableName + '*/
CREATE PROCEDURE ' + @ProcedureName + @VariablesDeclareList


    SELECT @Query = @Query +
'
AS  
BEGIN
    SET NOCOUNT ON  
    DECLARE @UserRightID smallint
    
    /*Check rights*/
    SELECT @UserRightID = ur.ID FROM UserRights ur WHERE ur.DelphiConst = ''' + @RightName + '''
    CREATE TABLE #sp_rights (RightValue tinyint, UserRightID smallint)    
    INSERT #sp_rights EXEC sp_RoleRights_Select @UserRightID
        
    IF (SELECT top 1 RightValue FROM #sp_rights) <> 3 OR not EXISTS(SELECT * FROM #sp_rights)
       RAISERROR ('''+ @WarinngMsg +''', 16, 1)    
    ELSE
        UPDATE ' + @Scheme + '.' + @TableName + ' 
        SET isDeleted = 1
        WHERE ID = @ID
    
    DROP TABLE #sp_rights
END'

	SELECT @Query
END
GO