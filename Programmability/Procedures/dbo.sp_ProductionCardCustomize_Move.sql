SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   20.12.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   20.12.2012$*/
/*$Version:    1.00$   $Description: Сортировка ЗЛ в рамках одного заказа$*/
create PROCEDURE [dbo].[sp_ProductionCardCustomize_Move]
    @Direction Int, /*0 down, 1-up*/
    @ID Int,
    @ZLOrderID int
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @Order Int

    IF @Direction = 1 /* VK_UP*/
    BEGIN
        /*выбрали текущее значение порядка*/
        SELECT @Order = SortOrder
        FROM dbo.ProductionOrdersProdCardCustomize 
        WHERE ProductionCardCustomizeID = @ID AND ProductionOrdersID = @ZLOrderID

        /*выберем предидущий порядок*/
        SELECT TOP 1 @Order = SortOrder
        FROM dbo.ProductionOrdersProdCardCustomize
        WHERE SortOrder < @Order AND ProductionOrdersID = @ZLOrderID
        ORDER BY SortOrder DESC

        /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE dbo.ProductionOrdersProdCardCustomize
            SET SortOrder = SortOrder + 1
            WHERE SortOrder = @Order AND ProductionOrdersID = @ZLOrderID
        ELSE
            SET @Order = 1
       /*наконец проставим себе индекс если возможно*/
       UPDATE dbo.ProductionOrdersProdCardCustomize
       SET SortOrder = @Order
       WHERE ProductionCardCustomizeID = @ID AND ProductionOrdersID = @ZLOrderID
    END
    ELSE

    IF @Direction = 0 /* VK_DOWN*/
    BEGIN
        /*выбрали текущее значение порядка*/
        SELECT @Order = SortOrder
        FROM dbo.ProductionOrdersProdCardCustomize 
        WHERE ProductionCardCustomizeID = @ID AND ProductionOrdersID = @ZLOrderID
        
        /*выберем следующий порядок*/
        SELECT TOP 1 @Order = SortOrder
        FROM dbo.ProductionOrdersProdCardCustomize
        WHERE SortOrder > @Order AND ProductionOrdersID = @ZLOrderID
        ORDER BY SortOrder
        
        /*сдвинем след. запись вверх, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE dbo.ProductionOrdersProdCardCustomize
            SET SortOrder = SortOrder - 1
            WHERE SortOrder = @Order AND ProductionOrdersID = @ZLOrderID
        ELSE
            SET @Order = (SELECT ISNULL(MAX(SortOrder),0) + 1 
                          FROM dbo.ProductionOrdersProdCardCustomize 
                          WHERE ProductionOrdersID = @ZLOrderID)
       /*наконец проставим себе индекс если возможно*/
       IF @Order IS NULL
           SET @Order = 1
       UPDATE dbo.ProductionOrdersProdCardCustomize
       SET SortOrder = @Order
       WHERE ProductionCardCustomizeID = @ID AND ProductionOrdersID = @ZLOrderID
    END
END
GO