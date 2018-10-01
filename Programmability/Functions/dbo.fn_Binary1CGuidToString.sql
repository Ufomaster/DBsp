SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create FUNCTION [dbo].[fn_Binary1CGuidToString] (@binaryUUID binary(16))
--конвертация 1с бинарного гуида в строку GUID
RETURNS char(40)
AS
BEGIN
	DECLARE @buffer varchar(40)
	SELECT @buffer = REPLACE(CONVERT(varchar(40), CAST(@binaryUUID AS uniqueidentifier)), '-', '')

	RETURN 
	RIGHT(@buffer, 8) + '-' +
	SUBSTRING(@buffer, 21, 4) + '-' +
	SUBSTRING(@buffer, 17, 4) + '-' +
	SUBSTRING(@buffer, 7, 2) +
	SUBSTRING(@buffer, 5, 2) + '-' +

	SUBSTRING(@buffer, 3, 2) +
	SUBSTRING(@buffer, 1, 2) +
	SUBSTRING(@buffer, 11, 2) +
	SUBSTRING(@buffer, 9, 2) +
	SUBSTRING(@buffer, 15, 2) +
	SUBSTRING(@buffer, 13, 2)
END
GO