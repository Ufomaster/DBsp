SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.07.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   30.08.2012$*/
/*$Version:    1.00$   $Decription: Выбор элементов хранилища$*/
create PROCEDURE [unknown].[sp_AStorageStructure_Select]
    @ParentID Int = NULL,
    @SearchText Varchar(255) = NULL,
    @WholeWord Bit = 0
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @PID Int, @ID Int, @Result Varchar(255), @tmp Varchar(255), @SearchString Varchar(255)
    --адресная строка
    SET @Result = ''
    SET @PID = @ParentID
    WHILE @PID IS NOT NULL
    BEGIN
        SELECT
            @PID = s.ParentID,
            @ID = s.ID,
            @tmp = i.[Name] + ' ' + s.Number
        FROM AStorageStructure s
        INNER JOIN AStorageScheme ss ON ss.ID = s.AStorageSchemeID
        INNER JOIN vw_AStorageItems i ON i.ID = ss.AStorageItemID
        WHERE s.ID = @PID
        IF @PID IS NOT NULL
            SET @Result = @tmp + CASE WHEN @Result = '' THEN '' ELSE '\' + @Result END
    END
    SELECT
        @Result = s.Number + ':\' + @Result
    FROM AStorageStructure s
    INNER JOIN AStorageScheme ss ON ss.ID = s.AStorageSchemeID
    INNER JOIN vw_AStorageItems i ON i.ID = ss.AStorageItemID
    WHERE s.ID = @ID
    
    IF @WholeWord = 1
        SET @SearchString = @SearchText
    ELSE
        SET @SearchString = '%' + @SearchText + '%'

    --данные. Если не поиск.

    IF @SearchText IS NULL
    BEGIN
        SELECT
          ss.ID,
          ss.ParentID,
          ss.AStorageSchemeID,
          ss.MetaData,
          ss.Number,
          ss.OrderID,
          ss.CreateDate,
          ss.PlaceDate,
          i.[Name],
          i.LargeImageIndex,
          @Result AS [Path],
          i.isAtomic,
          i.AStorageItemsTypeID,
          sss.AStorageItemID,
          0 AS Sort
        FROM AStorageStructure ss
        LEFT JOIN AStorageScheme sss ON sss.ID = ss.AStorageSchemeID
        INNER JOIN vw_AStorageItems i ON i.ID = sss.AStorageItemID
        WHERE (@ParentID IS NOT NULL AND ss.ParentID = @ParentID) OR
              (@ParentID IS NULL AND ss.ParentID IS NULL)

        UNION ALL

        SELECT
          ss.ParentID,
          ss.ParentID,
          ss.AStorageSchemeID,
          ss.MetaData,
          '...',
          ss.OrderID,
          ss.CreateDate,
          ss.PlaceDate,
          i.[Name],
          1,
          @Result,
          0,
          NULL,
          NULL,
          -1
        FROM AStorageStructure ss
        LEFT JOIN AStorageScheme sss ON sss.ID = ss.AStorageSchemeID
        INNER JOIN vw_AStorageItems i ON i.ID = sss.AStorageItemID
        WHERE ss.ID = @ParentID
        ORDER BY Sort
    END
    ELSE --если есть поиск
    BEGIN
        SELECT
          ss.ID,
          ss.ParentID,
          ss.AStorageSchemeID,
          ss.MetaData,
          ss.Number,
          ss.OrderID,
          ss.CreateDate,
          ss.PlaceDate,
          i.[Name],
          i.LargeImageIndex,
          @Result AS [Path],
          i.isAtomic,
          i.AStorageItemsTypeID,
          sss.AStorageItemID,
          0 AS Sort
        FROM AStorageStructure ss
        LEFT JOIN AStorageScheme sss ON sss.ID = ss.AStorageSchemeID
        INNER JOIN vw_AStorageItems i ON i.ID = sss.AStorageItemID
        WHERE (ss.Number LIKE @SearchString) OR (ss.MetaData LIKE @SearchString)

        UNION ALL

        SELECT
          @ParentID,
          @ParentID,
          NULL,
          NULL,
          '...',
          NULL,
          NULL,
          NULL,
          NULL,
          1,
          @Result,
          0,
          NULL,
          NULL,
          -1
        ORDER BY Sort
    END
END
GO