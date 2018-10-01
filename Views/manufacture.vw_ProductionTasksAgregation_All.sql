SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Modify:     Oleksii Poliatykin$    $Create date:   21.09.2017$*/
/*$Modify:     Oleksii Poliatykin$    $Modify date:   26.09.2017$*/
/*$Version:    1.00$   $Description:$Выбор агрегированных данных по сменным заданиям*/
CREATE VIEW [manufacture].[vw_ProductionTasksAgregation_All]
AS
    SELECT
        pt.ShiftID,
        ptdd.TMCID, 
        ptd.ProductionTasksOperTypeID,
        ptdd.StatusID,
        ptdd.StatusFromID,
        ptdd.ProductionCardCustomizeID,
        ptdd.isMajorTMC,
        tmc.Name,
        sum(ptdd.Amount) as Amount,
        ptot.Name as OperType,
        ptsFrom.Name as StatusFrom,
        ptsTo.Name as StatusTo,
        case when sss.IsCS = 1 then 1 
             when sss.id = 89  then 2 
             when sss.id = 90  then 3 
             when sss.id = 92  then 4 
             else 5 
        end as Plase,
        min(ptd.ID) as Sort

    FROM   manufacture.ProductionTasksDocDetails ptdd
        LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID 
        LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = pt.StorageStructureSectorID
        LEFT JOIN manufacture.ProductionTasksStatuses ptsTo on ptsTo.ID = ptdd.StatusID
        LEFT JOIN manufacture.ProductionTasksStatuses ptsFrom on ptsFrom.ID = ptdd.StatusFromID
        LEFT JOIN manufacture.ProductionTasksOperationTypes ptot on ptot.id = ptd.ProductionTasksOperTypeID
        LEFT JOIN TMC tmc on tmc.ID = ptdd.TMCID

    GROUP BY 
        pt.ShiftID,
        ptdd.TMCID,
        ptd.ProductionTasksOperTypeID,
        ptdd.StatusID,
        ptdd.StatusFromID,
        ptd.ProductionTasksOperTypeID,
        ptdd.ProductionCardCustomizeID,
        ptdd.isMajorTMC,
        tmc.Name,
        ptot.name,
        ptsFrom.Name,
        ptsTo.Name,
        case when sss.IsCS = 1 then 1 
             when sss.id = 89  then 2 
             when sss.id = 90  then 3 
             when sss.id = 92  then 4 
             else 5 
        end
GO