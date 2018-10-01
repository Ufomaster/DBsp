SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   28.09.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   28.09.2012$*/
/*$Version:    1.00$   $Description: Выборка статусов ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardStatuses_Select]
AS
BEGIN
    SELECT 
        ps.*,
        uro.[Name] AS EditingRightConstName,
        uro1.[Name] AS StatusEditingRightConstName
    FROM ProductionCardStatuses ps
    LEFT JOIN UserRightsObjects uro ON uro.ID = ps.EditingRightConst
    LEFT JOIN UserRightsObjects uro1 ON uro1.ID = ps.StatusEditingRightConst
END
GO