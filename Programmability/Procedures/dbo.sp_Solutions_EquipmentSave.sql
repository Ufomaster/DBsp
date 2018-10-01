SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   12.05.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   12.05.2011$
--$Version:    1.00$   $Decription: Сохраняем$
CREATE PROCEDURE [dbo].[sp_Solutions_EquipmentSave]
    @SolutionID Int
AS
BEGIN
    --удалим удалённые
    DELETE se
    FROM dbo.SolutionEquipment se
    LEFT JOIN #SolutionEquipment t ON t.EquipmentID = se.EquipmentID
    WHERE t.EquipmentID IS NULL AND se.SolutionID = @SolutionID

    --изменим изменённые
    UPDATE se
    SET se.EquipmentID = t.EquipmentID
    FROM dbo.SolutionEquipment se
    INNER JOIN #SolutionEquipment t ON t.ID = se.ID AND t.SolutionID = se.SolutionID
    WHERE se.SolutionID = @SolutionID

    --Добавим добавленные
    INSERT INTO dbo.SolutionEquipment(SolutionID, EquipmentID)
    SELECT @SolutionID, t.EquipmentID
    FROM #SolutionEquipment t
    LEFT JOIN SolutionEquipment se ON se.EquipmentID = t.EquipmentID AND se.SolutionID = @SolutionID
    WHERE se.ID IS NULL
    GROUP BY t.EquipmentID
END
GO