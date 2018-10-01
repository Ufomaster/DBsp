SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create FUNCTION [dbo].[fn_Bin2Str] (@binval binary(16))
RETURNS char(36)
AS
BEGIN      
    RETURN (CONVERT(char(36),CONVERT(uniqueidentifier, @binval)))
END
GO