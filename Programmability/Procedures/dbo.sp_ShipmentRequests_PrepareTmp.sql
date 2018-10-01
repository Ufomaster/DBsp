SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   04.12.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   01.02.2016$*/
/*$Version:    1.00$   $Description: Подготовка редактирования*/
CREATE PROCEDURE [dbo].[sp_ShipmentRequests_PrepareTmp]
    @ID Int
AS
BEGIN    
    INSERT INTO #ShipmentRequestsDetails(_ID, Amount, Comments, Height, Length, [Name], PackCount, 
        PackTypeID, PCCID, UnitID, [Weight], Width, ZLNumber, TZ, TMCID)
    SELECT t.ID, t.Amount, t.Comments, t.Height, t.Length, t.[Name], t.PackCount, 
        t.PackTypeID, t.PCCID, t.UnitID, t.[Weight], t.Width, c.Number, t.TZ, t.TMCID
    FROM ShipmentRequestsDetails t
    LEFT JOIN ProductionCardCustomize c ON c.ID = t.PCCID
    WHERE t.ShipmentRequestID = @ID
    ORDER BY t.ID
END
GO