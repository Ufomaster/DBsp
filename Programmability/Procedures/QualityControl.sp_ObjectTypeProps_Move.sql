SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   13.10.2014$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   13.10.2014$*/
/*$Version:    1.00$   $Description: Перемещение характеристики группы$*/
create PROCEDURE [QualityControl].[sp_ObjectTypeProps_Move]
    @ID Int,
    @Direction Int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @ObjectTypeID Int, @MaxOrder Int, @MinOrder Int, @Order Int
    IF @Direction = 3 /* VK_UP*/
    BEGIN
        /*выбрали текущий парент, это у нас группирующий флаг, а так же текущее значение порядка*/
        SELECT @ObjectTypeID = ObjectTypeID, @Order = SortOrder
        FROM QualityControl.ObjectTypeProps WHERE ID = @ID
        
        /*выберем предидущий порядок*/
        SELECT TOP 1 @Order = SortOrder
        FROM QualityControl.ObjectTypeProps
        WHERE ISNULL(ObjectTypeID, 0) = @ObjectTypeID AND SortOrder < @Order
        ORDER BY SortOrder DESC
        /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE QualityControl.ObjectTypeProps
            SET SortOrder = SortOrder + 1
            WHERE SortOrder = @Order AND ObjectTypeID = @ObjectTypeID
        ELSE
            SET @Order = 1
       /*наконец проставим себе индекс если возможно*/
       UPDATE QualityControl.ObjectTypeProps
       SET SortOrder = @Order
       WHERE ID = @ID
    END
    ELSE

    IF @Direction = 4 /* VK_DOWN*/
    BEGIN
        /*выбрали текущий парент, это у нас группирующий флаг, а так же текущее значение порядка*/
        SELECT @ObjectTypeID = ObjectTypeID, @Order = SortOrder
        FROM QualityControl.ObjectTypeProps WHERE ID = @ID
        /*выберем следующий порядок*/
        SELECT TOP 1 @Order = SortOrder
        FROM QualityControl.ObjectTypeProps
        WHERE ObjectTypeID = @ObjectTypeID AND SortOrder > @Order
        ORDER BY SortOrder
        /*сдвинем след. запись вверх, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE QualityControl.ObjectTypeProps
            SET SortOrder = SortOrder - 1
            WHERE SortOrder = @Order AND ObjectTypeID = @ObjectTypeID
        ELSE
            SET @Order = (SELECT ISNULL(MAX(SortOrder + 1), 1)  FROM QualityControl.ObjectTypeProps WHERE ObjectTypeID = @ObjectTypeID)
       /*наконец проставим себе индекс если возможно*/
       UPDATE QualityControl.ObjectTypeProps
       SET SortOrder = @Order
       WHERE ID = @ID
    END
END
GO