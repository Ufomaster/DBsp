SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    		$Create date:   01.03.2016$*/
/*$Modify:     Yuriy Oleynik$    		$Modify date:   15.06.2017$*/
/*$Version:    1.00$   $Decription: Запуск функции принять $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncConfirmIncoming]
    @SectorID int,
    @ProdTaskID int,
    @EmployeeToID int,
    @JobStageID int = NULL,
    @CreateType tinyint = NULL
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @ID int, @DocID int, @Err Int

    DECLARE Cur CURSOR LOCAL FOR SELECT d1.ID
                                 FROM manufacture.ProductionTasksDocs d1 
                                 WHERE d1.StorageStructureSectorToID = @SectorID AND d1.ConfirmStatus = 0 AND d1.LinkedProductionTasksDocsID IS NULL
    OPEN Cur
    FETCH NEXT FROM Cur INTO @ID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC manufacture.sp_ProductionTasks_FuncConfirmOneIncoming @ID, @SectorID, @ProdTaskID, @EmployeeToID, @JobStageID, @CreateType

        FETCH NEXT FROM Cur INTO @ID
    END
    CLOSE Cur
    DEALLOCATE Cur
END
GO