SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   23.06.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   23.06.2011$
--$Version:    1.00$   $Decription: Вход-строка с циферками ччерез зяпятую, выход таблица с ID$
CREATE FUNCTION [dbo].[fn_StringToITable] (@String Varchar(MAX))
RETURNS @T TABLE(ID Bigint)
AS
BEGIN
    DECLARE @ID Bigint
    DECLARE @tmp Varchar(MAX)
    
    SET @ID  = 1
    
    IF @String = ''
        RETURN
        
    WHILE @ID <> 0
    BEGIN
		SET @ID = CHARINDEX(',', @String, 1)		
		IF @ID = 0
		BEGIN
			IF ISNUMERIC(@String) = 1 			     
				INSERT INTO @T (ID) VALUES(@String)
		END
		ELSE
		BEGIN
			IF ISNUMERIC(SUBSTRING(@String, 1, @ID - 1)) = 1 
				INSERT INTO @T (ID) VALUES((SUBSTRING(@String, 1, @ID - 1)))
        END
        SET @String = SUBSTRING(@String, @ID+1, LEN(@String))        
    END

    RETURN
END
GO