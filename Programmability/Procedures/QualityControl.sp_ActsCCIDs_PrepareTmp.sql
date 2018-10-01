SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   19.05.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   19.05.2015$*/
/*$Version:    1.00$   $Description: Подготовка редактирования CCID*/
create PROCEDURE [QualityControl].[sp_ActsCCIDs_PrepareTmp]
    @ID Int
AS
BEGIN    
    INSERT INTO #ActsCCIDs(_ID, CCID, [Batch], Box, Description)    
    SELECT
        d.ID, d.CCID, d.[Batch], d.Box, d.[Description]
    FROM QualityControl.ActsCCIDs d
    WHERE d.ActsID = @ID
    ORDER BY d.ID
END
GO