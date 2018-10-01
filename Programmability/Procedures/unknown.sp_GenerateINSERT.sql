SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$   $Create date:   25.02.2011$
--$Modify:     Yuriy Oleynik$   $Modify date:   25.02.2011$
--$Version:    1.00$   $Decription: Генерация типовых хранимых процедур добавления записей в таблицы$
create PROC [unknown].[sp_GenerateINSERT]
    @TableName Varchar(256)
AS
    SET NOCOUNT ON
    DECLARE @ColName Varchar(256), @ColType Varchar(256), @IsNote Bit, @Tmp_INSERT_ProcIsStandart Bit,
        @s Varchar (1000), @TableID Varchar(5), @ObjectID Int, @CurrDate Varchar(10), @CreateDate Varchar(100), 
        @OldText Varchar(8000), @Version Varchar(5), @i Int, @Who Varchar(100), @Result Varchar(MAX)

IF OBJECT_ID(@TableName) IS NOT NULL
BEGIN
    SELECT @s = '', @CurrDate = CONVERT(Char(10), GETDATE(), 104), @Version = '1.00', @Who = SUSER_SNAME()

    SET @s = dbo.fn_GenerateTitle(OBJECT_ID('sp_' + @TableName + '_insert'), @Version, 
        'Процедура добавления в таблицу ' + @TableName) + ' PROCEDURE [dbo].[sp_' + @TableName + '_Insert]'

    SELECT @Result = @s

    DECLARE @t TABLE(colid Int, ColumnName Varchar(200), ColumnType Varchar(200), ColumnDefault Nvarchar(20), Type1 Int)
    INSERT @t(colid, ColumnName, ColumnType, ColumnDefault, Type1)
    SELECT Col.colid, Col.NAME ColumnName, 
    sys.systypes.NAME + CASE WHEN sys.systypes.NAME IN ('char', 'varchar', 'nvarchar', 'varbinary')
    THEN '(' + CASE Col.length WHEN -1 THEN 'MAX' ELSE 
        CASE WHEN sys.systypes.NAME = 'nvarchar' THEN cast(Col.length/2 AS Varchar(5)) 
            ELSE cast(Col.length AS Varchar(5))  END
    END + ')'
    WHEN sys.systypes.NAME IN ('decimal') 
    THEN '(' + cast(Col.xprec AS Varchar(5)) + ', ' + cast(Col.scale AS Varchar(5)) + ')' 
    ELSE '' END + CASE WHEN Col.isnullable = 1 AND c.Text IS NULL THEN ' = null' ELSE '' END ColumnType,
    LEFT(NULLIF(REPLACE(REPLACE(c.Text, '(', ''), ')', ''), 'getdate'), 20) ColumnDefault,
    CASE WHEN sys.systypes.NAME IN ('char', 'varchar', 'nvarchar', 'varbinary') THEN 1 ELSE 0 END
    FROM sys.sysobjects 
        JOIN sys.syscolumns Col ON Col.id = sys.sysobjects.id
        JOIN sys.systypes ON Col.xusertype = sys.systypes.xusertype
        LEFT JOIN sys.syscomments c ON c.id = Col.cdefault AND c.colid = 1
    WHERE sys.sysobjects.NAME = @TableName AND Col.iscomputed = 0
        AND Col.NAME NOT IN ('ID')
    ORDER BY Col.colid

    SET @s = ''
    SELECT @s = @s + CASE WHEN @s = '' THEN '' ELSE Char(13) END + '    @' + ColumnName + ' ' + ColumnType 
        + CASE WHEN ColumnDefault IS NULL THEN '' ELSE ' = ' 
        + CASE WHEN Type1 = 0 THEN ColumnDefault ELSE '''' + ColumnDefault + '''' END END + ','
    FROM @t ORDER BY colid
    
    SELECT @Result = @Result + '
' + @s + '
    @OutID bigint = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    DECLARE @Err int
    DECLARE @t TABLE(ID bigint)
    BEGIN TRAN
    BEGIN TRY
        INSERT ' + @TableName + '(
            ID,
'

    SET @s = ''
    SELECT @s = @s + CASE WHEN @s = '' THEN '' ELSE ',' + Char(13) END + '            '
        + CASE WHEN ColumnName IN ('Name', 'Type', 'Month', 'Year', 'DateTime', 'Content', 'Description', 'Status') THEN '[' + ColumnName + ']' ELSE ColumnName END
    FROM @t ORDER BY colid
    SET @s = @s + ')'

    SELECT @Result = @Result + @s + '   
        OUTPUT INSERTED.ID INTO @t
        SELECT
            ISNULL(MAX(ID), 0) + 1,
'

    SET @s = ''
    SELECT @s = @s + CASE WHEN @s = '' THEN '' ELSE ',' + Char(13) END + '            @' + ColumnName
    FROM @t ORDER BY colid

    SELECT @Result = @Result + @s + '
        FROM ' + @TableName + '
        SELECT @OutID = ID FROM @t
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
        SET @OutID = -1
    END CATCH
    SELECT @OutID AS [Result]
END
GO'
    SELECT @Result
END
GO