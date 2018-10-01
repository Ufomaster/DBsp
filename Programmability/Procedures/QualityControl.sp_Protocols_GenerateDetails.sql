SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   14.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   30.04.2015$*/
/*$Version:    1.00$   $Description: генерация детальной части при создании протокола$*/
CREATE PROCEDURE [QualityControl].[sp_Protocols_GenerateDetails]
    @TypeID Int,
    @PCCID int = NULL,
    @TMCID int = NULL
AS
BEGIN
/*
DECLARE @TypeID int, @PCCID int
SET @TypeID = 1
SET @PCCID = 5414
*/
    DECLARE @SourceType tinyint
    SELECT @SourceType = t.SourceType 
    FROM QualityControl.Types t 
    WHERE t.ID = @TypeID
/*1 выбираем технические характеристики ЗЛ*/
    SELECT
       ISNULL(ph.ID, phParent.ID) AS ID,
       ISNULL(phValP.ParentID, phParent.ParentID) AS ParentID,
       LEFT('                                          ', (
           CASE WHEN pccp.HandMadeValue IS NULL THEN phValP.NodeLevel ELSE phParent.NodeLevel END 
           -2)*2) + 
           CASE WHEN pccp.HandMadeValue IS NULL THEN otValP.[Name] ELSE otParent.[Name] END AS Parent,
           
       CASE WHEN pccp.HandMadeValue IS NOT NULL THEN pccp.HandMadeValue ELSE otVal.[Name] END AS [Name],
       ISNULL(phValP.NodeLevel, phParent.NodeLevel) AS NodeLevel,
       ISNULL(phValP.NodeOrder, phParent.NodeOrder) AS NodeOrder,
       ISNULL(otValP.ID, otParent.ID) AS ObjectTypeID,
       pccp.SourceType,
       ISNULL(ISNULL(oAtr.AttributeID, oAtrHand.AttributeID), 1) AS AttributeID 
    INTO #PCC
    FROM ProductionCardCustomizeProperties pccp
        /* список выбранных пользователем значений справочников ph-otVal значение, phValP-otValP справочник*/
        LEFT JOIN ProductionCardPropertiesHistoryDetails ph ON ph.ID = pccp.PropHistoryValueID    
        LEFT JOIN ObjectTypes otVal ON otVal.ID = ph.ObjectTypeID                  
        LEFT JOIN ProductionCardPropertiesHistoryDetails phValP ON phValP.ID = ph.ParentID
        LEFT JOIN ObjectTypes otValP ON otValP.ID = phValP.ObjectTypeID
        LEFT JOIN ObjectTypesAttributes oAtr ON oAtr.ObjectTypeID = phValP.ObjectTypeID AND oAtr.AttributeID IN (18,19)
        /* ХендМейды уже имеют HandMadeValueOwnerID, валью есть в pccp, поэтому берем только справочник phParent-otParent*/
        LEFT JOIN ProductionCardPropertiesHistoryDetails phParent ON (phParent.ID = pccp.HandMadeValueOwnerID AND pccp.HandMadeValue IS NOT NULL)
        LEFT JOIN ObjectTypes otParent ON otParent.ID = phParent.ObjectTypeID
        LEFT JOIN ObjectTypesAttributes oAtrHand ON oAtrHand.ObjectTypeID = phParent.ObjectTypeID AND oAtrHand.AttributeID IN (18,19)
    WHERE pccp.ProductionCardCustomizeID = @PCCID; --AND pccp.SourceType = ISNULL(@SourceType, pccp.SourceType);
   
    WITH ResultTable (ID, ParentID, Parent, [Name], SourceType, Sort, ObjectTypeID, AttributeID)
    AS
    (
    /* Anchor member definition*/
        SELECT
            ID, ParentID, Parent, [Name], SourceType,
            CONVERT(Varchar(MAX), RIGHT(REPLICATE('0',10 - LEN(CAST(NodeOrder AS Varchar(10)))) + cast(NodeOrder AS Varchar(10)), 10)) AS [Sort],
            ObjectTypeID, AttributeID
        FROM #PCC e
        WHERE ParentID IS NULL
       /* WHERE (@SourceType IS NULL     AND ParentID IS NULL) OR 
              (@SourceType IS NOT NULL AND ParentID = (SELECT TOP 1 ParentID FROM #PCC WHERE NodeLevel = (SELECT MIN(NodeLevel) FROM #PCC))) OR
              (@SourceType IS NOT NULL AND ParentID IS NULL AND EXISTS(SELECT TOP 1 ParentID FROM #PCC WHERE NodeLevel = (SELECT MIN(NodeLevel) FROM #PCC) AND ParentID IS NULL))*/
        
        UNION ALL
    /* Recursive member definition*/

        SELECT
            e.ID, e.ParentID, e.Parent, e.[Name], e.SourceType,
            CONVERT (Varchar(MAX), RTRIM(Sort) + '|' + RIGHT(REPLICATE('0',10 - LEN(cast(e.NodeOrder AS Varchar(10)))) + cast(e.NodeOrder AS Varchar(10)), 10)) AS [Sort],
            e.ObjectTypeID, e.AttributeID
        FROM #PCC AS e
        INNER JOIN ResultTable AS d ON e.ParentID = d.ID
    )
    
    /*генерируем таблицу аналог QualityControl.TypesDetails, но только со значениями дерева ЗЛ*/
    SELECT
    ROW_NUMBER() OVER (ORDER BY tb.ID, Sort) AS SortOrder,
    rt.ID, 
    rt.Parent, 
    rt.Name,
    tb.ID AS BlockID,
    pi.ID AS ImportanceID
    INTO #TreeValues
    FROM ResultTable as rt
        INNER JOIN QualityControl.PropImportance pi ON pi.ID = rt.AttributeID
        LEFT JOIN ObjectTypesAttributes as ota on ota.ObjectTypeID = rt.ObjectTypeID
        INNER JOIN QualityControl.TypesBlocks tb ON tb.TreeValues = 1 AND tb.TypesID = @TypeID
    WHERE ota.AttributeID = 14 AND rt.SourceType = ISNULL(@SourceType, rt.SourceType)     
    ORDER BY tb.ID, Sort    
    
    DROP TABLE #PCC

