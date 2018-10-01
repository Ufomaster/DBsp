SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.12.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   27.12.2016$*/
/*$Version:    1.00$   $Decription: Запуск функции отгрузить $*/
create PROCEDURE [manufacture].[sp_ProductionTasks_FuncShip]
    @MoveType bit, 
    @SectorFromID int,   
    @ProdTaskID int,
    @EmployeeID int
AS
BEGIN
    DECLARE @ID int, @DocID int, @Err Int
    DECLARE @t TABLE(ID int)

    SET XACT_ABORT ON;    
    BEGIN TRAN
    BEGIN TRY    
        IF @MoveType = 1  /*перемещаем между РМ или передаем на тоже РМ*/
        BEGIN
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
            FROM #ProdTaskShipData a
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