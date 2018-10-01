SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   03.08.2016$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   10.08.2016$*/
/*$Version:    1.00$   $Decription: Остановка сменного задания$*/
create PROCEDURE [manufacture].[sp_ProductionTasks_Stop]
    @ProdTaskID int
AS
BEGIN
    SET NOCOUNT ON
    
    IF (SELECT count(*)
        FROM manufacture.vw_ProductionTasksAgregation_Select pta
        WHERE pta.ProductionTasksID = @ProdTaskID
              AND pta.ConfirmStatus = 0) > 0
    BEGIN            
        RAISERROR ('По данному сменному заданию есть незавершенные перемещения. Подтвердите или отмените их.', 16, 1)        
    END 
 
    IF EXISTS(SELECT *
              FROM manufacture.ProductionTasks pt
              WHERE pt.ID = @ProdTaskID AND pt.StartDate is not null AND pt.EndDate is null)    
    BEGIN
    	UPDATE manufacture.ProductionTasks
        SET EndDate = GETDATE()
        WHERE ID = @ProdTaskID AND StartDate is not null AND EndDate is null
    END          
END
GO