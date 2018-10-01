SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.07.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   06.07.2015$*/
/*$Version:    1.00$   $Description: Подготовка редактирования ZL*/
create PROCEDURE [QualityControl].[sp_ActsZLs_PrepareTmp]
    @ID Int
AS
BEGIN
    INSERT INTO #ActsZL(_ID, PCCID, Number, Name, CustomerName)
    SELECT
        d.ID, d.PCCID, pc.Number, pc.[Name], c.[Name]
    FROM QualityControl.ActsZL d
    INNER JOIN dbo.ProductionCardCustomize PC ON pc.ID = d.PCCID
    INNER JOIN dbo.ProductionOrdersProdCardCustomize pco ON pco.ProductionCardCustomizeID = d.PCCID
    INNER JOIN dbo.ProductionOrders o ON o.ID = pco.ProductionOrdersID
    INNER JOIN dbo.Customers c ON c.ID = o.CustomerID
    WHERE d.ActsID = @ID
    ORDER BY d.ID
END
GO