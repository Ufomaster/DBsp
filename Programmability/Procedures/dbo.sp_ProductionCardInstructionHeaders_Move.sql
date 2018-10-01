SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   17.04.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   17.04.2012$*/
/*$Version:    1.00$   $Description: Перемещение заголовка$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardInstructionHeaders_Move]
    @ID Int,
    @Direction Int
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @DestinationParentID Int, @MaxOrder Int, @MinOrder Int, @Order Int
    IF @Direction = 1 /* VK_UP*/
    BEGIN
        /*выбрали текущее значение порядка*/
        SELECT @Order = h.SortOrder
        FROM dbo.ProductionCardInstructionHeaders h WHERE h.ID = @ID

        /*выберем предидущий порядок*/
        SELECT TOP 1 @Order = SortOrder
        FROM dbo.ProductionCardInstructionHeaders
        WHERE SortOrder < @Order
        ORDER BY SortOrder DESC

        /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE dbo.ProductionCardInstructionHeaders
            SET SortOrder = SortOrder + 1
            WHERE SortOrder = @Order
        ELSE
            SET @Order = 1
       /*наконец проставим себе индекс если возможно*/
       UPDATE dbo.ProductionCardInstructionHeaders
       SET SortOrder = @Order
       WHERE ID = @ID       
       SELECT 0
    END
    ELSE

    IF @Direction = 0 /* VK_DOWN*/
    BEGIN
        /*выбрали текущее значение порядка*/
        SELECT @Order = SortOrder
        FROM dbo.ProductionCardInstructionHeaders WHERE ID = @ID
        
        /*выберем следующий порядок*/
        SELECT TOP 1 @Order = SortOrder
        FROM dbo.ProductionCardInstructionHeaders
        WHERE SortOrder > @Order
        ORDER BY SortOrder
        
        /*сдвинем след. запись вверх, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE dbo.ProductionCardInstructionHeaders
            SET SortOrder = SortOrder - 1
            WHERE SortOrder = @Order
        ELSE
            SET @Order = (SELECT ISNULL(MAX(SortOrder),0) + 1 FROM dbo.ProductionCardInstructionHeaders)
       /*наконец проставим себе индекс если возможно*/
       IF @Order IS NULL
           SET @Order = 1
       UPDATE dbo.ProductionCardInstructionHeaders
       SET SortOrder = @Order
       WHERE ID = @ID
       SELECT 0
    END
END
GO