SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   17.12.2013$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   08.04.2014$*/
/*$Version:    1.00$   $Description: Создаем файл настроек для bulk insert$*/
CREATE PROCEDURE [manufacture].[sp_CreateNonXMLFormatFile] 
    @ColumnCount tinyint, 
    @Separator varchar(1),
	@FilePath varchar(512)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @command VARCHAR(4000)
            , @i tinyint          
            , @Err int
            
    BEGIN TRY 
        SET @command = 'echo.' +  '10.0> ' + @FilePath
        EXEC master..xp_cmdshell @command, no_output
        SET @command = 'echo.' + Convert(varchar(3),@ColumnCount) + '>> ' + @FilePath
        EXEC master..xp_cmdshell @command, no_output

        SET @i = 1
        SET @command = 'CREATE TABLE #TMCImportFile (ID int IDENTITY(1,1) NOT NULL, '
        WHILE @i <= @ColumnCount
        BEGIN    	
            SET @command = Convert(varchar(3),@i) + '       SQLCHAR      0       255     "' + CASE WHEN @i = @ColumnCount THEN '\r\n' ELSE @Separator END + '"   ' + Convert(varchar(3),@i+1) + '     ' +'Column_' + Convert(varchar(3),@i) + '                 ""'
            SET @command = 'echo.' + @command + '>>' + @FilePath
            EXEC master..xp_cmdshell @command, no_output
            SET @i = @i + 1
        END
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR      
        EXEC sp_RaiseError @ID = @Err
    END CATCH        
END
GO
