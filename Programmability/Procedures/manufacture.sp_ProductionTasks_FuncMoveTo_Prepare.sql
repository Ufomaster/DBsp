SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   11.03.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   16.06.2017$*/
/*$Version:    1.00$   $Decription: Подготовка перемещения $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncMoveTo_Prepare]
    @ProductionTasksID int,
    @MoveToStorage bit
AS
BEGIN
    INSERT INTO #ProdTaskMoveDataPrepare(Number, TMCID, MaxAmount, Amount, Name, StatusID, StatusName, ProductionCardCustomizeID, isMajorTMC) 
	SELECT  
           Number,
           TMCID,                
           SUM(Amount) as MaxAmount,
           SUM(Amount) as Amount,
           Name,
           ProductionTasksStatusID,
           StatusName,
           ProductionCardCustomizeID, 
           isMajorTMC
    FROM manufacture.vw_ProductionTasksAgregation_Select pta             
    WHERE pta.ProductionTasksID = @ProductionTasksID
         AND (((pta.ProductionTasksStatusID IN (1,3,4) OR pta.ProductionTasksStatusID > 6) AND @MoveToStorage = 1) OR 
               (pta.ProductionTasksStatusID > 6 OR pta.ProductionTasksStatusID = 4 AND @MoveToStorage = 0)) 
         AND pta.Amount <> 0
--         AND pta.isMajorTMC = 1
    GROUP BY ProductionCardCustomizeName, Number, Name, StatusName, UnitName, ProductionTasksID, TMCID, ProductionTasksStatusID, 
             ProductionCardCustomizeID, isMajorTMC
    HAVING SUM(Amount) <> 0
END
GO