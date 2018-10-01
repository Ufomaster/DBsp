SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   13.06.2017$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   12.07.2017$*/
/*$Version:    1.00$   $Decription: Внесение данных в БД$*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduceMDS_UpdateData]
    @ShiftID int,
    @EmployeeID int,
    @SectorStore_ID int,
    @SectorFail_ID int,
    @PCCID int,
    @JobStageID int
AS
BEGIN
    SET XACT_ABORT ON;
--удаляем все документы с РМ цс по CreateType = 0 тоесть все автоматы и по ЗЛ.
--Тоесть будем оформлять все в рамках ЗЛ.
    DECLARE @StorageStructureID int, @MoveProdTaskID int, @MoveSectorID int,
         @Err int, @OutputTmcID int,  @ProdTaskStatusID int, @DocID int
    DECLARE @WorkPlaces TABLE(WorkPlaceID int, SectorID int, ProdTaskID int)
    DECLARE @CurProdTasks TABLE (SectorID int, ProdTaskID int)
    DECLARE @Docs TABLE(ID int)
    DECLARE @ProductionTasksDocsIDTable TABLE (ProductionTasksDocsID int, LinkedProductionTasksDocsID int)

--    @JobStageID int = 786,
--    @ShiftID int = 4355,
--    @ShiftID int =4383,
--    @PCCID int = 12326

    --соберем все РМ
    INSERT INTO @WorkPlaces(WorkPlaceID) --может избавиться от этой таблицы?
    SELECT StorageStructureID
    FROM #TmcGroups
    GROUP BY StorageStructureID

    SELECT @ProdTaskStatusID = s.NumericValue
    FROM SystemSettings s WHERE s.ID = 9

    --НЕ проверяем сменки Склада ЦС и склада ГП цс
    -- Этап 1 - удаляем все, соберем все ДОксИд. По LinkedProductionTasksDocsID мы зацепим все документы из склдов
    DECLARE Cu1 CURSOR STATIC LOCAL FOR SELECT WorkPlaceID FROM @WorkPlaces
    OPEN CU1
    FETCH NEXT FROM Cu1 INTO @StorageStructureID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        --вернет участок и сменку. - ОТкрытие всех Сменок по ВСЕМ РМ.
        INSERT INTO @CurProdTasks(SectorID, ProdTaskID)
        EXEC manufacture.sp_ProductionTasks_SearchAndOpen @StorageStructureID, @ShiftID, @EmployeeID

        SELECT @MoveSectorID = SectorID, @MoveProdTaskID = ProdTaskID
        FROM @CurProdTasks
        
        --запишем в исходную таблицу обрабатываемых РМ айди участка.
        UPDATE @WorkPlaces
        SET SectorID = @MoveSectorID, ProdTaskID = @MoveProdTaskID
        WHERE WorkPlaceID = @StorageStructureID

        DELETE FROM @CurProdTasks

        --соберем базу обрабатываемых идентификаторов документов. дитейлы умрут по каскадному удалению потом
        INSERT INTO @ProductionTasksDocsIDTable(ProductionTasksDocsID, LinkedProductionTasksDocsID)
        SELECT dd.ProductionTasksDocsID, d.LinkedProductionTasksDocsID
        FROM manufacture.ProductionTasksDocDetails dd
        INNER JOIN manufacture.ProductionTasksDocs d ON dd.ProductionTasksDocsID = d.ID
        WHERE d.StorageStructureSectorID = @MoveSectorID AND d.ProductionTasksID = @MoveProdTaskID
            AND d.CreateType = 0 --AND dd.ProductionCardCustomizeID = @PCCID
            AND d.JobStageID = @JobStageID
        GROUP BY dd.ProductionTasksDocsID, d.LinkedProductionTasksDocsID

        FETCH NEXT FROM Cu1 INTO @StorageStructureID
    END
    CLOSE Cu1
    DEALLOCATE Cu1
    --собственно само удаление
    
/*    IF EXISTS(SELECT * FROM @WorkPlaces WHERE SectorID IS NULL OR WorkPlaceID IS NULL)    
    begin
    RAISERROR('error', 16, 1)
        RETURN
    END*/

    BEGIN TRAN
    BEGIN TRY
        --update LinkedProductionTasksDocsID = NULL документы перед удалением
        UPDATE d
        SET d.LinkedProductionTasksDocsID = NULL
        FROM manufacture.ProductionTasksDocs d
        WHERE                        d.ID IN (SELECT LinkedProductionTasksDocsID FROM @ProductionTasksDocsIDTable WHERE LinkedProductionTasksDocsID IS NOT NULL)
          OR d.LinkedProductionTasksDocsID IN (SELECT LinkedProductionTasksDocsID FROM @ProductionTasksDocsIDTable WHERE LinkedProductionTasksDocsID IS NOT NULL)
        --удаляем все
        DELETE d
        FROM manufacture.ProductionTasksDocs d
        WHERE d.ID IN (SELECT ProductionTasksDocsID FROM @ProductionTasksDocsIDTable
                       UNION
                       SELECT LinkedProductionTasksDocsID FROM @ProductionTasksDocsIDTable
                       WHERE LinkedProductionTasksDocsID IS NOT NULL)
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
        RETURN
    END CATCH

    -- Найдем сменку склада.
    DECLARE @Storage89_PTID int, @Storage90_PTID int
    
    SELECT @Storage89_PTID = pt.ID FROM manufacture.ProductionTasks pt
    WHERE pt.ShiftID = @ShiftID AND pt.StorageStructureSectorID = 89 AND pt.EndDate IS NULL
    SELECT @Storage90_PTID = pt.ID FROM manufacture.ProductionTasks pt
    WHERE pt.ShiftID = @ShiftID AND pt.StorageStructureSectorID = 90 AND pt.EndDate IS NULL
    
    IF @Storage89_PTID IS NULL
    BEGIN
        RAISERROR('Сменное задание склада "ЦС. Склад про-ва ЦС" не найдено', 16, 1)
        RETURN
    END        
    IF @Storage90_PTID IS NULL
    BEGIN
        RAISERROR('Сменное задание склада "ЦС. Склад ГП сборка" не найдено', 16, 1)
        RETURN
    END
        
    --ИТого в таблице #TmcGroups вся ГП включая её брак а так же все списания ПТМЦ + брак
    DECLARE Cu2 CURSOR STATIC LOCAL FOR
                                    SELECT a.SectorID, a.ProdTaskID, a.WorkPlaceID
                                    FROM @WorkPlaces a
    OPEN CU2
    FETCH NEXT FROM Cu2 INTO @MoveSectorID, @MoveProdTaskID, @StorageStructureID
    WHILE @@FETCH_STATUS = 0
    BEGIN
