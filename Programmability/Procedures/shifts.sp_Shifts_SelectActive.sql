SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   05.06.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   07.07.2016$*/
/*$Version:    1.00$   $Decription: Смены. Выборка активной$*/
CREATE PROCEDURE [shifts].[sp_Shifts_SelectActive]
    @StorageStructureID int--, /*РМ*/
   --@JobStageID int
AS
BEGIN
--Тут будет поиск по ЗЛ -> его мануфактура -> связка СС-Мануфактура
    SELECT TOP 1 s.ID 
    FROM shifts.Shifts s
    INNER JOIN shifts.ShiftsTypes st ON st.ID = s.ShiftTypeID
    INNER JOIN manufacture.StorageStructureSectors se ON se.ShiftsGroupsID = st.ShiftsGroupsID
    INNER JOIN manufacture.StorageStructureSectorsDetails sm ON sm.StorageStructureID = @StorageStructureID AND se.ID = sm.StorageStructureSectorID
    WHERE s.FactStartDate IS NOT NULL AND s.FactEndDate IS NULL AND ISNULL(s.IsDeleted, 0) = 0
    ORDER BY s.FactStartDate DESC
END
GO