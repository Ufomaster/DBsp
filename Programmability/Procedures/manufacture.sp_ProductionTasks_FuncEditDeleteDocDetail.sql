SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   10.03.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   12.03.2016$*/
/*$Version:    1.00$   $Decription: Редактирование документа. Удаление позиции документа $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncEditDeleteDocDetail]
    @DetailID int,
    @WorkplaceID int,
    @ProdTaskID int,
    @EmployeeToID int
AS
BEGIN
    DECLARE @Err Int
    DECLARE @DocID int
    
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT @DocID = a.ProductionTasksDocsID
        FROM manufacture.ProductionTasksDocDetails a
        WHERE a.ID = @DetailID
        
        DELETE a
        FROM manufacture.ProductionTasksDocDetails a
        INNER JOIN manufacture.ProductionTasksDocs d ON a.ProductionTasksDocsID = d.ID
        WHERE a.ID = @DetailID AND d.LinkedProductionTasksDocsID IS NULL AND 
            ((d.ProductionTasksOperTypeID <> 3) OR 
             (d.ProductionTasksOperTypeID = 3 and d.ConfirmStatus <> 1)
            )
        
        IF NOT EXISTS(
            SELECT a.*
            FROM manufacture.ProductionTasksDocDetails a
            INNER JOIN manufacture.ProductionTasksDocs d ON a.ProductionTasksDocsID = d.ID
            WHERE a.ProductionTasksDocsID = @DocID AND d.LinkedProductionTasksDocsID IS NULL AND 
            ((d.ProductionTasksOperTypeID <> 3) OR 
             (d.ProductionTasksOperTypeID = 3 and d.ConfirmStatus <> 1)
            )        )

        DELETE d
        FROM manufacture.ProductionTasksDocs d
        WHERE d.ID = @DocID AND d.LinkedProductionTasksDocsID IS NULL AND 
            ((d.ProductionTasksOperTypeID <> 3) OR 
             (d.ProductionTasksOperTypeID = 3 and d.ConfirmStatus <> 1)
            )   
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
    END CATCH
END
GO