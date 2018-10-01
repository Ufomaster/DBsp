SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   20.04.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   20.04.2012$*/
/*$Version:    1.00$   $Description: Удаление шага в рамках заголовка$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeInstruction_Delete]
    @ID Int
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @HeaderID Int, @SortOrder Int
    
    SELECT @HeaderID = a.AssemblyInstructionHeaderID, @SortOrder = a.SortOrder
    FROM ProductionCardCustomizeAssemblyInstructions a
    WHERE a.ID = @ID

    DELETE a
    FROM ProductionCardCustomizeAssemblyInstructions a
    WHERE a.ID = @ID
    
    UPDATE a
    SET a.SortOrder = a.SortOrder - 1
    FROM ProductionCardCustomizeAssemblyInstructions a
    WHERE a.AssemblyInstructionHeaderID = @HeaderID AND a.SortOrder > @SortOrder
END
GO