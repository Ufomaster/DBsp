SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.03.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.03.2012$*/
/*$Version:    1.00$   $Decription: Готовим данные на изменение$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_DocDetailsPrepare]
    @ProductionCardCustomizeID Int
AS
BEGIN
    INSERT INTO #FieldsDetails(_ID, Number, [Name], [Format], NeedCheck)
    SELECT
      d.ID, 
      d.Number, 
      d.[Name], 
      d.[Format], 
      d.NeedCheck
    FROM dbo.ProductionCardCustomizeDocDetails d
    WHERE d.ProductionCardCustomizeID = @ProductionCardCustomizeID
END
GO