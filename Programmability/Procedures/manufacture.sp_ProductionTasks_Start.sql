SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   03.08.2016$*/
/*$Modify:     Polyatykin Aleksey$    $Modify date:   14.02.2018*/
/*$Version:    1.00$   $Decription: Запуcк сменного задания$*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_Start]
    @SectorID int,
    @ShiftID int,
    @EmployeeID int = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int
    DECLARE @UserID int, @CanLaunch bit
    SELECT @UserID = ID FROM #CurrentUser
    SET @CanLaunch = 0
/*    1 can view. 0 no view*/
    SELECT
        @CanLaunch = CASE WHEN MAX(ISNULL(uro1.RightValue, 1)) = 3 THEN 1 ELSE 0 END
    FROM RoleUsers ru
    LEFT JOIN UserRightsObjectRights uro1 ON uro1.RoleID = ru.RoleID AND uro1.ObjectID = 360 --urProductionTasksSuperUser
    WHERE ru.UserID = @UserID
        
    BEGIN TRY
    	--If another production task already exists
        IF EXISTS(SELECT *
                  FROM manufacture.ProductionTasks pt
                  WHERE pt.StorageStructureSectorID = @SectorID AND pt.StartDate is not null AND pt.EndDate is null)
        BEGIN            
            RAISERROR ('По данному участку уже запущенно сменное задание. Запуск двух одновременно - запрещено', 16, 1)
            RETURN
        END
        ELSE        
        --If it's more/less then 14 hours before|after shift scheduled start
        IF (SELECT DATEDIFF(hh, s.PlanStartDate, GETDATE())
            FROM shifts.shifts s
            WHERE s.ID = @ShiftID) > 14  AND (@CanLaunch = 0)
        BEGIN            
            RAISERROR ('Запуск сменное задание запрещен. Плановое время старта смены отличается от текущего больше чем 14 часов.', 16, 1)
            RETURN            
        END
        ELSE
        IF (SELECT DATEDIFF(hh, s.PlanStartDate, GETDATE())
            FROM shifts.shifts s
            WHERE s.ID = @ShiftID) < -1  AND (@CanLaunch = 0)
        BEGIN            
            RAISERROR ('Запуск сменного задания запрещен. Текущее время старта смены отличается от планового больше чем 1 час.', 16, 1)
            RETURN            
        END
        ELSE
        IF EXISTS(SELECT ID
            FROM shifts.shifts s
            WHERE s.ID = @ShiftID AND ISNULL(s.IsDeleted, 0) = 1)
        BEGIN            
            RAISERROR ('Запуск сменное задание запрещен. Смена удалена.', 16, 1)
            RETURN
        END
        
        IF NOT EXISTS(SELECT *
                      FROM manufacture.ProductionTasks pt
                      WHERE pt.StorageStructureSectorID = @SectorID AND pt.ShiftID = @ShiftID)
        BEGIN
            INSERT INTO manufacture.ProductionTasks(CreateDate, StorageStructureSectorID, ShiftID, StartDate, ChiefEmployeeID)
            SELECT GetDate(), @SectorID, @ShiftID, GetDate(), @EmployeeID
        END
        ELSE
        IF EXISTS(SELECT *
                  FROM manufacture.ProductionTasks pt
                  WHERE pt.StorageStructureSectorID = @SectorID AND pt.ShiftID = @ShiftID AND pt.StartDate is not null AND pt.EndDate is not null)    
        BEGIN          
            UPDATE manufacture.ProductionTasks
            SET EndDate = null
            WHERE StorageStructureSectorID = @SectorID 
                  AND ShiftID = @ShiftID 
                  AND (StartDate is not null AND EndDate is not null)                    
        END    
        ELSE      
    	IF EXISTS(SELECT *
                  FROM manufacture.ProductionTasks pt
                  WHERE pt.StorageStructureSectorID = @SectorID AND pt.ShiftID = @ShiftID AND pt.StartDate is null AND pt.EndDate is null)    
        BEGIN          
            UPDATE manufacture.ProductionTasks
            SET EndDate = null,
                StartDate = GetDate()
            WHERE StorageStructureSectorID = @SectorID 
                  AND ShiftID = @ShiftID 
                  AND (StartDate is null AND EndDate is null)                    
        END                  
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        EXEC sp_RaiseError @ID = @Err        
    END CATCH            
END
GO