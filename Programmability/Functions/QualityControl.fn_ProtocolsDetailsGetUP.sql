SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$   $Create date:   23.02.2015$*/
/*$Modify:     Yuriy Oleynik$   $Modify date:   23.02.2015$*/
/*$Version:    1.00$   $Description: Выборка наименований несосотв. продукции протокола в строку $*/
create FUNCTION [QualityControl].[fn_ProtocolsDetailsGetUP] (
	@ProtocolID Int)
RETURNS varchar(255)
AS
BEGIN
    DECLARE @Query varchar(255)
       
    SELECT @Query = RIGHT(ISNULL(@Query + CHAR(13)+ CHAR(10), '') + RTRIM(LTRIM(pd.[Caption])), 255)
    FROM QualityControl.ProtocolsDetails pd
    WHERE pd.ProtocolID = @ProtocolID AND pd.BlockID IS NULL AND ISNULL(pd.Checked, 0) = 0 AND pd.ResultKind > 1
    
    
	RETURN @Query
END
GO