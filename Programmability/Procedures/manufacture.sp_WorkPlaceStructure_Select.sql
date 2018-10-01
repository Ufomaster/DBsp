SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   29.01.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   16.09.2015$*/
/*$Version:    1.00$   $Decription: выборка рабочих произвождственных мест$*/
CREATE PROCEDURE [manufacture].[sp_WorkPlaceStructure_Select]
AS
BEGIN
    SELECT ID, Name
    FROM manufacture.[StorageStructure] a
    WHERE ISNULL(a.HiddenForSelect, 0) = 0
    ORDER BY Name 
END
GO