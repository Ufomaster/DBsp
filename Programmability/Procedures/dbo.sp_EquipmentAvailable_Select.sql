SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   24.05.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   07.07.2011$
--$Version:    1.00$   $Description: Список доступного пользователю оборудования$
CREATE PROCEDURE [dbo].[sp_EquipmentAvailable_Select]
    @EmployeeID Int,
    @UserID Int = NULL
AS
BEGIN

    DECLARE @RightValue Int
    IF @EmployeeID = -1
        SELECT @EmployeeID = u.EmployeeID FROM Users u WHERE u.ID = @UserID
    IF @UserID IS NULL 
        SELECT @UserID = u.ID FROM Users u WHERE u.EmployeeID = @EmployeeID
    DECLARE @Rights TABLE(Val Int, ObjectID Int)
    
    INSERT @Rights(Val, ObjectID)
    EXEC dbo.sp_RoleRights_Select @UserID = @UserID
    
    
    SELECT @RightValue = Val FROM @Rights WHERE ObjectID = 123 --urOrdersViewAllEquipment
    
    IF (@RightValue = 3)
    BEGIN
        SELECT
            e.ID,
            e.InventoryNum,
            e.SerialNum,
            e.[Name],
            e.ObjectTypeName,
            e.FullName,
            e.WebName
        FROM vw_Equipment e
        WHERE e.[Status] = 1
        ORDER BY e.WebName
    END
    ELSE
    BEGIN    
        --сотрудник за штаткой
        SELECT
            e.ID,
            e.InventoryNum,
            e.SerialNum,
            e.[Name],
            e.ObjectTypeName,
            e.FullName,
            e.WebName
        FROM vw_Equipment e
        INNER JOIN vw_Employees emp ON emp.DepartmentPositionID = e.DepartmentPositionID
        WHERE e.[Status] = 1 AND emp.ID = @EmployeeID
        ORDER BY e.WebName
/*
        UNION ALL
        --сотрудники по доступу
        SELECT 
            ee.EquipmentID,
            ee.InventoryNum,
            ee.SerialNum,
            ee.[Name],
            ot.[Name],
            emp.FullName
        FROM vw_EmployeeEquipment ee
        INNER JOIN ObjectTypes ot ON ot.ID = ee.ObjectTypeID
        INNER JOIN Equipment e ON e.ID = ee.EquipmentID
        INNER JOIN vw_Employees emp ON e.DepartmentPositionID = emp.DepartmentPositionID
        WHERE ee.EmployeeID = @EmployeeID AND ee.[Status] = 1
        ORDER BY e.InventoryNum*/
    END
END
GO