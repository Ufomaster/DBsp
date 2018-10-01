SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   19.12.2013$*/
/*$Version:    1.00$   $Description: Перемещение свойств типа протокола$*/
CREATE PROCEDURE [QualityControl].[sp_TypesDetails_MoveTmp]
    @ID Int,
    @Direction Int,
    @OldBlockID int = NULL
AS
BEGIN   
    DECLARE @Order int, @BlockID int
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF @Direction = 1 /* VK_UP*/
        BEGIN
            SELECT @BlockID = BlockID, @Order = SortOrder
            FROM #TypesDetails
            WHERE ID = @ID
            
            /*выберем предидущий порядок*/
            SELECT TOP 1 @Order = SortOrder
            FROM #TypesDetails
            WHERE BlockID = @BlockID AND SortOrder < @Order
            ORDER BY SortOrder DESC

            /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
            IF @Order IS NOT NULL
                UPDATE #TypesDetails
                SET SortOrder = SortOrder + 1
                WHERE SortOrder = @Order AND BlockID = @BlockID
            ELSE
                SET @Order = 1
           /*наконец проставим себе индекс если возможно*/
           UPDATE #TypesDetails
           SET SortOrder = @Order
           WHERE ID = @ID
        END
        ELSE

        IF @Direction = 2 /* VK_DOWN*/
        BEGIN
            SELECT @BlockID = BlockID, @Order = SortOrder
            FROM #TypesDetails
            WHERE ID = @ID
            /*выберем следующий порядок*/
            SELECT TOP 1 @Order = SortOrder
            FROM #TypesDetails
            WHERE BlockID = @BlockID AND SortOrder > @Order
            ORDER BY SortOrder
            /*сдвинем след. запись вверх, если есть что сдвигать*/
            IF @Order IS NOT NULL
                UPDATE #TypesDetails
                SET SortOrder = SortOrder - 1
                WHERE SortOrder = @Order AND BlockID = @BlockID
            ELSE
                SET @Order = (SELECT MAX(SortOrder + 1) FROM #TypesDetails WHERE BlockID = @BlockID)
           /*наконец проставим себе индекс если возможно*/
           IF @Order IS NULL
               SET @Order = 1
           UPDATE #TypesDetails
           SET SortOrder = @Order
           WHERE ID = @ID
        END
        ELSE
        
        IF @Direction = 3 /*BlockID changed*/
        BEGIN
            SELECT @BlockID = BlockID, @Order = SortOrder
            FROM #TypesDetails
            WHERE ID = @ID
            /*старые записи тут пересортируем*/
            IF @OldBlockID <> @BlockID
            BEGIN
                UPDATE #TypesDetails
                SET SortOrder = SortOrder - 1
                WHERE SortOrder > @Order AND BlockID = @OldBlockID
                /*новое место вставки - добавляем в конец.*/
                UPDATE #TypesDetails
                SET SortOrder = (SELECT ISNULL(MAX(SortOrder), 0) + 1 FROM #TypesDetails WHERE BlockID = @BlockID)
                WHERE ID = @ID
            END
        END
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO