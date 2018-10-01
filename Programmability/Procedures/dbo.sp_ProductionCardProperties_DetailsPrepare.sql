SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   16.03.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   25.10.2017$*/
/*$Version:    1.00$   $Decription: Готовим данные на изменение$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_DetailsPrepare]
    @ProductionCardCustomizeID Int
AS
BEGIN
    INSERT INTO #ProductionCardCustomizeDetails(_ID, ProductionCardCustomizeID,
      LinkedProductionCardCustomizeID, Norma, TmcID, [Name], StatusName, Number, UnitID, MaterialKind, Kind)
    SELECT 
      d.ID, 
      d.ProductionCardCustomizeID, 
      d.LinkedProductionCardCustomizeID, 
      d.Norma, 
      d.TmcID,
      CAST(t.XMLData.value('(/TMC/Props/Value)[1]', 'varchar(max)') AS varchar(max)),
      s.[Name],
      pcs.Number,
      d.UnitID,
      d.MaterialKind,
      d.Kind
    FROM dbo.ProductionCardCustomizeDetails d
    LEFT JOIN Tmc t ON t.ID = d.TmcID
    LEFT JOIN ProductionCardCustomize pcs ON pcs.ID = d.LinkedProductionCardCustomizeID
    LEFT JOIN dbo.ProductionCardStatuses s ON s.ID = pcs.StatusID    
    WHERE d.ProductionCardCustomizeID = @ProductionCardCustomizeID
END
GO