/* 2 Выберем значения полей из заказного листа*/
    CREATE TABLE #PCCFieldNames (ID int, FieldValue varchar(max))
    DECLARE @Query varchar(max), 
        @PCCColumnID int, 
        @DataTypeCastToText varchar(255)
    
    DECLARE Cur CURSOR FOR  SELECT
                                a.PCCColumnID,
                                f.DataTypeCastToText
                            FROM QualityControl.TypesDetails a
                            INNER JOIN dbo.ProductionCardFields f ON f.colid = a.PCCColumnID
                            WHERE a.TypesID = @TypeID AND a.EndDate IS NULL AND a.PCCColumnID IS NOT NULL
                            GROUP BY a.PCCColumnID, f.DataTypeCastToText
    OPEN Cur
    FETCH NEXT FROM Cur INTO @PCCColumnID, @DataTypeCastToText
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        /*соберем поля ЗЛ для выборки данных в блок*/
        SELECT @Query = 
        ' INSERT INTO #PCCFieldNames (ID, FieldValue) ' +
        ' SELECT ' + CAST(@PCCColumnID AS Varchar) + ', ' + @DataTypeCastToText + 
        ' FROM ProductionCardCustomize a WHERE a.ID = ' + CAST(@PCCID AS Varchar)
        EXEC(@Query)
        
        FETCH NEXT FROM Cur INTO @PCCColumnID, @DataTypeCastToText
    END
    CLOSE Cur
    DEALLOCATE Cur
    

/*3 SchemaValues - блок по схемам ЗЛ*/       
    CREATE TABLE #Values_Tmc_Scheme_Details(ID int identity(1,1), ParentID int,  [Name] Varchar(max), ResultKind smallint, ValueToCheck varchar(max), [Value] bit, ImportanceID tinyint)

    INSERT INTO #Values_Tmc_Scheme_Details(ParentID, [Name], ResultKind, ValueToCheck, [Value], ImportanceID)
    SELECT 
       scm.ParentID,
       scm.[Name],
       2 AS ResultKind, --схемные значения все влияют на результат
       scm.ValueToCheck,
       0 AS [Value],
       1
    FROM (SELECT
          ROW_NUMBER() OVER (ORDER BY l.[Date]) AS ID,
          (SELECT tb.ID FROM QualityControl.TypesBlocks tb WHERE tb.SchemaValues = 1 AND tb.TypesID = @TypeID) AS ParentID,
          '[' + CAST(ROW_NUMBER() OVER (ORDER BY l.[Date]) AS varchar(5)) + '] ' + ISNULL(l.[FileName], '') AS Name,
          'Виконання продукції постачальником згідно зі схемою' AS ValueToCheck,
          0 AS [Order]
          FROM ProductionCardCustomizeLayout l
          WHERE l.ProductionCardCustomizeID = @PCCID AND EXISTS(SELECT ID FROM QualityControl.TypesBlocks WHERE SchemaValues = 1 AND TypesID = @TypeID)

          UNION ALL

          SELECT
          ROW_NUMBER() OVER (ORDER BY l.[Date]) AS ID,
          (SELECT tb.ID FROM QualityControl.TypesBlocks tb WHERE tb.SchemaValues = 1 AND tb.TypesID = @TypeID) AS ParentID,
          'Відповідність схемі [' + CAST(ROW_NUMBER() OVER (ORDER BY l.[Date]) AS varchar(5)) + ']' AS Name,
          NULL,
          1 AS [Order]
          FROM ProductionCardCustomizeLayout l
          WHERE l.ProductionCardCustomizeID = @PCCID AND EXISTS(SELECT ID FROM QualityControl.TypesBlocks WHERE SchemaValues = 1 AND TypesID = @TypeID)
          ) AS scm
    ORDER BY ROW_NUMBER() OVER (ORDER BY scm.ID, scm.[Order])
          
