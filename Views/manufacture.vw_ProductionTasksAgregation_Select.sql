SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Modify:     Anatoliy Zapadinskiy$    $Create date:   04.08.2016$*/
/*$Modify:     Anatoliy Zapadinskiy$    $Modify date:   14.03.2017$*/
/*$Version:    1.00$   $Description:$Выбор агрегированных данных по сменным заданиям*/
CREATE VIEW [manufacture].[vw_ProductionTasksAgregation_Select]
AS
SELECT pcc.Name as ProductionCardCustomizeName,
       pcc.Number,
       tmc.Name,
       pts.Name as StatusName,
       IsNull(u.[Name],'шт.') as UnitName,
       t.ProductionTasksID, 
       t.TMCID, 
       t.StatusID as ProductionTasksStatusID, 
       t.ProductionCardCustomizeID, 
       t.isMajorTMC,
       t.Amount,
       t.ConfirmStatus,
       NULL AS JobStageID
FROM (
      SELECT ProductionTasksID, TMCID, StatusID, ProductionCardCustomizeID, isMajorTMC, CAST(SUM(MoveTypeID * Amount) as decimal(38, 10)) as Amount, ConfirmStatus
      FROM
          (/*Data from documents*/
           SELECT ptd.ProductionTasksID as ProductionTasksID, ptdd.TMCID, ptdd.StatusID, ptdd.ProductionCardCustomizeID, CAST(ptdd.MoveTypeID as float) as MoveTypeID,
                ptdd.Amount, ptdd.isMajorTMC, IsNull(ptd.ConfirmStatus,1) as ConfirmStatus
           FROM manufacture.ProductionTasksDocDetails ptdd 
                LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
           WHERE (ptd.ConfirmStatus = 1 OR IsNull(ptd.ConfirmStatus,0) = 0)
           UNION ALL      
           /*ADD corrections to production, nonconformance and write-offs*/
           SELECT pt.id, ptdd.TMCID, ptdd.StatusFromID as StatusID, ptdd.ProductionCardCustomizeFromID as ProductionCardCustomizeID, CAST(-1 as float) as MoveTypeID,                        
                ptdd.Amount, ptdd.isMajorTMC, 1
           FROM manufacture.ProductionTasksDocDetails ptdd
                LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
                LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID 
           WHERE (ptd.ProductionTasksOperTypeID IN (4,5,6,8,10))
                  /*ADD additional minus for previous status to MajorTMC*/
                  OR (ptdd.isMajorTMC = 1 AND ptd.ProductionTasksOperTypeID IN (2) AND ptdd.StatusID = 2)
                  OR (ptdd.isMajorTMC = 0 AND ptd.ProductionTasksOperTypeID IN (2) AND ptdd.StatusFromID is not null)
           ) a 
      GROUP BY ProductionTasksID, TMCID, StatusID, ProductionCardCustomizeID, isMajorTMC, ConfirmStatus
      ) t
     LEFT JOIN ProductionCardCustomize pcc  on pcc.ID = t.ProductionCardCustomizeID
     LEFT JOIN TMC tmc on tmc.ID = t.tmcID
     LEFT JOIN manufacture.ProductionTasksStatuses pts on pts.ID = t.StatusID
     LEFT JOIN Units u ON u.ID = tmc.UnitID
GO