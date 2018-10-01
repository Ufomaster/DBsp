SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   19.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   12.12.2016$*/
/*$Version:    1.00$   $Description: Возвращает текст создания темповой таблицы $*/
CREATE PROCEDURE [QualityControl].[sp_Protocols_GetCreateTableText]
    @Type tinyint
AS
BEGIN
    IF @Type = 1 
        SELECT 'IF OBJECT_ID(''tempdb..#ProtocolsDetails'') IS NOT NULL ' +
               '    TRUNCATE TABLE #ProtocolsDetails ELSE ' +
               '    CREATE TABLE #ProtocolsDetails(ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
               '    Caption varchar(max), ValueToCheck varchar(max), FactValue varchar(max), ' +
               '    Checked tinyint, ModifyDate datetime, SortOrder smallint, ' +
               '    ResultKind tinyint, DetailBlockID smallint, BlockID smallint, ImportanceID tinyint)'
    ELSE
    IF @Type = 2 
        SELECT 'IF OBJECT_ID(''tempdb..#ProtocolsSigners'') IS NOT NULL ' +
               '    TRUNCATE TABLE #ProtocolsSigners ELSE ' +
               '    CREATE TABLE #ProtocolsSigners(ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
               '    EmployeeID int, EmailOnly bit, SignDate datetime)'
    ELSE
    IF @Type = 3 
        SELECT 'IF OBJECT_ID(''tempdb..#ProtocolsFiles'') IS NOT NULL ' +
                  '    TRUNCATE TABLE #ProtocolsFiles ELSE ' +
                  '    CREATE TABLE #ProtocolsFiles (ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
                  '    FileName varchar(255), [FileData] varbinary(max), ' +
                  '    [FileDataThumb] varbinary(max))'
END
GO