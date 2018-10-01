SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   20.12.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   02.01.2013$*/
/*$Version:    1.00$   $Description: выборка ЗЛ$*/
create PROCEDURE [dbo].[sp_ProductionOrders_Select]
    @StartDate Datetime,
    @EndDate Datetime,
    @TypeID Int
AS
BEGIN
    SELECT
        o.*,
        a.Number + ' від ' + dbo.fn_DateToString(a.[Date], 'ddmmyyyy') AS AgreementName
    FROM ProductionOrders o
    LEFT JOIN Agreements a ON a.ID = o.AgreementID    
    WHERE o.CreateDate BETWEEN ISNULL(@StartDate, o.CreateDate) AND ISNULL(@EndDate, o.CreateDate)
    AND (@TypeID = -1 OR
         o.ID IN (SELECT poc.ProductionOrdersID
                  FROM ProductionOrdersProdCardCustomize poc
                  INNER JOIN ProductionCardCustomize pc ON pc.ID = poc.ProductionCardCustomizeID
                  WHERE pc.TypeID = @TypeID
                  GROUP BY poc.ProductionOrdersID)
         )
    ORDER BY o.CreateDate
END
GO