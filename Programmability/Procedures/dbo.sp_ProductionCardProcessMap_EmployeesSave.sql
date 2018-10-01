SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   23.05.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   24.05.2012$*/
/*$Version:    1.00$   $Decription: Сохраняем$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProcessMap_EmployeesSave]
    @ProductionCardProcessMapID Int
AS
BEGIN
    /*удалим удалённые*/
    DELETE me
    FROM dbo.ProductionCardProcessMapNEEmployees me
    LEFT JOIN #ProcessEmployees t ON t._ID = me.ID
    WHERE t._ID IS NULL AND me.ProductionCardProcessMapID = @ProductionCardProcessMapID

    /*изменим изменённые*/
    UPDATE me
    SET me.UseAdaptingFiltering = ISNULL(t.UseAdaptingFiltering, 0)
    FROM dbo.ProductionCardProcessMapNEEmployees me
    INNER JOIN #ProcessEmployees t ON t._ID = me.ID
    WHERE me.ProductionCardProcessMapID = @ProductionCardProcessMapID

    /*Добавим добавленные*/
    INSERT INTO ProductionCardProcessMapNEEmployees(DepartmentPositionID, UseAdaptingFiltering,
      ProductionCardProcessMapID)
    SELECT
        d.DepartmentPositionID,
        ISNULL(d.UseAdaptingFiltering, 0),
        @ProductionCardProcessMapID
    FROM #ProcessEmployees d
    LEFT JOIN ProductionCardProcessMapNEEmployees pa ON pa.ID = d._ID AND pa.ProductionCardProcessMapID = @ProductionCardProcessMapID
    WHERE pa.ID IS NULL

    /*поскольку получатели сообщения автоматом фильтруются по перечню получателей того или иного месажда, то нужно отразить изменения
    и в этом списке.*/
    DECLARE @EventID Int
    SELECT @EventID = m.NotifyEventID
    FROM ProductionCardProcessMap m WHERE m.ID = @ProductionCardProcessMapID
    IF @EventID IS NOT NULL 
    BEGIN        
        /*удалим удаленные, но удаленные по всем процессам, а не по одному*/
/*        DELETE a
        FROM NotifyEventsEmployees a
        LEFT JOIN ProductionCardProcessMapNEEmployees pme ON pme.DepartmentPositionID = a.DepartmentPositionID
        WHERE a.NotifyEventID = @EventID AND pme.ID IS NULL*/
        
        /*Добавим добавленные*/
        INSERT INTO NotifyEventsEmployees([NotifyEventID], [DepartmentPositionID], [isActive])
        SELECT @EventID, pme.DepartmentPositionID, 1
        FROM ProductionCardProcessMapNEEmployees pme
        LEFT JOIN NotifyEventsEmployees n ON n.DepartmentPositionID = pme.DepartmentPositionID AND n.NotifyEventID = @EventID
        WHERE pme.ProductionCardProcessMapID = @ProductionCardProcessMapID AND n.ID IS NULL
    END    
END
GO