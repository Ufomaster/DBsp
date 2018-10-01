SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   02.03.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   02.03.2011$
--$Version:    1.00$   $Decription: Постим данные$
CREATE PROCEDURE [dbo].[sp_Tmc_SavePropertiesValue]
    @ID Int
AS
BEGIN
    DECLARE @rXML Nvarchar(MAX)

    SELECT  @rXML = CAST('<?xml version="1.0" encoding="utf-16"?><TMC>' AS Nvarchar(MAX)) +
        (SELECT ID, FieldName, [Value]
         FROM #PropValues
         FOR Xml PATH ('Props')) + '</TMC>'

    UPDATE dbo.Tmc
    SET XMLData = @rXML
    WHERE ID = @ID
END
GO