SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create FUNCTION [dbo].[fn_MacAddress] ()
RETURNS nchar(12)
AS
BEGIN
  /* Function body */
	RETURN (SELECT top 1 net_address
	FROM sys.sysprocesses 
	WHERE spid = @@SPID)
END
GO