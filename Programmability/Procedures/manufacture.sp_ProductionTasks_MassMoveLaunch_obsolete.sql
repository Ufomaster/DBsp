SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   03.11.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   23.12.2016$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [manufacture].[sp_ProductionTasks_MassMoveLaunch_obsolete]
    @ProdTaskID int, --сменка склада. не провеяем ей состояние.
    @JobStageID int,
    @StorageSSID int,
    @EmployeeID int
AS    
BEGIN
	SET NOCOUNT ON;
    
--    EXEC manufacture.sp_ProductionTasks_MassMovePrepare @ProdTaskID, @JobStageID
    
    --Поиск Сменок по @MoveStorageStructureID и создание в них документов на перемещение.
    DECLARE @MoveStorageStructureID int, @MoveSectorID int, @MoveProdTaskID int, @ShiftID int, 
      @ProdEndDate datetime, @ProdStartDate datetime, @StorageSectorID int
    DECLARE @Docs TABLE(ID int, SectorID int, StorageStructureID int)         
    
    SELECT @StorageSectorID = manufacture.fn_GetSectorID_JobStageID_SSID (@JobStageID, @StorageSSID)
    IF @StorageSectorID IS NULL
        RETURN    

    DECLARE CurSectorsIncome CURSOR STATIC LOCAL FOR
                                            SELECT SSID
                                            FROM #DetailRes
                                            WHERE AmountNeeded < 0 --минусовые - это те которые надо будет принять на рм со склада нач смены.
                                            GROUP BY SSID
    OPEN CurSectorsIncome
    FETCH NEXT FROM CurSectorsIncome INTO @MoveStorageStructureID
    WHILE @@FETCH_STATUS=0
    BEGIN
        --поиск сектора
        SELECT @MoveSectorID = manufacture.fn_GetSectorID_JobStageID_SSID (@JobStageID, @MoveStorageStructureID)
        IF @MoveSectorID IS NULL
            CONTINUE
            
        --поиск смены
