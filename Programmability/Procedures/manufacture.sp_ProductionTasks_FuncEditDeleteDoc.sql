SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    		$Create date:   10.03.2016$*/
/*$Modify:     Anatoliy Zapadinskiy$    $Modify date:   27.02.2017$*/
/*$Version:    1.00$   $Decription: Редактирование документа. Удаление всего документа $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncEditDeleteDoc]
    @DocID int,
    @WorkplaceID int,
    @ProdTaskID int,
    @EmployeeToID int,
    @CheckMax bit = 1
AS
BEGIN
    DECLARE @Err Int, @MAXID int, @LinkedProductionTasksDocsID int
    
    IF @CheckMax = 1
    BEGIN
        SELECT @MAXID = MAX(ID) FROM manufacture.ProductionTasksDocs z WHERE z.ProductionTasksID = @ProdTaskID 
        IF @MAXID <> @DocID
            RETURN
    END
    
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT @LinkedProductionTasksDocsID = LinkedProductionTasksDocsID
        FROM ProductionTasksDocs
        WHERE ID = @DocID

        EXEC manufacture.sp_ProductionTasksDocsHistory_Insert @EmployeeToID, @DocID, 2
        IF @LinkedProductionTasksDocsID IS NOT NULL 
        BEGIN
            EXEC manufacture.sp_ProductionTasksDocsHistory_Insert @EmployeeToID, @LinkedProductionTasksDocsID, 2        

            UPDATE ProductionTasksDocs
            SET LinkedProductionTasksDocsID = NULL
            WHERE ID = @DocID OR ID = @LinkedProductionTasksDocsID
            
            DELETE d
            FROM manufacture.ProductionTasksDocs d
            WHERE d.ID = @LinkedProductionTasksDocsID            
        END

        DELETE a
        FROM manufacture.ProductionTasksDocDetails a
             INNER JOIN manufacture.ProductionTasksDocs d ON a.ProductionTasksDocsID = d.ID
        WHERE a.ProductionTasksDocsID = @DocID

        DELETE d
        FROM manufacture.ProductionTasksDocs d
        WHERE d.ID = @DocID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
    END CATCH
END
GO