SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   25.04.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   25.04.2017$*/
/*$Version:    1.00$   $Decription: Выбор скрипта создания темп таблицы$*/
create PROCEDURE [manufacture].[sp_ProductionTasks_FuncNewGetCreateTableText]
AS
BEGIN
    SELECT 'IF OBJECT_ID(''tempdb..#NewMaterials'') IS NOT NULL ' +
         '    TRUNCATE TABLE #NewMaterials ELSE ' +
         '    CREATE TABLE #NewMaterials(ID int, ' +
         '    Name varchar(255), UnitName varchar(255), Amount decimal(38, 10), Number varchar(15))'
END
GO