--        SELECT @ShiftID = manufacture.fn_GetActiveShiftID_JobStageID(@JobStageID, @MoveSectorID)    
        SELECT @ShiftID = manufacture.fn_GetActiveShiftID(@MoveStorageStructureID)    
        IF @ShiftID IS NULL
            CONTINUE
            
        --поиск сменки
        SELECT @MoveProdTaskID = pt.ID, @ProdEndDate = pt.EndDate, @ProdStartDate = pt.StartDate
        FROM manufacture.ProductionTasks pt
        WHERE pt.ShiftID = @ShiftID AND pt.StorageStructureSectorID = @MoveSectorID
        
        --провека создать новую или переоткрыть сменку.
        IF @MoveProdTaskID IS NOT NULL AND @ProdEndDate IS NOT NULL AND @ProdStartDate IS NOT NULL
        BEGIN
            UPDATE manufacture.ProductionTasks
            SET EndDate = GetDate(), CreateType = 2
            WHERE StorageStructureSectorID = @MoveSectorID AND EndDate IS NULL AND StartDate IS NOT NULL
               AND ShiftID <> @ShiftID
                   
            UPDATE manufacture.ProductionTasks
            SET EndDate = NULL, CreateType = 2
            WHERE ID = @MoveProdTaskID
        END
        ELSE
        IF @MoveProdTaskID IS NULL
        BEGIN
            UPDATE manufacture.ProductionTasks
            SET EndDate = GetDate(), CreateType = 2
            WHERE ShiftID <> @ShiftID AND StorageStructureSectorID = @MoveSectorID AND EndDate IS NULL AND StartDate IS NOT NULL
                                
            INSERT INTO manufacture.ProductionTasks(CreateDate, StorageStructureSectorID, ShiftID, StartDate, CreateType)
            SELECT GetDate(), @MoveSectorID, @ShiftID, GetDate(), 1

            SELECT TOP 1 @MoveProdTaskID =  ID FROM manufacture.ProductionTasks
            WHERE StorageStructureSectorID = @MoveSectorID AND ShiftID = @ShiftID AND EndDate IS NULL
            ORDER BY ID DESC
            --при создании новой - конфирмим остатки
            EXEC manufacture.sp_ProductionTasks_FuncConfirmRemains @MoveSectorID, @MoveProdTaskID, @EmployeeID, @JobStageID, 0
        END
        --создаем документы перемещения
        DELETE FROM @Docs
        /*Insert header - Document*/
        INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
            [StorageStructureSectorID], [StorageStructureSectorToID], [ProductionTasksOperTypeID], [ConfirmStatus], CreateType)
        OUTPUT INSERTED.ID, INSERTED.StorageStructureSectorID, @MoveSectorID INTO @Docs
        SELECT @ProdTaskID, @EmployeeID,
           @StorageSectorID, --sectorFromID
           @MoveSectorID, --sectorToID
           3 --перемещение
           ,
           0,
           0

        --@Docs содержит данные: соданный документ + сектор откуда идет перемещение.                    
                    
        /*Next Step - Insert Position*/
        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
            StatusID, ProductionTasksDocsID, EmployeeID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
        SELECT a.TmcID, NULL, ABS(a.AmountNeeded), a.TmcName, -1,
            1,
            (SELECT TOP 1 ID FROM @Docs),
            @EmployeeID,
            0, --isMajorTMC
            NULL,
            NULL
        FROM #DetailRes a
        WHERE a.SSID = @MoveStorageStructureID AND AmountNeeded < 0

        EXEC manufacture.sp_ProductionTasks_FuncConfirmIncoming @MoveSectorID, @MoveProdTaskID, @EmployeeID, 0
        
        SELECT @MoveSectorID = NULL, @ShiftID = NULL, @MoveProdTaskID = NULL, @ProdEndDate = NULL, @ProdStartDate = NULL
        FETCH NEXT FROM CurSectorsIncome INTO @MoveStorageStructureID
    END
    CLOSE CurSectorsIncome
    DEALLOCATE CurSectorsIncome

    --Изъятие лишних материалов НПТМЦ обратно на склад.    
    DECLARE CurSectorsOutgo CURSOR STATIC LOCAL FOR
                                            SELECT SSID
                                            FROM #DetailRes
                                            WHERE AmountNeeded > 0 --плюсовые, те которые нужно вернуть на склад.
                                            GROUP BY SSID
    OPEN CurSectorsOutgo
    FETCH NEXT FROM CurSectorsOutgo INTO @MoveStorageStructureID
    WHILE @@FETCH_STATUS=0
    BEGIN
        --поиск сектора
        SELECT @MoveSectorID = manufacture.fn_GetSectorID_JobStageID_SSID (@JobStageID, @MoveStorageStructureID)
        IF @MoveSectorID IS NULL
            CONTINUE
            
        --поиск смены
        --SELECT @ShiftID = manufacture.fn_GetActiveShiftID_JobStageID(@JobStageID, @MoveSectorID)    
        SELECT @ShiftID = manufacture.fn_GetActiveShiftID(@MoveStorageStructureID)        
        IF @ShiftID IS NULL
            CONTINUE
            
        --поиск сменки
        SELECT @MoveProdTaskID = pt.ID, @ProdEndDate = pt.EndDate, @ProdStartDate = pt.StartDate
        FROM manufacture.ProductionTasks pt
        WHERE pt.ShiftID = @ShiftID AND pt.StorageStructureSectorID = @MoveSectorID
        
        --провека создать новую или переоткрыть сменку.
        IF @MoveProdTaskID IS NOT NULL AND @ProdEndDate IS NOT NULL AND @ProdStartDate IS NOT NULL
        BEGIN
            UPDATE manufacture.ProductionTasks
            SET EndDate = GetDate(), CreateType = 2
            WHERE StorageStructureSectorID = @MoveSectorID AND EndDate IS NULL AND StartDate IS NOT NULL
               AND ShiftID <> @ShiftID
               
            UPDATE manufacture.ProductionTasks
            SET EndDate = NULL, CreateType = 2
            WHERE ID = @MoveProdTaskID
        END
        ELSE
        IF @MoveProdTaskID IS NULL
        BEGIN
            UPDATE manufacture.ProductionTasks
            SET EndDate = GetDate(), CreateType = 2
            WHERE ShiftID <> @ShiftID AND StorageStructureSectorID = @MoveSectorID AND EndDate IS NULL AND StartDate IS NOT NULL
                    
            INSERT INTO manufacture.ProductionTasks(CreateDate, StorageStructureSectorID, ShiftID, StartDate, CreateType)
            SELECT GetDate(), @MoveSectorID, @ShiftID, GetDate(), 1

            SELECT TOP 1 @MoveProdTaskID =  ID FROM manufacture.ProductionTasks
            WHERE StorageStructureSectorID = @MoveSectorID AND ShiftID = @ShiftID AND EndDate IS NULL
            ORDER BY ID DESC
            --при создании новой - конфирмим остатки
            EXEC manufacture.sp_ProductionTasks_FuncConfirmRemains @MoveSectorID, @MoveProdTaskID, @EmployeeID, @JobStageID, 0
        END
        --создаем документы перемещения
        DELETE FROM @Docs
        /*Insert header - Document*/
        INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
            [StorageStructureSectorID], [StorageStructureSectorToID], [ProductionTasksOperTypeID], [ConfirmStatus], CreateType)
/**/      OUTPUT INSERTED.ID, INSERTED.StorageStructureSectorID, @StorageSectorID INTO @Docs
/**/        SELECT @MoveProdTaskID, @EmployeeID,
/**/           @MoveSectorID, --sectorFromID
/**/           @StorageSectorID, --sectorToID
           3 --перемещение
           ,
           0,
           0

        --@Docs содержит данные: соданный документ + сектор откуда идет перемещение.                    
                    
        /*Next Step - Insert Position*/
        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
            StatusID, ProductionTasksDocsID, EmployeeID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
        SELECT a.TmcID, NULL, ABS(a.AmountNeeded), a.TmcName, -1,
            1,
            (SELECT TOP 1 ID FROM @Docs),
            @EmployeeID,
            0, --isMajorTMC
            NULL,
            NULL
        FROM #DetailRes a
/**/        WHERE a.SSID = @MoveStorageStructureID AND AmountNeeded > 0

/**/        EXEC manufacture.sp_ProductionTasks_FuncConfirmIncoming @StorageSectorID, @ProdTaskID, @EmployeeID, 0
        
        SELECT @MoveSectorID = NULL, @ShiftID = NULL, @MoveProdTaskID = NULL, @ProdEndDate = NULL, @ProdStartDate = NULL
        FETCH NEXT FROM CurSectorsOutgo INTO @MoveStorageStructureID
    END
    CLOSE CurSectorsOutgo
    DEALLOCATE CurSectorsOutgo
END
GO