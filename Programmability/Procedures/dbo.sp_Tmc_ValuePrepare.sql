SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   02.03.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   02.03.2011$
--$Version:    1.00$   $Decription: Готовим данные на изменение$
CREATE PROCEDURE [dbo].[sp_Tmc_ValuePrepare]
    @TMCID Int
AS
BEGIN
    DECLARE @rXML Xml
    DECLARE @docHandle Int

    SELECT @rXML = CASE WHEN t.XMLData IS NULL OR CAST(t.XMLData AS Varchar(MAX)) = '' THEN NULL ELSE t.XMLData END
    FROM dbo.Tmc t
    WHERE t.ID = @TMCID

    IF @rXML IS NULL
        RETURN
    ELSE
        SET @rXML = CAST(CAST('<?xml version="1.0" encoding="utf-16"?>' AS Nvarchar(MAX)) + CAST(@rXML AS Varchar(MAX)) AS Xml)

    EXEC sp_xml_preparedocument @docHandle OUTPUT, @rXML

    INSERT INTO #PropValues(ID, FieldName, [Value])
    SELECT ID, FieldName, [Value]
    FROM OPENXML(@docHandle, N'TMC/Props', 2) WITH #PropValues

    EXEC sp_xml_removedocument @docHandle
END
GO