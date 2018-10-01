SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   23.12.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   12.03.2015$*/
/*$Version:    1.00$   $Decription: */
CREATE PROCEDURE [QualityControl].[sp_ActOfTestingDetails_Select]
    @ProtocolID Int
AS
BEGIN
    SELECT
        a.*
    FROM QualityControl.ActOfTestingDetails a
    WHERE a.ProtocolID = @ProtocolID
END
GO