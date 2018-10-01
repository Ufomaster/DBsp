SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   06.07.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   15.12.2014$
--$Version:    1.00$   $Decription: возвращает мультипликатор НДС на дату$
CREATE FUNCTION [dbo].[fn_GetNDSMultiplier] (@D Datetime)
    RETURNS decimal(18,4)
AS
BEGIN
    RETURN(SELECT TOP 1 a.NDSMultiplier 
           FROM NDSHistory a 
           WHERE a.[Date] < @D
           ORDER BY a.[Date] DESC)
END
GO