/*        BEGIN TRAN
        BEGIN TRY*/
        --Этап 2 Сoздаем перемещения со склада. 89 склад сборки с материалами.
            --1 Перемещаем со склада материалы на рМ для работы.
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
                [StorageStructureSectorID], [StorageStructureSectorToID], [ProductionTasksOperTypeID], [ConfirmStatus], 
                CreateType, JobStageID)
            OUTPUT INSERTED.ID INTO @Docs
            SELECT @Storage89_PTID, @EmployeeID,
                @SectorStore_ID, /*sectorFromID*/  @MoveSectorID, /*sectorToID*/ 3, 0, 0, @JobStageID
                --#TmcGroups(StorageStructureID int, EmployeeGroupsFactID int, Amount decimal(38, 10), StatusID int, TmcID int, DataType smallint)*/
                --DataType 0-ГП, 1-ПТМЦ, 2-НПТМЦ
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
                StatusID, ProductionTasksDocsID, EmployeeID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
            SELECT a.TmcID, CASE WHEN standart.ID IS NULL THEN @PCCID ELSE NULL END,
                SUM(a.Amount), t.[Name], -1,
                1,
                (SELECT TOP 1 ID FROM @Docs),
                @EmployeeID,
                0,
                1,
                CASE WHEN standart.ID IS NULL THEN @PCCID ELSE NULL END 
            FROM #TMCGroups a
            INNER JOIN TMC t ON t.ID = a.TmcID
            LEFT JOIN ObjectTypes standart ON standart.ID = t.ObjectTypeID AND ISNULL(standart.isStandart, 0) = 1
            WHERE a.StorageStructureID = @StorageStructureID AND a.DataType <> 0
            GROUP BY a.TmcID, t.[Name], standart.ID
            --принимаем передачу на РМ.
            EXEC manufacture.sp_ProductionTasks_FuncConfirmIncoming @MoveSectorID, @MoveProdTaskID, @EmployeeID, @JobStageID, 0

         --Этап 3  Оформляем Брак
            DELETE FROM @Docs
            IF EXISTS(SELECT TmcID FROM #TMCGroups WHERE StorageStructureID = @StorageStructureID AND DataType <> 0 AND StatusID = 4)
            BEGIN
                --создаем документы отбраковки
                --Insert header - Document
                INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
                    [StorageStructureSectorID], [StorageStructureSectorToID], [ProductionTasksOperTypeID], CreateType, JobStageID)
                OUTPUT INSERTED.ID INTO @Docs
                SELECT @MoveProdTaskID, NULL,
                   @MoveSectorID, --sectorFromID
                   @MoveSectorID, --sectorToID
                   6, --перевод в брак
                   0, -- CreateType
                   @JobStageID

                --Next Step - Insert Positions
                INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
                    StatusID, ProductionTasksDocsID, EmployeeID,
                    isMajorTMC,
                    StatusFromID, ProductionCardCustomizeFromID)
                SELECT a.TmcID, CASE WHEN standart.ID IS NULL THEN @PCCID ELSE NULL END,
                    SUM(a.Amount), t.[Name], 1,
                    3,
                    (SELECT TOP 1 ID FROM @Docs),
                    @EmployeeID,
                    0,
                    1, CASE WHEN standart.ID IS NULL THEN @PCCID ELSE NULL END
                FROM #TMCGroups a
                INNER JOIN TMC t ON t.ID = a.TmcID
                LEFT JOIN ObjectTypes standart ON standart.ID = t.ObjectTypeID AND ISNULL(standart.isStandart, 0) = 1
                WHERE a.StorageStructureID = @StorageStructureID AND a.DataType <> 0 AND a.StatusID = 4
                GROUP BY a.TmcID, t.[Name], standart.ID

                DELETE FROM @Docs
                --выполняем перемещение Брака
                INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
                    [StorageStructureSectorID], [StorageStructureSectorToID], [ProductionTasksOperTypeID], [ConfirmStatus], CreateType, JobStageID)
                OUTPUT INSERTED.ID INTO @Docs
                SELECT @MoveProdTaskID, @EmployeeID,
                   @MoveSectorID, --sectorFromID
                   @SectorFail_ID, --sectorToID
                   3, --перемещение
                   0, -- ConfirmStatus
                   0,  -- CreateType
                   @JobStageID 

                --Next Step - Insert Positions
                INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
                    StatusID, ProductionTasksDocsID, EmployeeID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
                SELECT a.TmcID, CASE WHEN standart.ID IS NULL THEN @PCCID ELSE NULL END, 
                    SUM(a.Amount), t.[Name], -1,
                    3,
                    (SELECT TOP 1 ID FROM @Docs),
                    @EmployeeID,
                    0,
                    3, CASE WHEN standart.ID IS NULL THEN @PCCID ELSE NULL END
                FROM #TMCGroups a
                INNER JOIN TMC t ON t.ID = a.TmcID
                LEFT JOIN ObjectTypes standart ON standart.ID = t.ObjectTypeID AND ISNULL(standart.isStandart, 0) = 1
                WHERE a.StorageStructureID = @StorageStructureID AND a.DataType <> 0 AND a.StatusID = 4
                GROUP BY a.TmcID, t.[Name], standart.ID

                EXEC manufacture.sp_ProductionTasks_FuncConfirmIncoming @SectorFail_ID, @Storage89_PTID, @EmployeeID, @JobStageID, 0

                DELETE FROM @Docs
            END
        --Этап 4 оформляем производство + списание материалов.

            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeToID],
                StorageStructureSectorID, ProductionTasksOperTypeID, CreateType, JobStageID)
            OUTPUT INSERTED.ID INTO @Docs
            SELECT @MoveProdTaskID, @EmployeeID, @MoveSectorID, 2, 0, @JobStageID --производство

            --Next Step - Готовая продукция и Списание материалов
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
                isMajorTMC, StatusID, ProductionTasksDocsID,
                StatusFromID, ProductionCardCustomizeFromID, EmployeeID)
            SELECT
                a.TMCID, @PCCID, SUM(a.Amount * egf.PercOfWork), t.[Name], 1,
                1,
                @ProdTaskStatusID,
                (SELECT TOP 1 ID FROM @Docs),
                1,
                @PCCID,
                de.EmployeeID
            FROM #TMCGroups a
            INNER JOIN TMC t ON t.ID = a.TmcID
            INNER JOIN (SELECT s1.EmployeeGroupsFactID as ID, 1.0/COUNT(s1.EmployeeID) as PercOfWork
                       FROM shifts.EmployeeGroupsFactDetais AS s1
                       INNER JOIN shifts.EmployeeGroupsFact f ON f.ID = s1.EmployeeGroupsFactID AND f.ShiftID = @ShiftID
                       GROUP BY s1.EmployeeGroupsFactID) AS egf on egf.ID = a.EmployeeGroupsFactID
            INNER JOIN shifts.EmployeeGroupsFact e ON e.ID = a.EmployeeGroupsFactID
            INNER JOIN shifts.EmployeeGroupsFactDetais de ON de.EmployeeGroupsFactID = e.ID
            WHERE a.StorageStructureID = @StorageStructureID AND a.StatusID = 3 AND a.DataType = 0
            GROUP BY a.TMCID, t.[Name], de.EmployeeID

            UNION ALL
            
            SELECT
                a.TMCID, @PCCID, a.Amount, t.[Name], 1,
                CASE WHEN a.DataType = 0 THEN 1 ELSE 0 END,
                CASE WHEN a.DataType = 0 THEN @ProdTaskStatusID ELSE 2 END,
                (SELECT TOP 1 ID FROM @Docs),
                1,
                CASE WHEN ot.ID IS NULL THEN @PCCID ELSE NULL END,
                det.EmployeeID
            FROM #TMCGroups a
            INNER JOIN TMC t ON t.ID = a.TmcID
            LEFT JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID AND ISNULL(ot.isStandart, 0) = 1
            LEFT JOIN shifts.EmployeeGroupsFact egf ON egf.ID = a.EmployeeGroupsFactID
            LEFT JOIN shifts.EmployeeGroupsFactDetais det ON det.EmployeeGroupsFactID = egf.ID
            WHERE a.StorageStructureID = @StorageStructureID AND a.StatusID = 3 AND a.DataType <> 0
            
        --Этап 5 перемещение ГП .
            -- в таблице @Docs остался номер документа производства. Чтобы не брать опять из #TMCGroups - возьмем срауз позиции из деталей
            SELECT TOP 1 @DocID = ID FROM @Docs
            DELETE FROM @Docs
            
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
                [StorageStructureSectorID], [StorageStructureSectorToID], [ProductionTasksOperTypeID], [ConfirmStatus], CreateType, JobStageID)
            OUTPUT INSERTED.ID INTO @Docs
            SELECT @MoveProdTaskID, @EmployeeID,
               @MoveSectorID, --sectorFromID
               @SectorStore_ID, --sectorToID
               3, --перемещение
               0, -- ConfirmStatus
               0,  -- CreateType
               @JobStageID 

            --Next Step - Insert Positions
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
                StatusID, ProductionTasksDocsID, EmployeeID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
            SELECT ProdDet.TmcID, ProdDet.ProductionCardCustomizeID, 
                SUM(ProdDet.Amount), ProdDet.[Name], -1,
                ProdDet.StatusID,
                (SELECT TOP 1 ID FROM @Docs),
                @EmployeeID,
                ProdDet.isMajorTMC,
                ProdDet.StatusID,
                ProdDet.ProductionCardCustomizeID
            FROM manufacture.ProductionTasksDocDetails ProdDet
            WHERE ProdDet.ProductionTasksDocsID = @DocID AND ProdDet.isMajorTMC = 1
            GROUP BY ProdDet.TmcID, ProdDet.ProductionCardCustomizeID, 
                ProdDet.[Name], ProdDet.StatusID, ProdDet.isMajorTMC

            EXEC manufacture.sp_ProductionTasks_FuncConfirmIncoming @SectorStore_ID, @Storage90_PTID, @EmployeeID, @JobStageID, 0
            DELETE FROM @Docs
            
        FETCH NEXT FROM Cu2 INTO @MoveSectorID, @MoveProdTaskID, @StorageStructureID
    END
    CLOSE Cu2
    DEALLOCATE Cu2
END
GO