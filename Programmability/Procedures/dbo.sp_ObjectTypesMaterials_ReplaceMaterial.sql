SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    $Create date:   26.01.2012$*/
/*$Modify:     Oleynik Yuiriy$    $Modify date:   13.01.2015$*/
/*$Version:    1.00$   $Description: Выборка связки материала со значением справочника$*/
create PROCEDURE [dbo].[sp_ObjectTypesMaterials_ReplaceMaterial]
    @ID Int,
    @NewTMC Int
AS
BEGIN
    UPDATE ObjectTypesMaterials
    SET TmcID = @NewTMC
    WHERE ID = @ID
END
GO