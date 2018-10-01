SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuiriy$    $Create date:   05.01.2017$
--$Modify:     Oleynik Yuiriy$    $Modify date:   02.11.2017$
--$Version:    1.00$   $Description: Выборка технологических операций$
CREATE PROCEDURE [dbo].[sp_TechOperations_Select]
AS
BEGIN
    SELECT t.*, o.Name AS TOName, sss.Name AS SectorName
    FROM TechOperations t
    INNER JOIN manufacture.TechnologicalOperations o ON o.ID = t.TechnologicalOperationID
    LEFT JOIN manufacture.StorageStructureSectors sss ON sss.ID = t.StorageStructureSectorID
    ORDER BY t.TechnologicalOperationID, t.StorageStructureSectorID
END
GO