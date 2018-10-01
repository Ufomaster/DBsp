SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$   $Create date:   05.12.2013$*/
/*$Modify:     Yuriy Oleynik$   $Modify date:   05.12.2013$*/
/*$Version:    1.00$   $Description: Генерация XML по подписателю$*/
CREATE FUNCTION [QualityControl].[fn_ActGenerateXML] (
	@ActTemplatesSignersID Int)
RETURNS xml
AS
BEGIN
    DECLARE @XMLData xml
    SELECT @XMLData = CAST('<?xml version="1.0" encoding="utf-16"?><Data>' AS Nvarchar(MAX)) +
        (SELECT f.ID, f.ActFieldsID, NULL AS [Value], f.SortOrder
         FROM QualityControl.ActTemplatesFieldsPositions f 
         WHERE f.ActTemplatesSignersID = @ActTemplatesSignersID
         ORDER BY f.SortOrder
         FOR Xml PATH ('Props')) + '</Data>'
	RETURN @XMLData
END
GO