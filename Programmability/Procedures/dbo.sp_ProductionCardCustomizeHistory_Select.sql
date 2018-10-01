SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   13.03.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   15.11.2017$*/
/*$Version:    1.00$   $Description: Выборка истории редактирования заказных$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeHistory_Select]
    @ProductionCardCustomizeID Int
AS
BEGIN
    SET NOCOUNT ON
    SELECT
        h.*,
        e.FullName AS ModifyEmployeeName,
        st.[Name] AS StatusName,
        cust.[Name] AS CustomerName,
        dbwi.[Name] AS DBWayIncomeName,
        em.FullName AS ManEmployeeName,
        pcc.Number AS MaketName,
        po.[Name] AS PrintOrientName,
        pcag.[Name] AS AdaptingGroupName,
        pcr.[Name] AS CancelReasonName,
        ChangedPC.Number AS [ChangedPCCIDName],
        t.Name AS [TmcName],
        tc.Name AS TechnologicalCardName
    FROM dbo.ProductionCardCustomizeHistory h
    LEFT JOIN vw_Employees e ON e.ID = h.ModifyEmployeeID
    LEFT JOIN ProductionCardStatuses st ON st.ID = h.StatusID
    LEFT JOIN Customers cust ON cust.ID = h.CustomerID
    LEFT JOIN DBWayIncome dbwi ON dbwi.ID = h.DBWayIncome 
    LEFT JOIN PrintOrient po ON po.ID = h.PrintOrientID
    LEFT JOIN vw_Employees em ON em.ID = h.ManEmployeeID
    LEFT JOIN ProductionCardCustomize pcc ON pcc.ID = h.LinkProductionCardCustomizeID
    LEFT JOIN ProductionCardAdaptingGroups pcag ON pcag.ID = h.AdaptingGroupID
    LEFT JOIN ProductionCardCancelReasons pcr ON pcr.ID = h.CancelReasonID
    LEFT JOIN ProductionCardCustomize ChangedPC ON ChangedPC.ID = h.ChangedPCCID
    LEFT JOIN manufacture.TechnologicalCards tc ON tc.ID = h.TechnologicalCardID
    LEFT JOIN Tmc t ON t.ID = h.TmcID
    WHERE h.ProductionCardCustomizeID = @ProductionCardCustomizeID
    ORDER BY h.ModifyDate
END
GO