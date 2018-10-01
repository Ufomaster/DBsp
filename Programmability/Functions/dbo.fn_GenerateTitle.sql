SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$   $Create date:   25.02.2011$
--$Modify:     Yuriy Oleynik$   $Modify date:   25.02.2011$
--$Version:    1.00$   $Description: Генерация заголовка для триггеров, процедур, fn$
CREATE FUNCTION [dbo].[fn_GenerateTitle] (
	@ObjectID Int,
	@Version Varchar(5),
	@Description Varchar(100))
	RETURNS Varchar(500)
AS
BEGIN
	DECLARE @Title Varchar(500), @Who Varchar(100), @CurrDate Varchar(10), @CreateDate Varchar(100)
	SELECT @CreateDate = CONVERT(Char(10), crdate, 104)  FROM SYS.SYSOBJECTS WHERE ID = @ObjectID
	SELECT @Who = SUSER_SNAME(), @CurrDate = CONVERT(Char(10), GETDATE(), 104) 
--    IF @Who =
	SET @Who = 'Yuriy Oleynik'

	IF @CreateDate IS NULL BEGIN
		SET @Title = '--$Create:     Yuriy Oleynik$    $Create date:    ' + @CurrDate + '$
--$Modify:     ' + @Who + '$    $Modify date:    ' + @CurrDate + '$
--$Version:    ' + @Version + '$    $Description: ' + @Description + '$
CREATE'
	END ELSE BEGIN
		SET @Title = '--$Create:     Yuriy Oleynik$    $Create date:    ' + @CreateDate + '$
--$Modify:     ' + @Who + '$    $Modify date:    ' + @CurrDate + '$
--$Version:    ' + @Version + '$    $Description: ' + @Description + '$
ALTER'
	END
	RETURN @Title
END
GO