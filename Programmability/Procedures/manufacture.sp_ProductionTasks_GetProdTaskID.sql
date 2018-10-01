SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    		$Create date:   19.10.2016$*/
/*$Modify:     Anatoliy Zapadinskiy$    $Modify date:   23.12.2016$*/
/*$Version:    1.00$   $Description: $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_GetProdTaskID]
	 @ProdTaskID int,
     @JobStageID int,
     @StorageStructureID int
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @ShiftID int, @StorageStructureSectorID int, @PCCID int, @ProdTaskStatusID int
    DECLARE @ProdEndDate datetime, @ProdStartDate datetime
    DECLARE @PDoc Table(ID int)
    DECLARE @LocalProdTaskID int, @q varchar(255)
    DECLARE @OpType int

    SET @LocalProdTaskID = @ProdTaskID

    SELECT @StorageStructureSectorID = manufacture.fn_GetSectorID_JobStageID_SSID (@JobStageID, @StorageStructureID)
    IF @StorageStructureSectorID IS NULL
    BEGIN
        RAISERROR ('Участок не найден для выбранного рабочего места. Выполнение прервано.', 16, 1)
        RETURN
    END

--    SELECT @ShiftID = manufacture.fn_GetActiveShiftID_JobStageID(@JobStageID, @StorageStructureSectorID)    
    SELECT @ShiftID = manufacture.fn_GetActiveShiftID(@StorageStructureID)       

    IF @ShiftID IS NULL
    BEGIN
        RAISERROR ('Нет запущенной смены. Выполнение прервано.', 16, 1)
        RETURN
    END

/*    SET @q = '@StorageStructureID='+ CAST(@StorageStructureID AS varchar) + ', '  + 
             '@ProdTaskID='+ CAST(@ProdTaskID AS varchar) + ', '  +
             '@JobStageID='+ CAST(@JobStageID AS varchar) + ', ' +
             '@ShiftID='+ CAST(@ShiftID AS varchar) + ', ' +
             '@StorageStructureSectorID='+ CAST(@StorageStructureSectorID AS varchar)*/
    --RAISERROR (@q, 16, 1)

    IF NOT EXISTS(SELECT ID FROM manufacture.ProductionTasks pt
                  WHERE pt.ShiftID = @ShiftID AND pt.StorageStructureSectorID = @StorageStructureSectorID)
        SET @LocalProdTaskID = NULL
    ELSE
        SELECT @LocalProdTaskID = pt.ID, @ProdEndDate = pt.EndDate, @ProdStartDate = pt.StartDate
        FROM manufacture.ProductionTasks pt
        WHERE pt.ShiftID = @ShiftID AND pt.StorageStructureSectorID = @StorageStructureSectorID

    IF @LocalProdTaskID IS NOT NULL AND @ProdEndDate IS NOT NULL AND @ProdStartDate IS NOT NULL
    BEGIN
        UPDATE manufacture.ProductionTasks
        SET EndDate = GetDate(), CreateType = 2
        WHERE StorageStructureSectorID = @StorageStructureSectorID AND EndDate IS NULL AND StartDate IS NOT NULL
           AND ShiftID <> @ShiftID

        UPDATE manufacture.ProductionTasks
        SET EndDate = NULL, CreateType = 2
        WHERE ID = @LocalProdTaskID

/*SET @OpType = 0*/
    END

    IF @LocalProdTaskID IS NULL OR @LocalProdTaskID = 0
    BEGIN
        UPDATE manufacture.ProductionTasks
        SET EndDate = GetDate(), CreateType = 2
        WHERE StorageStructureSectorID = @StorageStructureSectorID AND EndDate IS NULL AND StartDate IS NOT NULL
           AND ShiftID <> @ShiftID
            
        INSERT INTO manufacture.ProductionTasks(CreateDate, StorageStructureSectorID, ShiftID, StartDate, CreateType)
        OUTPUT INSERTED.ID INTO @PDoc
        SELECT GetDate(), @StorageStructureSectorID, @ShiftID, GetDate(), 1

        SELECT @LocalProdTaskID = ID FROM @PDoc
        --при создании новой - конфирмим остатки

/*SET @OpType = 1*/
        EXEC manufacture.sp_ProductionTasks_FuncConfirmRemains @StorageStructureSectorID, @LocalProdTaskID, NULL, 0
    END
    
/*INSERT INTO manufacture.GetProdTaskIDLog (ID, JobStageID, ProdTaskID, SSID, SectorID, LocalProdTaskID,ShiftID, OpType, ProdEndDate,
   ProdStartDate)
SELECT ISNULL(MAX(ID), 0) + 1,
   @JobStageID, @ProdTaskID, @StorageStructureID, @StorageStructureSectorID, @LocalProdTaskID, @ShiftID, @OpType, @ProdEndDate,
   @ProdStartDate
FROM manufacture.GetProdTaskIDLog*/
  
    SELECT @LocalProdTaskID AS ID, @StorageStructureSectorID AS SectorID, @ShiftID AS ShiftID
END
GO