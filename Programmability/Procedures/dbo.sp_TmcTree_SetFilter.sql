SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   11.05.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   30.01.2012$
--$Version:    1.00$   $Description: Установка фильтра для ветки дерева$
CREATE PROCEDURE [dbo].[sp_TmcTree_SetFilter]
    @ID Int,
    @AttributeID Int
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS(SELECT * FROM ObjectTypesAttributes ota WHERE ota.AttributeID = @AttributeID AND ota.ObjectTypeID = @ID)
    BEGIN
        DELETE FROM ObjectTypesAttributes
        WHERE AttributeID = @AttributeID AND ObjectTypeID = @ID
        
        DELETE a
        FROM ObjectTypesAttributes a
        WHERE a.ObjectTypeID IN (SELECT ID FROM fn_ObjectTypesNode_Select(@ID)) AND a.AttributeID = @AttributeID
    END
    ELSE
    BEGIN
        INSERT INTO ObjectTypesAttributes(AttributeID, ObjectTypeID)
        SELECT @AttributeID, @ID
        
        INSERT INTO ObjectTypesAttributes(AttributeID, ObjectTypeID)
        SELECT @AttributeID, a.ID
        FROM fn_ObjectTypesNode_Select(@ID) a
        LEFT JOIN ObjectTypesAttributes ex ON ex.AttributeID = @AttributeID AND ex.ObjectTypeID = a.ID
        WHERE ex.ID IS NULL
    END
END
GO