/*4 TMC - только для протокола*/
    --отберем нативные и заменённые
    INSERT INTO #Values_Tmc_Scheme_Details(ParentID, [Name], ResultKind, ValueToCheck, [Value], ImportanceID) 
    SELECT 
        (SELECT ID FROM QualityControl.TypesBlocks WHERE TmcValues = 1 AND TypesID = @TypeID) AS ParentID,
        CASE WHEN p.ID IS NULL THEN pd.[Name] ELSE p.[Name] END,
        CASE WHEN p.ID IS NULL THEN pd.ResultKind ELSE p.ResultKind END, 
        CASE WHEN p.ID IS NULL THEN pd.ValueToCheck ELSE p.ValueToCheck END,
        CASE WHEN p.ID IS NULL THEN 
                                   CASE WHEN pd.ResultKind = 0 OR pd.ResultKind = 1 THEN NULL ELSE 1 END
        ELSE
            CASE WHEN p.ResultKind = 0 OR p.ResultKind = 1 THEN NULL ELSE 1 END
        END,
        CASE WHEN p.ID IS NULL THEN pd.ImportanceID ELSE p.ImportanceID END
    FROM QualityControl.ObjectTypeProps pd
    INNER JOIN Tmc t ON t.ID = @TMCID AND t.ObjectTypeID = pd.ObjectTypeID
    LEFT JOIN QualityControl.TMCProps p ON p.ObjectTypePropsID = pd.ID AND p.TMCID = @TMCID AND p.[Status] = 1
    WHERE (pd.AssignedToQC = 1 OR (pd.AssignedToQC = 0 AND p.AssignedToQC = 1)) AND /*выбираем также оверлоад по полю "Использовать в КК"*/
        EXISTS(SELECT ID FROM QualityControl.TypesBlocks WHERE TmcValues = 1 AND TypesID = @TypeID)
        AND pd.ID NOT IN (SELECT n.ObjectTypePropsID FROM QualityControl.TMCProps n WHERE n.TMCID = @TMCID AND (n.[Status] = 2 /*фильтруем удалённые*/ OR p.AssignedToQC = 0))
    ORDER BY pd.SortOrder

    --отберем добавленные
    INSERT INTO #Values_Tmc_Scheme_Details(ParentID, [Name], ResultKind, ValueToCheck, [Value], ImportanceID) 
    SELECT 
        (SELECT ID FROM QualityControl.TypesBlocks WHERE TmcValues = 1 AND TypesID = @TypeID) AS ParentID,
        p.[Name] AS [Name],
        p.ResultKind AS ResultKind, 
        p.ValueToCheck AS ValueToCheck,
        CASE WHEN p.ResultKind = 0 OR p.ResultKind = 1 THEN NULL ELSE 1 END AS [Value],
        p.ImportanceID
    FROM QualityControl.TMCProps p
    WHERE p.[Status] = 3 AND p.AssignedToQC = 1 AND EXISTS(SELECT ID FROM QualityControl.TypesBlocks WHERE TmcValues = 1 AND TypesID = @TypeID) AND p.TMCID = @TMCID
    ORDER BY p.ID
    
