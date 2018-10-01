SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   06.07.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   06.07.2011$
--$Version:    1.00$   $Decription: возвращает процент НДС на дату$
CREATE FUNCTION [dbo].[fn_GetNDSPercent] (@D Datetime)
    RETURNS Float
AS
BEGIN
    RETURN(SELECT TOP 1 a.NDSPercent 
           FROM NDSHistory a 
           WHERE a.[Date] < @D
           ORDER BY a.[Date] DESC)
END
GO