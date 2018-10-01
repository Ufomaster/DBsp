SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   09.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   25.05.2015$*/
/*$Version:    1.00$   $Description: Сохранение данных полей $*/
CREATE PROCEDURE [QualityControl].[sp_Acts_SaveXMLStart]
    @ActDetailsID int
AS
BEGIN
    DECLARE @XML xml
    SELECT @XML = XMLData FROM QualityControl.ActsDetails WHERE ID = @ActDetailsID
    INSERT INTO #SaveXML(ID, ActFieldsID, [Value], SortOrder)
    SELECT
        nref.value('(ID)[1]', 'int') AS ID, 
        nref.value('(ActFieldsID)[1]', 'varchar(255)') AS ActFieldsID,
        nref.value('(Value)[1]', 'varchar(8000)') AS [Value], 
        nref.value('(SortOrder)[1]', 'int') AS SortOrder 
    FROM @XML.nodes('/Data/Props') R(nref)
    ORDER BY SortOrder
END
GO