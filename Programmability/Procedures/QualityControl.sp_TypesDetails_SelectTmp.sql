SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   19.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: Выборка дерева свойств типа протокола$*/
CREATE PROCEDURE [QualityControl].[sp_TypesDetails_SelectTmp]
AS
BEGIN
    SELECT
      - b.ID AS ParentID,
      a.ID,
      1 AS [Level],
      [Caption],
      ValueToCheck, 
      StartDate, 
      EndDate,
      a.SortOrder, 
      a.ResultKind, 
      PCCColumnID,
      BlockID,
      NULL AS Expanded,
      CAST(CASE WHEN EndDate IS NULL THEN 0 ELSE 1 END AS bit) AS IsHidden,
      CASE WHEN EndDate IS NULL THEN 1 ELSE 96 END AS ImageId,
      CAST(0 AS bit) AS FontBold, 
      CAST(0 AS bit) AS FontUnderline,
      a.ImportanceID
    FROM #TypesDetails a
    INNER JOIN #TypesDetailsBlocks b ON b.ID = a.BlockID

    UNION ALL

    SELECT 
        NULL AS ParentID,
        -ID,
        0 AS [Level],
        [Name],        
        NULL AS ValueToCheck, 
        NULL AS StartDate, 
        NULL AS EndDate,
        SortOrder, 
        0 AS ResultKind, 
        NULL AS PCCColumnID,
        _ID AS BlockID, 
        Expanded,
        CAST(NULL AS bit),
        0 AS ImageId,
        FontBold, 
        FontUnderline,
        NULL
    FROM #TypesDetailsBlocks
    ORDER BY [Level], ParentID, SortOrder
END
GO