SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   15.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   07.07.2011$
--$Version:    1.00$   $Decription: Готовим данные на изменение$
CREATE PROCEDURE [dbo].[sp_Equipment_Prepare]
    @EquipmentID Int
AS
BEGIN
    SELECT 'Устарело'
/*    INSERT INTO #EquipmentLink(ID, EquipmentID, EmployeeID)
    SELECT e.ID, e.EquipmentID, e.EmployeeID
    FROM dbo.EmployeeEquipment e
    WHERE e.EquipmentID = @EquipmentID*/
END
GO