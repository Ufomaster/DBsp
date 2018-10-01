SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create FUNCTION [dbo].[fn_Str2Bin] (@binval char(36))
RETURNS binary(16)
AS
BEGIN
    RETURN (CONVERT(binary(16),CONVERT(uniqueidentifier, @binval)))
END
GO