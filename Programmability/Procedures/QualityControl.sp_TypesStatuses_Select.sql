SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   07.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   07.11.2013$*/
/*$Version:    1.00$   $Description: Выборка статусов протоколов*/
create PROCEDURE [QualityControl].[sp_TypesStatuses_Select]
AS
BEGIN
    SELECT 
        ps.*,
        uro.[Name] AS EditingRightConstName,
        uro1.[Name] AS StatusEditingRightConstName
    FROM [QualityControl].[TypesStatuses] ps
    LEFT JOIN UserRightsObjects uro ON uro.ID = ps.EditingRightConst
    LEFT JOIN UserRightsObjects uro1 ON uro1.ID = ps.StatusEditingRightConst
END
GO