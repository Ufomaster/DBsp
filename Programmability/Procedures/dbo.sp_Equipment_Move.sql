SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   12.04.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   17.10.2013$
--$Version:    1.00$   $Decription: Фиксация истории перемещения ОС$
CREATE PROCEDURE [dbo].[sp_Equipment_Move]
    @FromDepartmentPositionsID Int,
    @ToDepartmentPositionsID Int,
    @EmployeeID Int,
    @EquipmentID Int,
    @FromPlaceID Int
AS
BEGIN
  --фактически урезанная версия созданяи истории. можнос сказать частично дубликат функционала
  --назначение-фиксирование факта перемещения с депарата на департ и факта смены местоположения.
    SET NOCOUNT ON
    DECLARE @Err Int
    DECLARE @ToEmployeeName varchar(100)
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        INSERT INTO EquipmentMove(DepartmentName, PositionName, [Date], EmployeeID, EquipmentID, FromEmployee, FromPlace, ToEmployee, ToPlace)
        SELECT 
            dp.DepartmentName, 
            dp.PositionName, 
            GETDATE(), 
            @EmployeeID, 
            @EquipmentID,
            em.FullName,
            (SELECT [Name] FROM EquipmentPlaces WHERE ID = @FromPlaceID),
            (SELECT e.FullName FROM Employees e  WHERE e.DepartmentPositionID = @ToDepartmentPositionsID),
            (SELECT ep.[Name] FROM Equipment eq INNER JOIN EquipmentPlaces ep ON ep.ID = eq.EquipmentPlaceID WHERE eq.ID = @EquipmentID)            
        FROM vw_DepartmentPositions dp 
        LEFT JOIN vw_Employees em ON em.DepartmentPositionID = dp.ID
        WHERE dp.ID = @FromDepartmentPositionsID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO