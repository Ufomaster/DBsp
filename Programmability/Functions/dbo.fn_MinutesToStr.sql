SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fn_MinutesToStr] (@Minutes int)
RETURNS VARCHAR(8)
AS
BEGIN      
    RETURN (RIGHT('00' + CAST(FLOOR(FLOOR(@Minutes/600)/6) AS Varchar), 2)
            + ':' + 
            RIGHT('00' + CAST(FLOOR(@Minutes/60 - FLOOR(@Minutes/600)/6 * 60) AS varchar), 2))
END
GO