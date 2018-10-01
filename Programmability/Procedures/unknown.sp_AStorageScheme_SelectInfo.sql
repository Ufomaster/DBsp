SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   20.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   20.08.2012$*/
/*$Version:    1.00$   $Decription: Выбор инфо по дереву схемы хранилища$*/
create PROCEDURE [unknown].[sp_AStorageScheme_SelectInfo]
    @AStorageSchemeID Int
AS
BEGIN
    SELECT
    /*    ssr.*,
        i.[Name],
        e.FullName,
        ISNULL(i.[Prefix], '') + RIGHT(REPLICATE('0', i.CharCount) + CAST(ssr.LastIndex + 1 AS Varchar), i.CharCount) + ISNULL(i.Suffix, '') AS [From],
        ISNULL(i.[Prefix], '') + RIGHT(REPLICATE('0', i.CharCount) + CAST(ssr.ReservCount AS Varchar), i.CharCount) + ISNULL(i.Suffix, '') AS [Till]*/
        CAST('Всего по узлу "' + i.[Name] AS Varchar(255)) + '"' AS Info,
        COUNT(ss.Number) AS cnt/*,*/
    /*    i.[Name]*/
    FROM [unknown].AStorageStructure ss
    LEFT JOIN [unknown].AStorageScheme s ON s.ID = ss.AStorageSchemeID
    LEFT JOIN [unknown].vw_AStorageItems i ON i.ID = s.AStorageItemID
    WHERE ss.AStorageSchemeID = @AStorageSchemeID
    GROUP BY i.[Name]

    UNION ALL

    SELECT
    /*    ssr.*,
        i.[Name],
        e.FullName,
        ISNULL(i.[Prefix], '') + RIGHT(REPLICATE('0', i.CharCount) + CAST(ssr.LastIndex + 1 AS Varchar), i.CharCount) + ISNULL(i.Suffix, '') AS [From],
        ISNULL(i.[Prefix], '') + RIGHT(REPLICATE('0', i.CharCount) + CAST(ssr.ReservCount AS Varchar), i.CharCount) + ISNULL(i.Suffix, '') AS [Till]*/
        CAST('Всего по типу "'+ i.[TypeName] AS Varchar(255)) + '"' AS Info,
        COUNT(ss.Number) AS cnt/*,*/
    /*    i.TypeName*/
    FROM [unknown].AStorageStructure ss
    LEFT JOIN [unknown].AStorageScheme s ON s.ID = ss.AStorageSchemeID
    LEFT JOIN [unknown].vw_AStorageItems i ON i.ID = s.AStorageItemID
    WHERE i.AStorageItemsTypeID IN (SELECT i.AStorageItemsTypeID
                                       FROM [unknown].AStorageScheme s
                                       INNER JOIN [unknown].vw_AStorageItems i ON i.ID = s.AStorageItemID
                                       WHERE s.ID = @AStorageSchemeID)
    GROUP BY i.TypeName
END
GO