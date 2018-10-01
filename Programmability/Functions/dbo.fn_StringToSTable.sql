SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   23.06.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   12.06.2014$
--$Version:    1.00$   $Decription: Вход-строка со значениями через зяпятую, выход таблица с полем varchar$
CREATE FUNCTION [dbo].[fn_StringToSTable] (@String Varchar(MAX))
RETURNS @T TABLE(ID Varchar(8000), AutoincID int identity (1,1))
AS
BEGIN
    DECLARE @ID Bigint
    DECLARE @tmp Varchar(MAX)
    
    SET @ID = 1
    
    IF @String = ''
        RETURN
        
    WHILE @ID <> 0
    BEGIN
        SET @ID = CHARINDEX(',', @String, 1)        
        IF @ID = 0
            INSERT INTO @T (ID) VALUES(@String)
        ELSE
            INSERT INTO @T (ID) VALUES((SUBSTRING(@String, 1, @ID - 1)))
        SET @String = SUBSTRING(@String, @ID+1, LEN(@String))
    END
    
    RETURN
END
GO