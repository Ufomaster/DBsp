SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.03.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   12.03.2015$*/
/*$Version:    1.00$   $Description: Проверка корректности данных типа протокола$*/
CREATE PROCEDURE [QualityControl].[sp_Types_IsValid]
AS
BEGIN
    IF EXISTS(SELECT TreeValues FROM #TypesDetailsBlocks WHERE TreeValues = 1 GROUP BY TreeValues HAVING Count(TreeValues) > 1)
        RAISERROR ('В списке блоков не может быть более 1-го блока с пометкой "Блок включает только поля технологии заказного листа"', 16, 1)
    ELSE
    IF EXISTS(SELECT TmcValues FROM #TypesDetailsBlocks WHERE TmcValues = 1 GROUP BY TmcValues HAVING Count(TmcValues) > 1)
        RAISERROR ('В списке блоков не может быть более 1-го блока с пометкой "Блок включает только данные свойств материала"', 16, 1)
    ELSE
    IF EXISTS(SELECT DetailsValues FROM #TypesDetailsBlocks WHERE DetailsValues = 1 GROUP BY DetailsValues HAVING Count(DetailsValues) > 1)
        RAISERROR ('В списке блоков не может быть более 1-го блока с пометкой "Блок включает только перечень комплектов заказного листа"', 16, 1)
    ELSE
    IF EXISTS(SELECT SchemaValues FROM #TypesDetailsBlocks WHERE SchemaValues = 1 GROUP BY SchemaValues HAVING Count(SchemaValues) > 1)
        RAISERROR ('В списке блоков не может быть более 1-го блока с пометкой "Блок включает только данные схем к заказному листу"', 16, 1)
    ELSE
    IF EXISTS(SELECT TmcValuesTest FROM #TypesDetailsBlocks WHERE TmcValuesTest = 1 GROUP BY TmcValuesTest HAVING Count(TmcValuesTest) > 1)
        RAISERROR ('В списке блоков не может быть более 1-го блока с пометкой "Блок включает только данные свойств для тестирования материала"', 16, 1)
    ELSE 
       
    IF EXISTS(SELECT * FROM #TypesDetailsBlocks WHERE VisibleCaption = 1 AND Name = '' )
        RAISERROR ('В списке блоков не может быть неименованных блоков с пометкой "Отображать заголовок"', 16, 1)
    ELSE
    
    IF EXISTS(SELECT * FROM #TypesDetails WHERE BlockID = (SELECT ID FROM #TypesDetailsBlocks WHERE TreeValues = 1))
        RAISERROR ('Для блока с пометкой "Блок включает только поля технологии заказного листа" нельзя создавать значения', 16, 1)
    ELSE    
    IF EXISTS(SELECT * FROM #TypesDetails WHERE BlockID = (SELECT ID FROM #TypesDetailsBlocks WHERE TmcValues = 1))
        RAISERROR ('Для блока с пометкой "Блок включает только данные свойств материала" нельзя создавать значения', 16, 1)
    ELSE  
    IF EXISTS(SELECT * FROM #TypesDetails WHERE BlockID = (SELECT ID FROM #TypesDetailsBlocks WHERE DetailsValues = 1))
        RAISERROR ('Для блока с пометкой "Блок включает только перечень комплектов заказного листа" нельзя создавать значения', 16, 1)
    ELSE    
    IF EXISTS(SELECT * FROM #TypesDetails WHERE BlockID = (SELECT ID FROM #TypesDetailsBlocks WHERE SchemaValues = 1))
        RAISERROR ('Для блока с пометкой "Блок включает только данные схем к заказному листу" нельзя создавать значения', 16, 1)
    ELSE    
    IF EXISTS(SELECT * FROM #TypesDetails WHERE BlockID = (SELECT ID FROM #TypesDetailsBlocks WHERE TmcValuesTest = 1))
        RAISERROR ('Для блока с пометкой "Блок включает только данные свойств для тестирования материала" нельзя создавать значения', 16, 1)        
    --ELSE  
     
/*        SELECT 'IF OBJECT_ID(''tempdb..#TypesDetailsBlocks'') IS NOT NULL ' +
               '   TRUNCATE TABLE #TypesDetailsBlocks ELSE ' +
               '   CREATE TABLE #TypesDetailsBlocks(_ID int, ID int IDENTITY(1,1), [Name] varchar(1000), ' +
               '   [Expanded] bit, [VisibleCaption] bit, TreeValues bit, SortOrder tinyint, SchemaValues bit, ' +
               '   FontBold bit, FontUnderline bit, AuthorEditable bit, SpecialistEditable bit, ' +
               '   TmcValues bit, DetailsValues bit, NormEditable bit)'


        SELECT 'IF OBJECT_ID(''tempdb..#TypesDetails'') IS NOT NULL ' +
               '    TRUNCATE TABLE #TypesDetails ELSE ' +
               '    CREATE TABLE #TypesDetails(_ID smallint, ID smallint IDENTITY(1,1),  [Caption] varchar(8000), ' +
               '    ValueToCheck varchar(8000), StartDate datetime NOT NULL, EndDate datetime NULL, ' +
               '    SortOrder tinyint NOT NULL, ResultKind tinyint NULL, PCCColumnID int NULL,' +
               '    BlockID smallint NULL)'*/
     
END
GO