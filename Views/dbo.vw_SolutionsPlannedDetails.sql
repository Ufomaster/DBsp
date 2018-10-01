SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   12.07.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   09.08.2011$
--$Version:    1.00$   $Description: Вьюшка с данными регламентных работ плановых работ
CREATE VIEW [dbo].[vw_SolutionsPlannedDetails]
AS
    SELECT
       spd.ID,
       spd.SolutionsDeclaredID,
       spd.SolutionsPlannedID,
       spdec.Comments,
       spdec.KindName,
       spdec.[Name],
       spdec.SpendNorma,
       spdec.Kind,
       spdec.SpendNormaUnitID,
       spdec.TimeNorma,
       spdec.TMCID,
       spdec.TmcName,
       spdec.UnitName,
       spdec.WorkersCount,
       spdec.TotalTime,
       spdec.SolutionsDeclaredGroupsID,
       spdec.SolutionsDeclaredGroupName
    FROM dbo.SolutionsPlannedDetails spd
    INNER JOIN SolutionsPlanned sp ON sp.ID = spd.SolutionsPlannedID
    INNER JOIN vw_SolutionsDeclared spdec ON spdec.ID = spd.SolutionsDeclaredID
GO