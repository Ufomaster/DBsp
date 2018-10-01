SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   12.05.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   12.05.2011$
--$Version:    1.00$   $Decription: Готовим данные на изменение$
CREATE PROCEDURE [dbo].[sp_Solutions_EquipmentPrepare]
    @SolutionID Int
AS
BEGIN
    INSERT INTO #SolutionEquipment(ID, SolutionID, EquipmentID, [Name])
    SELECT e.ID, e.SolutionID, e.EquipmentID, t.[Name]
    FROM dbo.SolutionEquipment e
    LEFT JOIN dbo.Equipment eq ON eq.ID = e.EquipmentID
    LEFT JOIN Tmc t ON t.ID = eq.TmcID
    WHERE e.SolutionID = @SolutionID
END
GO