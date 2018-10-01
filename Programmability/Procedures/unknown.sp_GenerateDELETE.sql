SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$   $Create date:   25.02.2011$
--$Modify:     Yuriy Oleynik$   $Modify date:   25.02.2011$
--$Version:    1.00$   $Decription: Генерация типовых хранимых процедур удаления записей из таблиц$
create PROC [unknown].[sp_GenerateDELETE] 
    @TableName Varchar(256)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @s Varchar (8000), @TableID Varchar(5), @Tmp_DELETE_ProcIsStandart Bit,
         @ObjectID Int, @CurrDate Varchar(10), @CreateDate Varchar(100), 
         @OldText Varchar(8000), @Version Varchar(5), @i Int, @Who Varchar(100),
         @Result Varchar(MAX)
    SELECT 
        @s = '', 
        @CurrDate = CONVERT(Char(10), GETDATE(), 104), 
        @Version = '1.00', 
        @Who = SUSER_SNAME()
    
    SET @s = dbo.fn_GenerateTitle(OBJECT_ID('sp_' + @TableName + '_delete'), @Version,
        'Удаление из таблицы ' + @TableName) + ' PROCEDURE [dbo].[sp_' + @TableName + '_Delete]'

--    SELECT @TableID = cast(ID as varchar(5)) FROM Tables WHERE [Name] = @TableName

    SELECT @Result  = 
@s + '
    @ID bigint,
    @OutID bigint = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    DECLARE @Err int

    BEGIN TRAN
    BEGIN TRY
        DELETE FROM ' + @TableName + '
        WHERE ID = @ID

        SET @OutID = @@ROWCOUNT
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
        SET @OutID = -1
    END CATCH
    SELECT @OutID [Result]
END
GO'
    SELECT @Result
END
GO