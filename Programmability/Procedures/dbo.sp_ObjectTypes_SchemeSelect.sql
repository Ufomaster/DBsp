SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   01.03.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   13.05.2011$
--$Version:    1.00$   $Description: Выбор схемы типа объекта$
CREATE PROCEDURE [dbo].[sp_ObjectTypes_SchemeSelect]
    @ObjectTypeID Int
AS
BEGIN
	SET NOCOUNT ON
    
    DECLARE @docHandle Int
    DECLARE @XMLText Xml
    
    SELECT @XMLText = XMLSchema
    FROM ObjectTypes
    WHERE ID = @ObjectTypeID
    
    EXEC sp_xml_preparedocument @docHandle OUTPUT, @XMLText

    SELECT
        @ObjectTypeID AS ObjectType,
        *
    FROM OPENXML(@docHandle, N'PropertyList/Props',2) WITH (ID Int, FieldName Varchar(100), [Name] Varchar(100), TypeID Int, ReferenceID Int, SortOrder Int)

    EXEC sp_xml_removedocument @docHandle
END
GO