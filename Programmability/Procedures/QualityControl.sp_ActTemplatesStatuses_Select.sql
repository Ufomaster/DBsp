SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   04.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   04.12.2013$*/
/*$Version:    1.00$   $Description: Выборка статусов актов*/
create PROCEDURE [QualityControl].[sp_ActTemplatesStatuses_Select]
AS
BEGIN
    SELECT 
        ps.*,
        uro.[Name] AS EditingRightConstName,
        uro1.[Name] AS StatusEditingRightConstName
    FROM [QualityControl].[ActStatuses] ps
    LEFT JOIN UserRightsObjects uro ON uro.ID = ps.EditingRightConst
    LEFT JOIN UserRightsObjects uro1 ON uro1.ID = ps.StatusEditingRightConst
END
GO