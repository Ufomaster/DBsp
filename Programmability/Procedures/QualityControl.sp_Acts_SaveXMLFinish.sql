SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   09.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   17.06.2015$*/
/*$Version:    1.00$   $Description: Сохранение данных полей $*/
CREATE PROCEDURE [QualityControl].[sp_Acts_SaveXMLFinish]
    @ActDetailsID int
AS
BEGIN
    DECLARE @XMLData xml, @ActID int, @EmployeeID int
    SET NOCOUNT ON;
    
    SELECT @ActID = ad.ActsID
    FROM QualityControl.ActsDetails ad
    WHERE ad.ID = @ActDetailsID
    
    SELECT @EmployeeID = EmployeeID 
    FROM #CurrentUser

    SELECT @XMLData = CAST('<?xml version="1.0" encoding="utf-16"?><Data>' AS Nvarchar(MAX)) +
        (SELECT ID, ActFieldsID, Value, SortOrder
         FROM #SaveXML
         ORDER BY SortOrder
         FOR Xml PATH ('Props')) + '</Data>'

    UPDATE QualityControl.ActsDetails 
    SET XMLData = @XMLData
    WHERE ID = @ActDetailsID
    
    DROP TABLE #SaveXML
    
    EXEC QualityControl.sp_Acts_History_Insert @EmployeeID, @ActID, 1
END
GO