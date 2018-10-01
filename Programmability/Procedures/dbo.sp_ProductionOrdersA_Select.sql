SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   16.08.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   30.08.2013$*/
/*$Version:    1.00$   $Description: выборка ЗЛ для печати внутрихолдинговых спецификаций$*/
create PROCEDURE [dbo].[sp_ProductionOrdersA_Select]
    @StartDate Datetime,
    @EndDate Datetime,
    @Type int
AS
BEGIN
    DECLARE @Count int

    SELECT
       @Count = COUNT(popc.ProductionCardCustomizeID)
    FROM ProductionOrders o
    INNER JOIN ProductionOrdersProdCardCustomize popc ON popc.ProductionOrdersID = o.ID
    INNER JOIN ProductionCardCustomize pc on pc.ID = popc.ProductionCardCustomizeID
    INNER JOIN ProductionCardTypes t ON t.ProductionCardPropertiesID = pc.TypeID
    WHERE o.CreateDate BETWEEN ISNULL(@StartDate, o.CreateDate) AND ISNULL(@EndDate, o.CreateDate)
        AND pc.StatusID IN (4, 5)
        AND (
             (@Type <> 4 AND t.ID = @Type AND NOT EXISTS(SELECT ID FROM ProductionCardCustomizeDetails dpc WHERE dpc.LinkedProductionCardCustomizeID = pc.ID))
             OR
             (@Type = 4 AND t.ID = @Type AND EXISTS(SELECT ID FROM ProductionCardCustomizeDetails dpc WHERE dpc.ProductionCardCustomizeID = pc.ID))
            ) 

    SELECT
        o.ID,
        @Count * CASE @Type WHEN 4 THEN 3*2 ELSE 3 END AS [CountPages], --если сборка то в среднем 3 ЗЛ по 2 листа на сборку.
        @Count AS [CountOrders]
    FROM ProductionOrders o
    INNER JOIN ProductionOrdersProdCardCustomize popc ON popc.ProductionOrdersID = o.ID
    INNER JOIN ProductionCardCustomize pc on pc.ID = popc.ProductionCardCustomizeID
    INNER JOIN ProductionCardTypes t ON t.ProductionCardPropertiesID = pc.TypeID
    WHERE o.CreateDate BETWEEN ISNULL(@StartDate, o.CreateDate) AND ISNULL(@EndDate, o.CreateDate)
        AND pc.StatusID IN (4, 5)
        AND (
             (@Type <> 4 AND t.ID = @Type AND NOT EXISTS(SELECT ID FROM ProductionCardCustomizeDetails dpc WHERE dpc.LinkedProductionCardCustomizeID = pc.ID))
             OR
             (@Type = 4 AND t.ID = @Type AND EXISTS(SELECT ID FROM ProductionCardCustomizeDetails dpc WHERE dpc.ProductionCardCustomizeID = pc.ID))
            )
    GROUP BY o.ID, o.CreateDate
    ORDER BY o.CreateDate
END
GO