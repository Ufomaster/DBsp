SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   22.12.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.03.2015$*/
/*$Version:    1.00$   $Decription: */
CREATE PROCEDURE [QualityControl].[sp_ActOfSamplingDetails_Select]
    @ActID Int
AS
BEGIN
    SELECT
        a.*,
        ROW_NUMBER() OVER (ORDER BY a.ID) AS [Number]
    FROM QualityControl.ActOfSamplingDetails a
    WHERE a.ActOfSamplingID = @ActID
    ORDER BY a.ID
END
GO