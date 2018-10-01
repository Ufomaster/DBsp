SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   16.01.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   16.01.2013$*/
/*$Version:    1.00$   $Decription:возвращает число, с точностью @Precn$*/
CREATE FUNCTION [dbo].[fn_RoundBase] (@Res Decimal(38, 10), @Precn Decimal(38, 10))
    RETURNS Decimal(38, 10)
AS
BEGIN
    DECLARE @Multiplier Int
    
    SELECT @Multiplier = CEILING(@Res/@Precn)

    RETURN @Multiplier * @Precn
END
GO