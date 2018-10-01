SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$       $Create date:   09.03.2017$*/
/*$Modify:     Yuriy Oleynik$       $Modify date:   10.03.2017$*/
/*$Version:    1.00$   $Decription: Запуск функции утилизировать $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncUtilize]
    @TMCID int,
    @SectorID int,
    @ProdTaskID int,
    @EmployeeID int
AS
BEGIN
    SET XACT_ABORT ON
    SET NOCOUNT ON;
    DECLARE @DocID int, @Err Int
    DECLARE @t TABLE(ID int)

    BEGIN TRAN
    BEGIN TRY        
        /*Выполняем создание документа и его деталей*/
        INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, EmployeeToID,
            StorageStructureSectorID, ProductionTasksOperTypeID)
        OUTPUT INSERTED.ID INTO @t
        SELECT @ProdTaskID, @EmployeeID, @SectorID, 10 /*утилизировано*/

        SELECT @DocID = ID FROM @t
        DELETE FROM @t

        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
            StatusID, ProductionTasksDocsID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)      
        SELECT pta.TMCID, pta.ProductionCardCustomizeID, pta.Amount, pta.[Name], 1,
        	6, @DocID, pta.isMajorTMC, pta.ProductionTasksStatusID, pta.ProductionCardCustomizeID  
        FROM manufacture.vw_ProductionTasksAgregation_Select pta
        WHERE pta.TMCID = @TMCID AND pta.ProductionTasksStatusID = 3 AND pta.ProductionTasksID = @ProdTaskID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO