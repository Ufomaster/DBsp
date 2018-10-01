SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   12.12.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   12.12.2016$*/
/*$Version:    1.00$   $Description: Подготовка редактирования FILES*/
create PROCEDURE [QualityControl].[sp_ProtocolsFiles_PrepareTmp]
    @ID Int
AS
BEGIN
    INSERT INTO #ProtocolsFiles(_ID, [FileName], [FileData], [FileDataThumb])
    SELECT
        d.ID, d.[FileName], d.[FileData], d.[FileDataThumb]
    FROM QualityControl.ProtocolsFiles d
    WHERE d.ProtocolID = @ID
    ORDER BY d.ID
END
GO