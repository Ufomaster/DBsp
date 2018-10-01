SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   05.12.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   05.12.2015$*/
/*$Version:    1.00$   $Decription: выборка карты статусов$*/
create PROCEDURE [dbo].[sp_ShipmentRequestsStatus_Select]
    @StatusID Int
AS
BEGIN
    IF @StatusID = 0
        SELECT ID, Name
        FROM vw_ShipmentRequestsStatuses
        WHERE ID IN (0, 1, 3)
    ELSE
    IF @StatusID = 1
        SELECT ID, Name
        FROM vw_ShipmentRequestsStatuses
        WHERE ID IN (0, 1, 2)
    ELSE
        SELECT ID, Name
        FROM vw_ShipmentRequestsStatuses
        WHERE ID = @StatusID
END
GO