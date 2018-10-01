SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   20.05.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   20.05.2015$*/
/*$Version:    1.00$   $Description: Подготовка редактирования FILES*/
create PROCEDURE [QualityControl].[sp_ActsFiles_PrepareTmp]
    @ID Int
AS
BEGIN
    INSERT INTO #ActsFiles(_ID, [FileName], [FileData], [FileDataThumb])
    SELECT
        d.ID, d.[FileName], d.[FileData], d.[FileDataThumb]
    FROM QualityControl.ActsFiles d
    WHERE d.ActsID = @ID
    ORDER BY d.ID
END
GO