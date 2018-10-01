SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   19.05.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   19.07.2016$*/
/*$Version:    1.00$   $Decription: vw_StorageStructure*/
CREATE VIEW [manufacture].[vw_ProductionTasks_Info]
AS
    SELECT 
        otypes.[Name] AS OperationName,
        t.StorageStructureSectorID AS TaskSectorID,
        sss1.[Name] AS SectorName,
        sss2.[Name] AS SectorToName,
        pc.Number,
        emp.FullName,
        e.ID AS DocDetailID,
        d.ID AS DocID,
        t.ID AS TaskID,
        e.Amount,
        e.isMajorTMC,
        e.[Name],
        e.ProductionCardCustomizeID AS PCCID,
        st.[Name] AS StatusName,
        st.OutProdClass,
        e.StatusID,
        e.TMCID,
        e.CreateDate,
        d.LinkedProductionTasksDocsID,
        d.ConfirmStatus,
        d.CreateDate AS DocCreateDate,
        t.ShiftID AS TaskShiftID,
        e.StatusFromID,
        d.ProductionTasksOperTypeID
    FROM manufacture.ProductionTasksDocs d
    INNER JOIN manufacture.ProductionTasksDocDetails e ON e.ProductionTasksDocsID = d.ID
    INNER JOIN manufacture.ProductionTasks t ON t.ID = d.ProductionTasksID
    INNER JOIN manufacture.ProductionTasksOperationTypes otypes ON otypes.ID = d.ProductionTasksOperTypeID
    LEFT JOIN manufacture.StorageStructureSectors sss1 ON sss1.ID = d.StorageStructureSectorID
    LEFT JOIN manufacture.StorageStructureSectors sss2 ON sss2.ID = d.StorageStructureSectorToID
    LEFT JOIN manufacture.ProductionTasksStatuses st ON st.ID = e.StatusID
    LEFT JOIN ProductionCardCustomize pc ON pc.ID = e.ProductionCardCustomizeID
    LEFT JOIN vw_Employees emp ON emp.ID = e.EmployeeID
GO