SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   19.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: Возвращает текст создания темповой таблицы $*/
CREATE PROCEDURE [QualityControl].[sp_Types_GetCreateTableText]
    @Type tinyint
AS
BEGIN
    IF @Type = 1 
        SELECT 'IF OBJECT_ID(''tempdb..#TypesDetailsBlocks'') IS NOT NULL ' +
               '   TRUNCATE TABLE #TypesDetailsBlocks ELSE ' +
               '   CREATE TABLE #TypesDetailsBlocks(_ID int, ID int IDENTITY(1,1), [Name] varchar(1000), ' +
               '   [Expanded] bit, [VisibleCaption] bit, TreeValues bit, SortOrder tinyint, SchemaValues bit, ' +
               '   FontBold bit, FontUnderline bit, AuthorEditable bit, SpecialistEditable bit, ' +
               '   TmcValues bit, DetailsValues bit, NormEditable bit, TmcValuesTest bit)'
    ELSE
    IF @Type = 2 
        SELECT 'IF OBJECT_ID(''tempdb..#TypesDetails'') IS NOT NULL ' +
               '    TRUNCATE TABLE #TypesDetails ELSE ' +
               '    CREATE TABLE #TypesDetails(_ID smallint, ID smallint IDENTITY(1,1),  [Caption] varchar(8000), ' +
               '    ValueToCheck varchar(8000), StartDate datetime NOT NULL, EndDate datetime NULL, ' +
               '    SortOrder tinyint NOT NULL, ResultKind tinyint NULL, PCCColumnID int NULL,' +
               '    BlockID smallint NULL, ImportanceID tinyint null)'
    ELSE
    IF @Type = 3
        SELECT 'IF OBJECT_ID(''tempdb..#TypesSigners'') IS NOT NULL ' +
               '    TRUNCATE TABLE #TypesSigners ELSE ' +
               '    CREATE TABLE #TypesSigners(ID int identity(1,1), _ID int , DepartmentPositionID int, EmailOnly bit) '
END
GO