SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   10.03.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   10.03.2016$*/
/*$Version:    1.00$   $Decription: Запуск функции отмена $*/
create PROCEDURE [manufacture].[sp_ProductionTasks_FuncCancelIncoming]
    @DID int,
    @WorkplaceID int, 
    @ProdTaskID int,
    @EmployeeToID int
AS
BEGIN
    DECLARE @ID int, @DocID int, @Err Int
    BEGIN TRAN
    BEGIN TRY   
        /*проверка*/
        SELECT @ID = d1.ID
        FROM manufacture.ProductionTasksDocs d1
        WHERE d1.StorageStructureToID = @WorkplaceID AND d1.ConfirmStatus = 0 AND d1.LinkedProductionTasksDocsID IS NULL AND d1.ID = @DID
        
        /*апдейтим линк и конфирм статус и удаляем текущий докум.*/
        UPDATE a
        SET a.ConfirmStatus = 2, a.LinkedProductionTasksDocsID = NULL, a.EmployeeToID = NULL
        FROM manufacture.ProductionTasksDocs a
        WHERE a.ID = @ID
/*        WHERE a.LinkedProductionTasksDocsID = @ID*/
        
/*        DELETE a
        FROM manufacture.ProductionTasksDocDetails a
        INNER JOIN manufacture.ProductionTasksDocs d ON a.ProductionTasksDocsID = d.ID
        WHERE a.ProductionTasksDocsID = @ID

        DELETE d
        FROM manufacture.ProductionTasksDocs d
        WHERE d.ID = @ID      */  

        COMMIT TRAN      
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH     
END
GO