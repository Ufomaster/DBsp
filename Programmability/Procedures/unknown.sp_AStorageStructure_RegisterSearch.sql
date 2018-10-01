SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   17.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.08.2012$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [unknown].[sp_AStorageStructure_RegisterSearch]
    @Number Varchar(255),
    @SearchStructureID Int OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Prefix Varchar(30), @Suffix Varchar(30), @CharCount Int, @SearchTypeID Int, @SearchSchemeID Int
    /*ищем по штрихкоду структуры, и если не находим - вставляем.*/
    /*более одного номера быть не должно. если попадется - значит ошибка в системе. пусть процедура вылетает.*/
    SET @SearchStructureID = NULL

    SELECT @SearchStructureID = ass.ID
    FROM AStorageStructure ass
    WHERE ass.Number = @Number
    
    IF @SearchStructureID IS NULL
    BEGIN
        /*
        пробуем по номеру вычислить чей у нас зверь. Если он один из списка, то ищем структуру.
        Далее, если в структуре обнаружена схема для 1 такого типа, то смело берём и апдейтим AStorageSchemeID 
        */
        SELECT @SearchTypeID = ait.ID, /* опять же, если более одного - проблема- нет контроля уникальности префиксов и суффиксов*/
            @Prefix = ait.[Prefix], 
            @Suffix = ait.Suffix, 
            @CharCount = ait.CharCount
        FROM AStorageItemsTypes ait 
        WHERE LEN(ISNULL(ait.[Prefix], '')) + ait.CharCount + LEN(ISNULL(ait.Suffix, '')) = LEN(@Number)
            AND ISNULL(ait.[Prefix], '') = SUBSTRING(@Number, 1, LEN(ISNULL(ait.[Prefix], '')))
            AND ISNULL(ait.Suffix, '') = SUBSTRING(@Number, LEN(ISNULL(ait.[Prefix], '')) + ait.CharCount, LEN(ISNULL(ait.Suffix, '')))
                
        IF @SearchTypeID IS NOT NULL
        BEGIN /* ищем в схеме запись с таким айтемом, у которого тайп = @SearchTypeID. если она одна - смело берем @SearchSchemeID*/
            IF EXISTS(SELECT COUNT(ss.ID)
                      FROM AStorageScheme ss 
                      INNER JOIN AStorageItems ai ON ai.ID = ss.AStorageItemID
                      WHERE ai.AStorageItemsTypeID = @SearchTypeID
                      HAVING COUNT(ss.ID) = 1
                      )
            BEGIN
                SELECT @SearchSchemeID = ss.ID
                FROM AStorageScheme ss 
                INNER JOIN AStorageItems ai ON ai.ID = ss.AStorageItemID
                WHERE ai.AStorageItemsTypeID = @SearchTypeID
            END
            ELSE
            BEGIN
                /*Иначе смотрим резерв - ищем вхождение номера в резерв, берем первый попавшийся резерв по номеру*/
                SELECT TOP 1 @SearchSchemeID = s.ID
                FROM AStorageStructureReserv sr
                INNER JOIN vw_AStorageItems i ON i.ID = sr.AStorageItemsID
                INNER JOIN AStorageScheme s ON s.AStorageItemID = sr.AStorageItemsID
                WHERE @Number BETWEEN ISNULL(i.[Prefix], '') + RIGHT(REPLICATE('0', i.CharCount) + CAST(sr.LastIndex + 1 AS Varchar), i.CharCount) + ISNULL(i.Suffix, '')
                              AND ISNULL(i.[Prefix], '') + RIGHT(REPLICATE('0', i.CharCount) + CAST(sr.LastIndex + sr.ReservCount AS Varchar), i.CharCount) + ISNULL(i.Suffix, '')
            END
        END
        ELSE
            SET @SearchSchemeID = NULL
            
        DECLARE @T TABLE(ID Int)

        INSERT INTO AStorageStructure([ParentID], [AStorageSchemeID], [Number],  [NumberInt],
            [OrderID], [PlaceDate])
        OUTPUT INSERTED.ID INTO @T
        SELECT NULL, @SearchSchemeID, @Number, CAST(SUBSTRING(@Number, LEN(ISNULL(@Prefix, '')) + 1, @CharCount) AS Int),
            NULL, GetDate()

        SELECT @SearchStructureID = ID FROM @T /* результат айдишка вставленной записи.*/
    END
END
GO