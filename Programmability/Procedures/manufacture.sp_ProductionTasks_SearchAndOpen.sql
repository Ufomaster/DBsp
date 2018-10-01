SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   02.06.20176$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   13.06.2017$*/
/*$Version:    1.00$   $Decription: Поиск или создание новой сменки$*/
create PROCEDURE [manufacture].[sp_ProductionTasks_SearchAndOpen]
    @StorageStructureID int,
    @ShiftID int,
    @EmployeeID int
AS
BEGIN
    DECLARE @MoveSectorID int, @ProdEndDate datetime, @ProdStartDate datetime,
       @MoveProdTaskID int
    
    --поиск сектора
    SELECT @MoveSectorID = manufacture.fn_GetSectorID_SSID(@StorageStructureID)
    IF @MoveSectorID IS NULL
    RETURN
                
    --поиск сменки
    SELECT @MoveProdTaskID = pt.ID, @ProdEndDate = pt.EndDate, @ProdStartDate = pt.StartDate
    FROM manufacture.ProductionTasks pt
    WHERE pt.ShiftID = @ShiftID AND pt.StorageStructureSectorID = @MoveSectorID
            
     --провека создать новую или переоткрыть сменку.
    IF @MoveProdTaskID IS NOT NULL AND @ProdEndDate IS NOT NULL AND @ProdStartDate IS NOT NULL
    BEGIN
        --закрываем все открытые сменки вне текущей смены, но открытые.
        UPDATE manufacture.ProductionTasks
        SET EndDate = GetDate(), CreateType = 2
        WHERE ShiftID <> @ShiftID AND StorageStructureSectorID = @MoveSectorID AND EndDate IS NULL AND StartDate IS NOT NULL
        --открытие
        UPDATE manufacture.ProductionTasks
        SET EndDate = NULL, CreateType = 2
        WHERE ID = @MoveProdTaskID
    END
    ELSE
    IF @MoveProdTaskID IS NULL
    BEGIN
        --закрываем все открытые сменки вне текущей смены, но открытые.
        UPDATE manufacture.ProductionTasks
        SET EndDate = GetDate(), CreateType = 2
        WHERE ShiftID <> @ShiftID AND StorageStructureSectorID = @MoveSectorID AND EndDate IS NULL AND StartDate IS NOT NULL
        --Новая сменка                
        INSERT INTO manufacture.ProductionTasks(CreateDate, StorageStructureSectorID, ShiftID, StartDate, CreateType)
        SELECT GetDate(), @MoveSectorID, @ShiftID, GetDate(), 1

        SELECT TOP 1 @MoveProdTaskID =  ID FROM manufacture.ProductionTasks
        WHERE StorageStructureSectorID = @MoveSectorID AND ShiftID = @ShiftID AND EndDate IS NULL
        ORDER BY ID DESC
        --при создании новой - конфирмим остатки
        EXEC manufacture.sp_ProductionTasks_FuncConfirmRemains @MoveSectorID, @MoveProdTaskID, @EmployeeID
    END
    
    SELECT @MoveSectorID AS SectorID, @MoveProdTaskID as ProdTaskID
END
GO