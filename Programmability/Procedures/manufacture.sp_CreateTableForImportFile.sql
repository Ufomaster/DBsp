SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create PROCEDURE [manufacture].[sp_CreateTableForImportFile]
	@ColumnCount tinyint	
AS
BEGIN
    DECLARE @command varchar(4000),
            @i tinyint,
            @Err int
            
    IF OBJECT_ID('tempdb..#TMCImportFile') IS NOT NULL DROP TABLE #TMCImportFile

	BEGIN TRY
        SET @i = 1
        SET @command = 'CREATE TABLE #TMCImportFile (ID int IDENTITY(1,1) NOT NULL, '
        WHILE @i <= @ColumnCount
        BEGIN    	
            SET @command = @command + 'Column_' + Convert(varchar(3),@i) + ' varchar(255) NULL, '
            SET @i = @i + 1
        END
        SET @command = Left(@command,Len(@Command)-1) + ')'    
        EXEC (@command )    
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR      
        EXEC sp_RaiseError @ID = @Err
    END CATCH    
END
GO