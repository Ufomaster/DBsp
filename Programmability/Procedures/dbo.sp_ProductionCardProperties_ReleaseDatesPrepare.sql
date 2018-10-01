SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   17.01.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.01.2017$*/
/*$Version:    1.00$   $Decription: Готовим данные на изменение$*/
create PROCEDURE [dbo].[sp_ProductionCardProperties_ReleaseDatesPrepare]
    @ProductionCardCustomizeID Int,
    @OrderID int
AS
BEGIN
    DECLARE @SborkaID int
    --если зл включен в комплект    
    IF EXISTS(SELECT a.ID
              FROM ProductionCardCustomizeDetails a
              INNER JOIN ProductionOrdersProdCardCustomize pop ON pop.ProductionCardCustomizeID = a.ProductionCardCustomizeID AND pop.ProductionOrdersID = @OrderID
              WHERE a.LinkedProductionCardCustomizeID = @ProductionCardCustomizeID)
        SELECT @SborkaID = a.ProductionCardCustomizeID
        FROM ProductionCardCustomizeDetails a
        INNER JOIN ProductionOrdersProdCardCustomize pop ON pop.ProductionCardCustomizeID = a.ProductionCardCustomizeID AND pop.ProductionOrdersID = @OrderID        
        WHERE a.LinkedProductionCardCustomizeID = @ProductionCardCustomizeID
    ELSE
        SET @SborkaID = @ProductionCardCustomizeID

    INSERT INTO #ReleaseDates(_ID, ReleaseDate, ReleaseCount)
    SELECT 
      d.ID,
      d.ReleaseDate,
      d.ReleaseCount
    FROM dbo.ProductionCardCustomizeReleaseDates d
    WHERE d.ProductionCardCustomizeID = @SborkaID
END
GO