/*4.1 TMC - только для тестирования*/
    --отберем нативные и заменённые
    INSERT INTO #Values_Tmc_Scheme_Details(ParentID, [Name], ResultKind, ValueToCheck, [Value], ImportanceID) 
    SELECT 
        (SELECT ID FROM QualityControl.TypesBlocks WHERE TmcValuesTest = 1 AND TypesID = @TypeID) AS ParentID,
        CASE WHEN p.ID IS NULL THEN pd.[Name] ELSE p.[Name] END,
        CASE WHEN p.ID IS NULL THEN pd.ResultKind ELSE p.ResultKind END, 
        CASE WHEN p.ID IS NULL THEN pd.ValueToCheck ELSE p.ValueToCheck END,
        CASE WHEN p.ID IS NULL THEN 
                                   CASE WHEN pd.ResultKind = 0 OR pd.ResultKind = 1 THEN NULL ELSE 1 END
        ELSE
            CASE WHEN p.ResultKind = 0 OR p.ResultKind = 1 THEN NULL ELSE 1 END
        END,
        CASE WHEN p.ID IS NULL THEN pd.ImportanceID ELSE p.ImportanceID END
    FROM QualityControl.ObjectTypeProps pd
    INNER JOIN Tmc t ON t.ID = @TMCID AND t.ObjectTypeID = pd.ObjectTypeID
    LEFT JOIN QualityControl.TMCProps p ON p.ObjectTypePropsID = pd.ID AND p.TMCID = @TMCID AND p.[Status] = 1
    WHERE (pd.AssignedToTestAct = 1 OR (pd.AssignedToTestAct = 0 AND p.AssignedToTestAct = 1)) AND /*выбираем также оверлоад по полю "Использовать в тестировании"*/
        EXISTS(SELECT ID FROM QualityControl.TypesBlocks WHERE TmcValuesTest = 1 AND TypesID = @TypeID)
        AND pd.ID NOT IN (SELECT n.ObjectTypePropsID FROM QualityControl.TMCProps n WHERE n.TMCID = @TMCID AND (n.[Status] = 2 /*фильтруем удалённые*/ OR p.AssignedToTestAct = 0))
    ORDER BY pd.SortOrder

    --отберем добавленные
    INSERT INTO #Values_Tmc_Scheme_Details(ParentID, [Name], ResultKind, ValueToCheck, [Value], ImportanceID) 
    SELECT 
        (SELECT ID FROM QualityControl.TypesBlocks WHERE TmcValuesTest = 1 AND TypesID = @TypeID) AS ParentID,
        p.[Name] AS [Name],
        p.ResultKind AS ResultKind, 
        p.ValueToCheck AS ValueToCheck,
        CASE WHEN p.ResultKind = 0 OR p.ResultKind = 1 THEN NULL ELSE 1 END AS [Value],
        p.ImportanceID
    FROM QualityControl.TMCProps p
    WHERE p.[Status] = 3 AND p.AssignedToTestAct = 1 AND EXISTS(SELECT ID FROM QualityControl.TypesBlocks WHERE TmcValuesTest = 1 AND TypesID = @TypeID) AND p.TMCID = @TMCID
    ORDER BY p.ID
    
              
