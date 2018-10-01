SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   14.10.2014$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: ВЫбор характеристики ТМЦ*/
CREATE PROCEDURE [QualityControl].[sp_TMCProps_Select]
    @TmcID int,
    @ObjectTypeID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
         p.ID,
         CASE WHEN t.[Status] = 1 OR t.[Status] = 3 THEN t.AssignedToQC 
         ELSE p.AssignedToQC 
         END AS AssignedToQC,
         CASE WHEN t.[Status] = 1 OR t.[Status] = 3 THEN t.AssignedToTestAct 
         ELSE p.AssignedToTestAct 
         END AS AssignedToTestAct,
         CASE WHEN t.[Status] = 1 OR t.[Status] = 3 THEN t.[Name] 
         ELSE p.[Name] 
         END AS [Name],     
         p.ObjectTypeID,
         CASE WHEN t.[Status] = 1 OR t.[Status] = 3 THEN t.ResultKind 
         ELSE p.ResultKind
         END AS ResultKind,          
         p.SortOrder,
         CASE WHEN t.[Status] = 1 OR t.[Status] = 3 THEN t.ValueToCheck 
         ELSE p.ValueToCheck
         END AS ValueToCheck,
         t.ID AS TMCPropsID,
         t.ObjectTypePropsID,
         k.[Name] AS ResultKindName,
         ISNULL(t.[Status], 0) AS [Status],
         CASE WHEN t.[Status] = 1 OR t.[Status] = 3 THEN t.ImportanceID
         ELSE p.ImportanceID
         END AS ImportanceID
    INTO #tmp
    FROM QualityControl.ObjectTypeProps p
    FULL JOIN QualityControl.TMCProps t ON t.ObjectTypePropsID = p.ID AND t.TMCID = @TmcID
    INNER JOIN QualityControl.vw_PropertyKind k ON k.ID = ISNULL(t.ResultKind, p.ResultKind)
    WHERE p.ObjectTypeID = @ObjectTypeID
    
    INSERT INTO #tmp    
    SELECT
         NULL,
         t.AssignedToQC,
         t.AssignedToTestAct,
         t.[Name],
         @ObjectTypeID AS ObjectTypeID,
         t.ResultKind,
         NULL,
         t.ValueToCheck,
         t.ID AS TMCPropsID,
         t.ObjectTypePropsID,
         k.[Name] AS ResultKindName,
         t.[Status],
         t.ImportanceID
    FROM QualityControl.TMCProps t 
    INNER JOIN QualityControl.vw_PropertyKind k ON k.ID = t.ResultKind
    WHERE t.ObjectTypePropsID IS NULL AND t.TMCID = @TmcID AND t.[Status] = 3

    SELECT * FROM #tmp
    ORDER BY SortOrder

    DROP TABLE #tmp
END
GO