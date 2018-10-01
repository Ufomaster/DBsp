SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   28.09.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   28.09.2012$*/
/*$Version:    1.00$   $Decription: выборка типов ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardTypes_Select]
AS
BEGIN
    SELECT
        t.*,
        r.[Name] AS ReportName,
        h.ObjectTypeID,
        ot.[Name] AS ObjectTypeName,
        pcs.NAME AS StartStatusName
    FROM ProductionCardTypes t
    LEFT JOIN Reports r ON r.ID = t.PrintReportID
    LEFT JOIN ProductionCardProperties h ON h.ID = t.ProductionCardPropertiesID
    LEFT JOIN ObjectTypes ot ON ot.ID = h.ObjectTypeID
    LEFT JOIN ProductionCardStatuses pcs ON pcs.ID = t.StartStatusID
END
GO