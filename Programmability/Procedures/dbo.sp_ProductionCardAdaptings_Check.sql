SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   23.02.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   25.01.2013$*/
/*$Version:    1.00$   $Decription: При переводе в статус c пометкой согласование. Проверка списка согласующих$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptings_Check]
    @ProductionCustomizeID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @StatusID Int
    
    SELECT @StatusID = StatusID FROM ProductionCardCustomize WHERE ID = @ProductionCustomizeID

/* GENERAL EMPLOYEE*/   

    -- на момент поиска согласователей - ищем всех емплоии которые привязаны к типу
    INSERT INTO ProductionCardCustomizeAdaptings ([EmployeeID], [ProductionCardCustomizeID], [Date], [Status], StatusID)
    SELECT
        e.ID,
        @ProductionCustomizeID,
        GetDate(),
        NULL,
        @StatusID
    FROM ProductionCardAdaptingGroupEmployees age
    INNER JOIN ProductionCardAdaptingEmployees ae ON age.ProductionCardAdaptingGroupEmployeesID = ae.ID
    INNER JOIN vw_Employees e ON e.DepartmentPositionID = ae.DepartmentPositionID /* только если назначены сотрудники*/
    INNER JOIN ProductionCardCustomize pc ON pc.ID = @ProductionCustomizeID AND pc.AdaptingGroupID = age.AdaptingGroupID
    INNER JOIN ProductionCardAdaptingEmployeesStatuses ads ON ads.ProductionCardAdaptingEmployeesID = ae.ID AND ads.ProductionCardStatusesID = pc.StatusID
    LEFT JOIN ProductionCardCustomizeAdaptings ad ON ad.EmployeeID = e.ID 
       AND ad.ProductionCardCustomizeID = @ProductionCustomizeID AND ad.StatusID = pc.StatusID/* а это берем уже вставленных ранее согласователей, если это повторный проход*/
    WHERE ad.ID IS NULL /* вставляем не вставленных*/

    /*для вставленных ранее нужно снять пометку о согласовании*/
    UPDATE a
    SET a.[Status] = NULL, a.SignDate = NULL
    FROM ProductionCardCustomizeAdaptings a 
    INNER JOIN vw_Employees e ON e.ID = a.EmployeeID
    INNER JOIN ProductionCardAdaptingEmployees ae ON ae.DepartmentPositionID = e.DepartmentPositionID -- берем указанную в согл. должность и по ней вытаскиваем группу далее        
    INNER JOIN ProductionCardAdaptingGroupEmployees age ON age.ProductionCardAdaptingGroupEmployeesID = ae.ID
    INNER JOIN ProductionCardCustomize pc ON pc.ID = @ProductionCustomizeID AND pc.AdaptingGroupID = age.AdaptingGroupID -- уже по группе, указанной в ЗЛ и в ProductionCardAdaptingGroupEmployees фильтруем усе.
    INNER JOIN ProductionCardAdaptingEmployeesStatuses ads ON ads.ProductionCardAdaptingEmployeesID = ae.ID AND ads.ProductionCardStatusesID = pc.StatusID
    WHERE a.ProductionCardCustomizeID = @ProductionCustomizeID AND a.StatusID = @StatusID
    -- поскольу манагеров нет в списке согласователей, то с него пометка не снимется. это сделаем далее

/*EMPLOYEES - MANAGERS*/

    -- добавим менеджера заказного листа. Они в списке согласующих не должны быть   
    INSERT INTO ProductionCardCustomizeAdaptings ([EmployeeID], [ProductionCardCustomizeID], [Date], [Status], StatusID)
    SELECT
        p.ManEmployeeID,
        @ProductionCustomizeID,
        GetDate(),
        NULL,
        @StatusID
    FROM ProductionCardCustomize p
    INNER JOIN vw_Employees e ON e.ID = p.ManEmployeeID AND e.DepartmentPositionID IS NOT NULL /* только если назначен сотрудник*/
    LEFT JOIN ProductionCardCustomizeAdaptings ad ON ad.EmployeeID = e.ID AND ad.ProductionCardCustomizeID = @ProductionCustomizeID AND ad.StatusID = @StatusID /* а это берем уже вставленных ранее согласователей, если это повторный проход*/
    WHERE ad.ID IS NULL AND p.ID = @ProductionCustomizeID /* вставляем только если не вставлен*/
    
    /*а если вставлен - снимаем подпись*/ -- Если манагер поменялся, то все гуд. со старой записи ManEmployeeID пометка не снимется, а с актуальной ManEmployeeID снимется
    UPDATE a
    SET a.[Status] = NULL, a.SignDate = NULL
    FROM ProductionCardCustomizeAdaptings a     
    INNER JOIN vw_Employees e ON e.ID = a.EmployeeID AND e.DepartmentPositionID IS NOT NULL /* только если назначен сотрудник*/    
    INNER JOIN ProductionCardCustomize pc ON pc.ID = @ProductionCustomizeID AND e.ID = pc.ManEmployeeID -- менеджер ЗЛ
    WHERE a.ProductionCardCustomizeID = @ProductionCustomizeID AND a.StatusID = @StatusID
END
GO