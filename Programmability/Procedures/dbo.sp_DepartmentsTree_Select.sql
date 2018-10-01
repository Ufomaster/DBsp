SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   15.10.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   06.08.2015$*/
/*$Version:    1.00$   $Decription: выборка дерева департаментов$*/
CREATE PROCEDURE [dbo].[sp_DepartmentsTree_Select]
AS
BEGIN   
    
    SELECT a.Name, a.ParentName, d.[Level]
    INTO #Tmp
    FROM (
          SELECT  
              d.Name, 
              CASE WHEN p.Name  = 'Управленческое подразделение' THEN NULL ELSE p.[Name] END AS ParentName
          FROM Departments d
          LEFT JOIN Departments p ON p.ID = d.ParentID
          GROUP BY d.Name, CASE WHEN p.Name  = 'Управленческое подразделение' THEN NULL ELSE p.[Name] END) a
    INNER JOIN (SELECT Min([Level]) AS [Level], [Name] FROM Departments GROUP BY [Name]) d ON d.[Name] = a.Name
    ORDER BY d.[Level]

    ;
    WITH ResultTable (Name, ParentName, [Level])
    AS
    (
        SELECT
            ot.[Name], ParentName, [Level]
        FROM #tmp ot
        WHERE ot.ParentName IS NULL
       
        UNION ALL
        
        SELECT
            ot.Name, ot.ParentName, ot.[Level]
        FROM #tmp ot
        INNER JOIN ResultTable AS d ON ot.ParentName = d.Name
    )
    
    
   SELECT
   ROW_NUMBER() OVER (ORDER BY Name) AS ID,
   * 
   FROM ResultTable
   WHERE Name <> 'Управленческое подразделение'
   ORDER BY [Level]

   DROP TABLE #tmp
   
/*    SET NOCOUNT ON
    DECLARE @Err Int    
    SELECT 
         d.ID,
         d.[Name] AS NameVisible,
         d.[Name],
         CASE WHEN (d.IsHidden = 1) OR (d.[Name] LIKE '%закрыт%') THEN 6 ELSE d.NodeImageIndex END AS NodeImageIndex,
         d.NodeState,
         d.ParentID,
         d.[Level],
         d.UserCode1C,
         CASE WHEN d.Code1C IS NULL THEN 0 ELSE 1 END AS [Sync1C],
         d.ObjectTypeID
    FROM Departments d
    WHERE ISNULL(d.IsHidden, 0) = 0
    ORDER BY d.[Level], d.ParentID, d.[Name]*/
        
END
GO