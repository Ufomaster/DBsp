SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$   $Create date:   25.02.2011$
--$Modify:     Yuriy Oleynik$   $Modify date:   25.02.2011$
--$Version:    1.00$   $Decription: Генерация типовых хранимых процедур выборки записей из таблицы$
create PROC [unknown].[sp_GenerateSELECT] 
    @TableName Varchar(256)
AS
    DECLARE @ColName Varchar(256), @ColType Varchar(256), @CrText Varchar(4000),
        @s Varchar (1000), @TableID Varchar(5), @Result Varchar(MAX)
    IF EXISTS(SELECT 1 FROM sys.sysobjects WHERE NAME = @TableName AND xtype = 'u')
    BEGIN
        SET @CrText = 
            dbo.fn_GenerateTitle(OBJECT_ID('sp_' + @TableName + '_Select'), '1.00', ' Выборка для ' + @TableName)
            + ' PROCEDURE [dbo].[sp_' + @TableName + '_Select] '
        SELECT @Result = @CrText +
'
AS
BEGIN
    SET NOCOUNT ON
    SELECT '
        
        DECLARE Curs2 SCROLL CURSOR FOR
            SELECT sys.syscolumns.NAME, 
            sys.systypes.NAME + CASE WHEN sys.systypes.NAME IN ('char', 'varchar', 'nvarchar', 'varbinary')
            THEN ' (' + CASE sys.syscolumns.length WHEN -1 THEN 'MAX' ELSE 
                CASE WHEN sys.systypes.NAME = 'nvarchar' THEN cast(sys.syscolumns.length/2 AS Varchar(5)) 
                    ELSE cast(sys.syscolumns.length AS Varchar(5))  END
            END + ')'
            WHEN sys.systypes.NAME IN ('decimal') 
            THEN '(' + cast(sys.syscolumns.xprec AS Varchar(5)) + ', ' + cast(sys.syscolumns.xscale AS Varchar(5)) + ')' 
            ELSE '' END + CASE WHEN sys.syscolumns.isnullable = 1 THEN ' = null' ELSE '' END type 
            FROM sys.sysobjects 
                JOIN sys.syscolumns ON sys.syscolumns.id = sys.sysobjects.id
                JOIN sys.systypes ON sys.syscolumns.xusertype = sys.systypes.xusertype
            WHERE sys.sysobjects.NAME = @TableName /*and sys.syscolumns.name not in ('TableID', 'Replicated', 'RepDateTime')*/
            ORDER BY sys.syscolumns.colid
        OPEN Curs2
        FETCH next FROM Curs2 INTO @ColName, @ColType
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @s = '        a.' + @ColName 
            FETCH next FROM Curs2 INTO @ColName, @ColType
            IF @@FETCH_STATUS = 0 
                SET @s = @s + ','
            SELECT @Result = @Result + '
' +@s
        END
        CLOSE Curs2
        DEALLOCATE Curs2
        
        SELECT @Result = @Result +
'
    FROM ' + @TableName + ' a
END
GO'
    SELECT @Result
END
GO