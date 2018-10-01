SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   09.08.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   09.08.2011$
--$Version:    1.00$   $Description: Вьюшка c регламентными работами
CREATE VIEW [dbo].[vw_SolutionsDeclared]
AS
    SELECT 
        sd.ID,
        sd.Kind,
        sk.[Name] AS KindName,
        sd.[Name],
        sd.SpendNorma,
        sd.SpendNormaUnitID,
        u.[Name] AS UnitName,
        sd.TimeNorma,
        sd.TMCID,
        t.[Name] AS TmcName,
        sd.WorkersCount,
        sd.Comments,
        sd.TimeNorma * sd.WorkersCount AS TotalTime,
        sd.SolutionsDeclaredGroupsID,
        sdg.[Name] AS SolutionsDeclaredGroupName
    FROM dbo.SolutionsDeclared sd
    INNER JOIN vw_SolutionKinds sk ON sk.ID = sd.Kind
    INNER JOIN SolutionsDeclaredGroups sdg ON sdg.ID = sd.SolutionsDeclaredGroupsID
    LEFT JOIN Tmc t ON t.ID = sd.TMCID
    LEFT JOIN Units u ON u.ID = sd.SpendNormaUnitID
GO