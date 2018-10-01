SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   18.12.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   18.12.2014$*/
/*$Version:    1.00$   $Decription: */
create PROCEDURE [QualityControl].[sp_ActOfSampling_Select]
    @ProtocolID Int
AS
BEGIN
    SELECT
        a.*
    FROM QualityControl.ActOfSampling a
    WHERE a.ProtocolID = @ProtocolID
END
GO