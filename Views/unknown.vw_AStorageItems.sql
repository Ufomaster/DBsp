SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   09.08.2012$*/
/*$Modify:     Oleynik Yuriy$   $Modify date:   20.08.2012$*/
/*$Version:    1.00$   $Description: Вьюшка с айтемами хранения$*/
create VIEW [unknown].[vw_AStorageItems]
AS
    SELECT
        i.ID,
        t.[Name] + ' - ' + i.[Name] AS [Name],
        i.AStorageItemsTypeID,
        i.isAtomic,
        t.DefaultImageIndex,
        t.DefaultIsAtomic,
        t.LargeImageIndex,
        t.LastIndex,
        t.[Prefix],
        t.Suffix,
        t.CharCount,
        t.[Name] AS TypeName
    FROM AStorageItems i
    INNER JOIN AStorageItemsTypes t ON t.ID = i.AStorageItemsTypeID
GO