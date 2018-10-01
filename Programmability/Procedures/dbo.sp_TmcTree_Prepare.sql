SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   24.02.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   14.11.2011$
--$Version:    1.00$   $Decription: Готовим данные на изменение$
CREATE PROCEDURE [dbo].[sp_TmcTree_Prepare]
    @ID Int
AS
BEGIN
    DECLARE @rXML Xml
    DECLARE @docHandle Int

    DELETE FROM #Properties

    SELECT @rXML = CASE WHEN ot.XMLSchema IS NULL OR CAST(ot.XMLSchema AS Varchar(MAX)) = '' THEN NULL ELSE ot.XMLSchema END
    FROM dbo.ObjectTypes ot
    WHERE ID = @ID
    IF @rXML IS NULL
        RETURN
    ELSE
        SET @rXML = CAST(CAST('<?xml version="1.0" encoding="utf-16"?>' AS Nvarchar(MAX)) + CAST(@rXML AS Varchar(MAX)) AS Xml)

    EXEC sp_xml_preparedocument @docHandle OUTPUT, @rXML

    INSERT INTO #Properties(ID, FieldName, [Name], TypeID, ReferenceID, PageName, SortOrder)
    SELECT 
        ID, 
        FieldName, 
        [Name], 
        TypeID, 
        ReferenceID, 
        PageName, 
        CASE
            WHEN SortOrder IS NULL THEN ROW_NUMBER() OVER (ORDER BY SortOrder)
        ELSE SortOrder
        END
    FROM OPENXML(@docHandle, N'PropertyList/Props', 2) WITH #Properties

    EXEC sp_xml_removedocument @docHandle
END
GO