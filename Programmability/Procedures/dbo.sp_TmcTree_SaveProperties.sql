SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   24.02.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   03.10.2013$
--$Version:    1.01$   $Decription: Сохранение данных из временной таблиы #Properties в ХМЛ$
CREATE PROCEDURE [dbo].[sp_TmcTree_SaveProperties]
    @ID Int
AS
BEGIN
    DECLARE @rXML Nvarchar(MAX)

    SELECT  @rXML = CAST('<?xml version="1.0" encoding="utf-16"?><PropertyList>' AS nvarchar(MAX)) +
        (SELECT ID, FieldName, [Name], TypeID, ReferenceID, PageName, ROW_NUMBER() OVER (ORDER BY SortOrder) AS SortOrder
         FROM #Properties
         ORDER BY SortOrder
         FOR Xml PATH ('Props')) + '</PropertyList>'

    UPDATE dbo.ObjectTypes
    SET XMLSchema = @rXML
    WHERE ID = @ID
END
GO