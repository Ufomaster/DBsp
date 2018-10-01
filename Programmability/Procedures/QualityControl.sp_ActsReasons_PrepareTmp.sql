SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   05.12.2013$*/
/*$Modify:     Oleksii Poliatykin$    $Modify date:   03.08.2017$*/
/*$Version:    1.00$   $Description: Подготовка редактирования причин в акте*/
CREATE PROCEDURE [QualityControl].[sp_ActsReasons_PrepareTmp]
    @ID Int
AS
BEGIN    
    INSERT INTO #ActsReasons(_ID, Name, FaultsReasonsClassID)    
    SELECT
        d.ID, d.[Name], d.FaultsReasonsClassID
    FROM [QualityControl].ActsReasons d
    WHERE d.ActID = @ID
END
GO