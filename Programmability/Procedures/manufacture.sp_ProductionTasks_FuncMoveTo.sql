SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   11.03.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   23.10.2017$*/
/*$Version:    1.00$   $Decription: Запуск функции переместить $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncMoveTo]
    @MoveType int, 
    @SectorFromID int, 
    @SectorToID int,     
    @ProdTaskID int,
    @EmployeeID int
AS
BEGIN
    DECLARE @ID int, @DocID int, @Err Int
    DECLARE @t TABLE(ID int)
--не проверяем складское ли это перемещение, для склада не может быть установлена настройка StatusDegradationEnabled
--посколько склад скукожится. это отследивается логикой и интерфейсом.
    SET XACT_ABORT ON;
    BEGIN TRAN
    BEGIN TRY
        IF @MoveType = 0
        BEGIN
            IF OBJECT_ID('tempdb..#ProdTaskShipData') IS NOT NULL
                TRUNCATE TABLE #ProdTaskShipData ELSE
            CREATE TABLE #ProdTaskShipData(ID int IDENTITY(1,1), Number varchar(10), TMCID int, MaxAmount decimal(38, 10), Amount decimal(38, 10), 
                Name varchar(255), StatusID int, StatusName varchar(255), ProductionCardCustomizeID int, isMajorTMC bit, StatusFromID int)

            INSERT INTO #ProdTaskShipData(Number, TMCID, MaxAmount, Amount, 
                Name, StatusID, StatusName, ProductionCardCustomizeID, isMajorTMC, StatusFromID)                
            SELECT '', a.TMCID, 0, a.Amount, 
               a.Name, a.StatusID, '', a.ProductionCardCustomizeID, a.isMajorTMC, a.StatusFromID
            FROM #ProdTaskMoveData a
            
            EXEC manufacture.sp_ProductionTasks_FuncShip 1, @SectorFromID, @ProdTaskID, @EmployeeID
            
            DROP TABLE #ProdTaskShipData
        END
        ELSE
        IF @MoveType = 1
        BEGIN
            /*Insert header - Document*/
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
                [StorageStructureSectorID], [StorageStructureSectorToID], [ProductionTasksOperTypeID], [ConfirmStatus])
            OUTPUT INSERTED.ID INTO @t
            SELECT @ProdTaskID, @EmployeeID, @SectorFromID, @SectorToID, 3/*перемещение*/, 0
            SELECT @DocID = ID FROM @t

            /*Next Step - Insert Position*/
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
                StatusID, ProductionTasksDocsID, EmployeeID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
            SELECT a.TMCID, a.ProductionCardCustomizeID, a.Amount, a.Name, -1,
                a.StatusID, @DocID, NULL, a.isMajorTMC, a.StatusFromID, a.ProductionCardCustomizeID
            FROM #ProdTaskMoveData a

        END
        ELSE
        IF @MoveType = 2 --отгрузка с текущего участка + добавление этого же ТМЦ на другом участке но в работе и не мейждор.
        BEGIN
            DECLARE @CurProdTasks TABLE (SectorID int, ProdTaskID int)
            DECLARE @StorageStructureID int, @ShiftID int, @NextProdTaskID int
            SELECT @StorageStructureID = sd.StorageStructureID
            FROM manufacture.StorageStructureSectorsDetails sd
            WHERE sd.StorageStructureSectorID = @SectorToID
            
            SELECT TOP 1 @ShiftID = sh.ID
            FROM manufacture.StorageStructureSectors s
            INNER JOIN shifts.ShiftsTypes st ON st.ShiftsGroupsID = s.ShiftsGroupsID
            INNER JOIN shifts.Shifts sh ON sh.ShiftTypeID = st.ID
            WHERE s.ID = @SectorToID AND ISNULL(sh.IsDeleted, 0) = 0 AND sh.FactStartDate IS NOT NULL AND sh.FactEndDate IS NULL
            ORDER BY s.ID DESC 

            IF @ShiftID IS NULL
            BEGIN
                RAISERROR ('Смена не найдена', 16, 1)  
                RETURN
            END
            
            INSERT INTO @CurProdTasks(SectorID, ProdTaskID)
            EXEC manufacture.sp_ProductionTasks_SearchAndOpen @StorageStructureID, @ShiftID, @EmployeeID
            SELECT @NextProdTaskID = ProdTaskID
            FROM @CurProdTasks
            
            IF @NextProdTaskID IS NULL
            BEGIN
                RAISERROR ('Ошибка запуска сменного задания', 16, 1)  
                RETURN
            END
            
            --Оформляем отгрузку
            /*Insert header - Document*/
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
                [StorageStructureSectorID], [StorageStructureSectorToID], [ProductionTasksOperTypeID])
            OUTPUT INSERTED.ID INTO @t
            SELECT @ProdTaskID, @EmployeeID, @SectorFromID, @SectorFromID, 4/*отгрузка*/
            SELECT @DocID = ID FROM @t

            /*Next Step - Insert Position*/
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
                StatusID, ProductionTasksDocsID, EmployeeID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
            SELECT a.TMCID, a.ProductionCardCustomizeID, a.Amount, a.Name, 1,
                5, @DocID, NULL, a.isMajorTMC, a.StatusID, a.ProductionCardCustomizeID
            FROM #ProdTaskMoveData a

            DELETE FROM @t
            
            --Оформляем прием
            /*Step - Insert Header*/
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID], [StorageStructureSectorID], [ProductionTasksOperTypeID])
            OUTPUT INSERTED.ID INTO @t
            SELECT @NextProdTaskID, @EmployeeID, @SectorToID, 1/*приход*/
            SELECT @DocID = ID FROM @t
            
            /*Next Step - Insert Position*/
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
                isMajorTMC, 
                StatusID, 
                ProductionTasksDocsID, StatusFromID, ProductionCardCustomizeFromID)
            SELECT a.TMCID, filter.ID, a.Amount, a.Name, 1, 
                0, 
                1,
                @DocID, 1, filter.ID
            FROM #ProdTaskMoveData a
            LEFT JOIN 
              (SELECT TOP 1 p.ID, td.TmcID
              FROM ProductionCardCustomize p
              INNER JOIN ProductionCardCustomizeDetails d ON d.ProductionCardCustomizeID = p.ID 
              INNER JOIN #ProdTaskMoveData td ON td.TmcID = d.TmcID
              WHERE p.StatusID NOT IN (5,6,7,9,11) AND p.TypeID = 10065
              ORDER BY p.CreateDate DESC) AS filter  ON filter.TmcID = a.TmcID
        END

        COMMIT TRAN      
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH     
END
GO