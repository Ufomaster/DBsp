SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   05.12.2013$*/
/*$Modify:     Oleksii Poliatykin$    $Modify date:   03.08.2017$*/
/*$Version:    1.00$   $Description: генерация текста создания временной таблицы для детальной части*/
CREATE PROCEDURE [QualityControl].[sp_Acts_GetCreateTableText]    
    @Type int
AS
BEGIN
    IF @Type = 1 
    SELECT 'IF OBJECT_ID(''tempdb..#ActsDetails'') IS NOT NULL ' +
              '    TRUNCATE TABLE #ActsDetails ELSE ' +
              '    CREATE TABLE #ActsDetails(ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
              '    XMLData xml, ParagraphCaption varchar(255), EmployeeID int, ' +
              '    SortOrder smallint, SignDate datetime)'
    ELSE
    IF @Type = 2
    SELECT 'IF OBJECT_ID(''tempdb..#ActsReasons'') IS NOT NULL ' +
              '    TRUNCATE TABLE #ActsReasons ELSE ' +
              '    CREATE TABLE #ActsReasons(ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
              '    Name varchar(800), FaultsReasonsClassID int)'              
    ELSE
    IF @Type = 3
    SELECT 'IF OBJECT_ID(''tempdb..#ActsTasks'') IS NOT NULL ' +
              '    TRUNCATE TABLE #ActsTasks ELSE ' +
              '    CREATE TABLE #ActsTasks(ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
              '    [Name] varchar(800), AssignedToEmployeeID int NULL, ControlEmployeeID int,'+
              '    [Status] tinyint, CreateDate datetime, Comment varchar(1000), '+
              '    TasksID int, BeginFromDate datetime)'
    ELSE
    IF @Type = 4
    SELECT 'IF OBJECT_ID(''tempdb..#ActsCCIDs'') IS NOT NULL ' +
              '    TRUNCATE TABLE #ActsCCIDs ELSE ' +
              '    CREATE TABLE #ActsCCIDs (ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
              '    CCID varchar(800), [Batch] varchar(800), Box varchar(800), ' +
              '    [Description] varchar(800))'
    ELSE
    IF @Type = 5
    SELECT 'IF OBJECT_ID(''tempdb..#ActsFiles'') IS NOT NULL ' +
              '    TRUNCATE TABLE #ActsFiles ELSE ' +
              '    CREATE TABLE #ActsFiles (ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
              '    FileName varchar(255), [FileData] varbinary(max), ' +
              '    [FileDataThumb] varbinary(max))'
    ELSE
    IF @Type = 6
    SELECT 'IF OBJECT_ID(''tempdb..#ActsZL'') IS NOT NULL ' +
              '    TRUNCATE TABLE #ActsZL ELSE ' +
              '    CREATE TABLE #ActsZL (ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
              '    PCCID int, Number varchar(30), Name varchar(255), ' +
              '    CustomerName varchar(255))'
              
END
GO