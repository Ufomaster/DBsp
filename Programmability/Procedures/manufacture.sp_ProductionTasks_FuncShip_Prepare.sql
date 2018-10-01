SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.12.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   14.03.2017$*/
/*$Version:    1.00$   $Decription: Подготовка отгрузки $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncShip_Prepare]
    @ProductionTasksID int
AS
BEGIN
    INSERT INTO #ProdTaskShipDataPrepare(Number, TMCID, MaxAmount, Amount, Name, StatusID, StatusName, ProductionCardCustomizeID, isMajorTMC) 
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
         AND pta.ProductionTasksStatusID NOT IN (1,2,3,5,6)
         AND pta.Amount <> 0
    GROUP BY ProductionCardCustomizeName, Number, Name, StatusName, UnitName, ProductionTasksID, TMCID, ProductionTasksStatusID, 
             ProductionCardCustomizeID, isMajorTMC
    HAVING SUM(Amount) <> 0
END
GO