SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   03.08.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   03.08.2011$
--$Version:    1.00$   $Decription: дата без времени$
CREATE FUNCTION [dbo].[fn_DateCropTime] (@DateWithTime Datetime)
	RETURNS Datetime
AS
BEGIN
    DECLARE @DateWithoutTime Datetime
    SET @DateWithoutTime = CAST(CONVERT(Varchar(8), @DateWithTime, 112) AS Datetime)
    RETURN @DateWithoutTime
END
GO