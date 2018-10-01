SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   15.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   07.07.2011$
--$Version:    1.00$   $Decription: Сохраняем$
CREATE PROCEDURE [dbo].[sp_Equipment_SaveLink]
    @EquipmentID Int
AS
BEGIN

    SELECT 'Устарело'
/*--    INSERT INTO #EquipmentLink(ID, EquipmentID, EmployeeID)
--    SELECT e.ID, e.EquipmentID, e.EmployeeID
    --удалим удалённые
    DELETE e
    FROM dbo.EmployeeEquipment e
    LEFT JOIN #EquipmentLink el ON el.EquipmentID = e.EquipmentID AND el.EmployeeID = e.EmployeeID
    WHERE el.EquipmentID IS NULL AND e.EquipmentID = @EquipmentID

    --Добавим добавленные
    INSERT INTO dbo.EmployeeEquipment(EquipmentID, EmployeeID)
    SELECT @EquipmentID, lnk.EmployeeID
    FROM #EquipmentLink lnk
    LEFT JOIN EmployeeEquipment ee ON ee.EmployeeID = lnk.EmployeeID
    WHERE lnk.ID IS NULL
    GROUP BY lnk.EmployeeID*/
END
GO