/* 5 DetailsValues - блок с комплектами ЗЛ*/
    INSERT INTO #Values_Tmc_Scheme_Details(ParentID, [Name], ResultKind, ValueToCheck, [Value], ImportanceID) 
    SELECT 
       scm.ParentID,
       scm.[Name],
       2 AS ResultKind,
       scm.ValueToCheck,
       0 AS [Value],
       1
    FROM ( SELECT
                ROW_NUMBER() OVER (ORDER BY d.ID) AS ID,
                (SELECT tb.ID FROM QualityControl.TypesBlocks tb WHERE tb.DetailsValues = 1 AND tb.TypesID = @TypeID) AS ParentID,
                 CAST(ROW_NUMBER() OVER (ORDER BY d.ID) AS varchar(5)) + ' ' + ISNULL(pc.Name, '') AS Name,
                '№ та дата Протоколу вхідного контролю Ф-8.2.6-01' AS ValueToCheck,
                0 AS [Order]
           FROM ProductionCardCustomizeDetails d
           INNER JOIN ProductionCardCustomize pc ON pc.ID = d.LinkedProductionCardCustomizeID
           WHERE d.ProductionCardCustomizeID = @PCCID AND d.LinkedProductionCardCustomizeID IS NOT NULL AND 
              EXISTS(SELECT ID FROM QualityControl.TypesBlocks WHERE DetailsValues = 1 AND TypesID = @TypeID)

           UNION ALL

           SELECT
                ROW_NUMBER() OVER (ORDER BY d.ID) AS ID,
                (SELECT tb.ID FROM QualityControl.TypesBlocks tb WHERE tb.DetailsValues = 1 AND tb.TypesID = @TypeID) AS ParentID,
                 CAST(ROW_NUMBER() OVER (ORDER BY d.ID) AS varchar(5)) + ' ' + ISNULL(pc.Name, '') AS Name,
                '№ та дата Протоколу контролю якості Ф-8.2.6-02 на складові частини комплекту' AS ValueToCheck,
                1 AS [Order]
           FROM ProductionCardCustomizeDetails d
           INNER JOIN ProductionCardCustomize pc ON pc.ID = d.LinkedProductionCardCustomizeID
           WHERE d.ProductionCardCustomizeID = @PCCID AND d.LinkedProductionCardCustomizeID IS NOT NULL AND 
              EXISTS(SELECT ID FROM QualityControl.TypesBlocks WHERE DetailsValues = 1 AND TypesID = @TypeID)
        ) AS scm
    ORDER BY ROW_NUMBER() OVER (ORDER BY scm.ID, scm.[Order])
          
    
    /*КОНЕЦ--- Схлопываем все результаты в одну таблицу*/
    SELECT
         -b.ID AS ParentID,
         a.ID,
         1 AS [Level],
         [Caption],
         CAST(CASE WHEN a.PCCColumnID IS NULL THEN ValueToCheck ELSE pc.FieldValue END AS varchar(max)) AS ValueToCheck,
         NULL AS [FactValue],
         a.SortOrder, 
         ResultKind,
         NULL AS BlockID,
         CASE WHEN ResultKind = 0 OR ResultKind = 1 THEN NULL ELSE 1 END AS [Value],
         a.ImportanceID
    INTO #tmp
    FROM QualityControl.TypesDetails a
    INNER JOIN QualityControl.TypesBlocks b ON b.ID = a.BlockID
    LEFT JOIN #PCCFieldNames pc ON pc.ID = a.PCCColumnID
    WHERE a.TypesID = @TypeID AND a.EndDate IS NULL

    UNION ALL
    
    SELECT
        -a.BlockID AS ParentID,
        -a.ID AS ID,
        1 AS [Level],
        a.Parent AS [Caption],
        Name AS ValueToCheck, 
        NULL AS [FactValue],
        a.SortOrder,
        2 AS ResultKind, --древесные значения все влияют на результат
        NULL AS BlockID,
        1 AS [Value],
        a.ImportanceID
    FROM #TreeValues a

    UNION ALL
    
    SELECT
        -a.ParentID,
        100000 + a.ID AS ID,
        1 AS [Level],
        a.Name AS [Caption],
        a.ValueToCheck AS ValueToCheck, 
        NULL AS [FactValue],
        a.ID AS SortOrder,
        a.ResultKind, 
        NULL AS BlockID,
        a.[Value],
        a.ImportanceID
    FROM #Values_Tmc_Scheme_Details a -- солянка   

    UNION ALL    

    SELECT 
        NULL AS ParentID,
        -ID,
        0 AS [Level],
        [Name],        
        NULL AS ValueToCheck, 
        NULL AS [FactValue],
        SortOrder,
        0 AS ResultKind, --заголовок всегда только для чтения.
        ID AS BlockID,
        NULL AS [Value],
        NULL
    FROM QualityControl.TypesBlocks
    WHERE TypesID = @TypeID
    ORDER BY [Level], ParentID, SortOrder;

    
    WITH ResultTable (_ID, ParentID, NodeLevel, SortOrder, Sort)
    AS
    (
        /* Anchor member definition*/
        SELECT
            ID, ParentID, [Level], SortOrder
            ,CONVERT(Varchar(300), RIGHT('00' + CAST(e.SortOrder AS Varchar(2)), 2))            
        FROM #tmp e
        WHERE ParentID IS NULL
        UNION ALL
        /* Recursive member definition*/
        SELECT
            e.ID, e.ParentID, e.[Level], e.SortOrder
            ,CONVERT(Varchar(300), d.Sort + RIGHT('00' + CAST(e.SortOrder AS Varchar(2)), 2))
        FROM #tmp AS e
        INNER JOIN ResultTable AS d ON e.ParentID = d._ID

    )
    
    /* 4 Финишный вид*/
    SELECT
        ROW_NUMBER() OVER (ORDER BY b.Sort, a.SortOrder) AS ID,
        a.*,
        -a.ParentID AS DetailBlockID
    FROM ResultTable b 
    INNER JOIN #tmp a ON a.ID = b._ID
    ORDER BY b.Sort, a.SortOrder    
    
    DROP TABLE #tmp
    DROP TABLE #PCCFieldNames
    DROP TABLE #TreeValues
    DROP TABLE #Values_Tmc_Scheme_Details
END
GO