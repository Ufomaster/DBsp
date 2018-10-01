SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.03.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.03.2012$*/
/*$Version:    1.00$   $Decription: Сохраняем$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_DocDetailsSave]
    @ProductionCardCustomizeID Int
AS
BEGIN
    IF OBJECT_ID('tempdb..#FieldsDetails') IS NOT NULL
    BEGIN    
      /*удалим удалённые*/
      DELETE se
      FROM dbo.ProductionCardCustomizeDocDetails se
      LEFT JOIN #FieldsDetails t ON t._ID = se.ID
      WHERE t._ID IS NULL AND se.ProductionCardCustomizeID = @ProductionCardCustomizeID

      /*изменим изменённые*/
      UPDATE se
      SET se.[Name] = t.[Name],
          se.[Format] = t.[Format], 
          se.NeedCheck = t.NeedCheck,
          se.Number = t.Number
      FROM dbo.ProductionCardCustomizeDocDetails se
      INNER JOIN #FieldsDetails t ON t._ID = se.ID
      WHERE se.ProductionCardCustomizeID = @ProductionCardCustomizeID

      /*Добавим добавленные*/
      INSERT INTO ProductionCardCustomizeDocDetails(ProductionCardCustomizeID, [Name],
        [Format], NeedCheck, Number)
      SELECT
          @ProductionCardCustomizeID, 
          d.[Name],
          d.[Format], 
          d.NeedCheck, 
          d.Number
      FROM #FieldsDetails d
      LEFT JOIN ProductionCardCustomizeDocDetails pa ON pa.ID = d._ID AND pa.ProductionCardCustomizeID = @ProductionCardCustomizeID
      WHERE pa.ID IS NULL
   END
END
GO