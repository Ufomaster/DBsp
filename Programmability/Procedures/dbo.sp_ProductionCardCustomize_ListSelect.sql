SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.04.2017$*/
/*$Modify:     Skliar Nataliia$    $Modify date:   06.04.2017$*/
/*$Version:    1.00$   $Description: выборка ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomize_ListSelect]
AS
BEGIN
    SELECT 
       p.Number, 
       CASE 
           WHEN p2.ID IS NOT NULL THEN p2.Number + ' (' + s.[Name] + ')'
           WHEN p2.ID IS NULL AND pct.ID = 4 THEN p.[Number]
       END AS SNumber,
       p.ID,
       p.StatusID,
       s.[Name] AS StatusName, 
       pct.ID as Type,
       p.CreateDate,
       p.CardCountInvoice,
       p.Name,
       p.SketchFileName,
       p.ManEmployeeID,
       p.DateProductionTransfer,
       c.[Name] AS CustomerName,
       e.FullName AS ManEmployeeName
    FROM ProductionCardCustomize p
    LEFT JOIN ProductionCardCustomizeDetails as l on l.LinkedProductionCardCustomizeID = p.ID
    LEFT JOIN ProductionCardCustomize p2 on p2.id = l.ProductionCardCustomizeID
    LEFT JOIN ProductionOrdersProdCardCustomize pop ON pop.ProductionCardCustomizeID = p.ID
    LEFT JOIN ProductionOrders o ON o.ID = pop.ProductionOrdersID
    LEFT JOIN Customers c ON c.ID = o.CustomerID
    LEFT JOIN vw_Employees e ON e.ID = p.ManEmployeeID
    INNER JOIN ProductionCardStatuses s ON s.ID = p.StatusID
    INNER JOIN ProductionCardTypes pct ON pct.ProductionCardPropertiesID = p.TypeID
    WHERE s.ID NOT IN (11, 6)
END
GO