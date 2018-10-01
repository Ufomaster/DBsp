SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   17.01.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.01.2017$*/
/*$Version:    1.00$   $Decription: Сохраняем$*/
create PROCEDURE [dbo].[sp_ProductionCardProperties_ReleaseDatesSave]
    @ID Int, 
    @OrderID int
AS
BEGIN
   --ищем айди сборки на подмену
    DECLARE @SborkaID int

    IF EXISTS(SELECT a.ID FROM ProductionCardCustomizeDetails a
              INNER JOIN ProductionOrdersProdCardCustomize pop ON pop.ProductionCardCustomizeID = a.ProductionCardCustomizeID AND pop.ProductionOrdersID = @OrderID
              WHERE a.LinkedProductionCardCustomizeID = @ID)
        SELECT @SborkaID = a.ProductionCardCustomizeID
        FROM ProductionCardCustomizeDetails a
        INNER JOIN ProductionOrdersProdCardCustomize pop ON pop.ProductionCardCustomizeID = a.ProductionCardCustomizeID AND pop.ProductionOrdersID = @OrderID        
        WHERE a.LinkedProductionCardCustomizeID = @ID
    ELSE
        SET @SborkaID = @ID
    
    IF OBJECT_ID('tempdb..#ReleaseDates') IS NOT NULL
    BEGIN    
      /*удалим удалённые*/
      DELETE se
      FROM dbo.ProductionCardCustomizeReleaseDates se
      LEFT JOIN #ReleaseDates t ON t._ID = se.ID
      WHERE t._ID IS NULL AND se.ProductionCardCustomizeID = @SborkaID

      /*изменим изменённые*/
      UPDATE se
      SET se.ReleaseDate = t.ReleaseDate,
          se.ReleaseCount = t.ReleaseCount
      FROM dbo.ProductionCardCustomizeReleaseDates se
      INNER JOIN #ReleaseDates t ON t._ID = se.ID
      WHERE se.ProductionCardCustomizeID = @SborkaID

      /*Добавим добавленные*/
      INSERT INTO ProductionCardCustomizeReleaseDates(ProductionCardCustomizeID, ReleaseDate, ReleaseCount)
      SELECT
          @SborkaID, 
          d.ReleaseDate,
          d.ReleaseCount
      FROM #ReleaseDates d
      LEFT JOIN ProductionCardCustomizeReleaseDates pa ON pa.ID = d._ID AND pa.ProductionCardCustomizeID = @SborkaID
      WHERE pa.ID IS NULL
   END
END
GO