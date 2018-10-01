SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   02.12.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   15.03.2016$*/
/*$Version:    1.00$   $Description: Выборка заявок на перевозки$*/
CREATE PROCEDURE [dbo].[sp_ShipmentRequests_Select]
    @StartDate datetime = NULL,
    @EndDate datetime = NULL
AS
BEGIN
    SELECT
        dbo.fn_DateToStringCompareNow(ISNULL(sr.DeliveryDate, ISNULL(sr.ReadyDate, sr.CreateDate))) AS PlanDateTextID,
        dbo.fn_ContactToString(sr.ContactID) AS ContactAsText,
        dbo.fn_ContactToString(sr.SenderContactID) AS SenderContactAsText,        
        pt.[Name] AS PayerName,
        ok.[Name] AS OperationKind,
        e.FullName,
        c.[Name] AS SenderCustomerName,
        c1.[Name] AS CustomerName,
        c2.[Name] AS DeliveryCustomerName,
        c3.[Name] AS Customer3Name,        
        CASE 
            WHEN o.MaxWeight <= 100 THEN 'до 100 кг' 
            WHEN o.MaxWeight > 100 THEN 'свыше 100 кг'
        ELSE '' END AS MaxWeightText,
        sr.*
    FROM ShipmentRequests sr
    LEFT JOIN Customers c ON c.ID = sr.SenderCustomerID
    LEFT JOIN Customers c1 ON c1.ID = sr.CustomerID    
    LEFT JOIN Customers c2 ON c2.ID = sr.DeliveryCustomerID
    LEFT JOIN Customers c3 ON c3.ID = sr.Customer3ID
    LEFT JOIN dbo.vw_PayersTypes pt ON pt.ID = sr.Payer
    LEFT JOIN dbo.vw_ShipmentRequestsOperationKind ok ON ok.ID = sr.OperationKind    
    LEFT JOIN vw_Employees e ON e.ID = sr.EmployeeID
    LEFT JOIN (SELECT SUM(v.[Weight]) AS MaxWeight, v.ShipmentRequestID FROM ShipmentRequestsDetails v GROUP BY v.ShipmentRequestID) AS o ON o.ShipmentRequestID = sr.ID
    WHERE
        (sr.CreateDate BETWEEN ISNULL(@StartDate, sr.CreateDate) AND ISNULL(@EndDate, sr.CreateDate))
        OR
        (sr.DeliveryDate BETWEEN ISNULL(@StartDate, sr.DeliveryDate) AND ISNULL(@EndDate, sr.DeliveryDate))
    ORDER BY sr.CreateDate-- DESC
END
GO