SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.07.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   20.08.2012$*/
/*$Version:    1.00$   $Decription: Выбор резерва схемы хранилища$*/
create PROCEDURE [unknown].[sp_AStorageStructureReserv_Select]
    @AStorageItemsID Int
AS
BEGIN
    SET NOCOUNT ON
    SELECT
        ssr.*,
        i.[Name],
        e.FullName,
        ISNULL(i.[Prefix], '') + RIGHT(REPLICATE('0', i.CharCount) + CAST(ssr.LastIndex + 1 AS Varchar), i.CharCount) + ISNULL(i.Suffix, '') AS [BeginNumber],
        ISNULL(i.[Prefix], '') + RIGHT(REPLICATE('0', i.CharCount) + CAST(ssr.LastIndex + ssr.ReservCount AS Varchar), i.CharCount) + ISNULL(i.Suffix, '') AS [EndNumber]
    FROM AStorageStructureReserv ssr
    LEFT JOIN vw_AStorageItems i ON i.ID = ssr.AStorageItemsID
    LEFT JOIN vw_Employees e ON e.ID = ssr.EmployeeID
    WHERE ssr.AStorageItemsID = @AStorageItemsID
END
GO