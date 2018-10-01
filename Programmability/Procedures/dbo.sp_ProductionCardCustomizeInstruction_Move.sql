SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   19.04.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   19.04.2012$*/
/*$Version:    1.00$   $Description: Перемещение шага в рамках заголовка$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeInstruction_Move]
    @ID Int,
    @Direction Int
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @HeaderID Int, @MaxOrder Int, @MinOrder Int, @Order Int
    
    SELECT @HeaderID = a.AssemblyInstructionHeaderID
    FROM ProductionCardCustomizeAssemblyInstructions a
    WHERE a.ID = @ID
    
    IF @Direction = 1 /* VK_UP*/
    BEGIN
        /*выбрали текущее значение порядка*/
        SELECT @Order = h.SortOrder
        FROM dbo.ProductionCardCustomizeAssemblyInstructions h 
        WHERE h.ID = @ID

        /*выберем предидущий порядок*/
        SELECT TOP 1 @Order = SortOrder
        FROM dbo.ProductionCardCustomizeAssemblyInstructions
        WHERE SortOrder < @Order AND AssemblyInstructionHeaderID = @HeaderID
        ORDER BY SortOrder DESC

        /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE dbo.ProductionCardCustomizeAssemblyInstructions
            SET SortOrder = SortOrder + 1
            WHERE SortOrder = @Order AND AssemblyInstructionHeaderID = @HeaderID
        ELSE
            SET @Order = 1
       /*наконец проставим себе индекс если возможно*/
       UPDATE dbo.ProductionCardCustomizeAssemblyInstructions
       SET SortOrder = @Order
       WHERE ID = @ID       
       SELECT 0
    END
    ELSE

    IF @Direction = 0 /* VK_DOWN*/
    BEGIN
        /*выбрали текущее значение порядка*/
        SELECT @Order = SortOrder
        FROM dbo.ProductionCardCustomizeAssemblyInstructions 
        WHERE ID = @ID
        
        /*выберем следующий порядок*/
        SELECT TOP 1 @Order = SortOrder
        FROM dbo.ProductionCardCustomizeAssemblyInstructions
        WHERE SortOrder > @Order AND AssemblyInstructionHeaderID = @HeaderID
        ORDER BY SortOrder
        
        /*сдвинем след. запись вверх, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE dbo.ProductionCardCustomizeAssemblyInstructions
            SET SortOrder = SortOrder - 1
            WHERE SortOrder = @Order AND AssemblyInstructionHeaderID = @HeaderID
        ELSE
            SET @Order = (SELECT ISNULL(MAX(SortOrder),0) + 1 
                          FROM dbo.ProductionCardCustomizeAssemblyInstructions 
                          WHERE AssemblyInstructionHeaderID = @HeaderID)
       /*наконец проставим себе индекс если возможно*/
       IF @Order IS NULL
           SET @Order = 1
       UPDATE dbo.ProductionCardCustomizeAssemblyInstructions
       SET SortOrder = @Order
       WHERE ID = @ID
       SELECT 0
    END
END
GO