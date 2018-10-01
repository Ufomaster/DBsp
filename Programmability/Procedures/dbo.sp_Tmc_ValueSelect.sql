SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   01.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   01.03.2011$
--$Version:    1.00$   $Description: Выбор данных объекта$
CREATE PROCEDURE [dbo].[sp_Tmc_ValueSelect]
    @TMCID Int
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE @docHandle Int, @ObjectTypeID Int
    DECLARE @XMLText Xml
    
    
    SELECT @XMLText = t.XMLData, @ObjectTypeID = t.ObjectTypeID
    FROM Tmc t
    WHERE ID = @TMCID
    
    EXEC sp_xml_preparedocument @docHandle OUTPUT, @XMLText

    SELECT
        @ObjectTypeID AS ObjectTypeID,
        *
    FROM OPENXML(@docHandle, N'TMC/Props',2) WITH (ID Int, FieldName Varchar(100), [Value] Varchar(8000))

    EXEC sp_xml_removedocument @docHandle
END
GO