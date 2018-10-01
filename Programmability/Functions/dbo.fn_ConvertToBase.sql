SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   04.05.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   04.05.2012$*/
/*$Version:    1.00$   $Decription: Конвертит десятичное число в число с основой от 2 до 36(от двоичного до 32-ричного) $*/
CREATE FUNCTION [dbo].[fn_ConvertToBase]  
(  
    @value AS Bigint,  
    @base AS Int  
) RETURNS Varchar(MAX) AS BEGIN  
  
    -- some variables  
    DECLARE @characters Char(36),  
            @result Varchar(MAX);  
  
    -- the encoding string and the default result  
    SELECT @characters = '0123456789abcdefghijklmnopqrstuvwxyz',  
           @result = '';  
  
    -- make sure it's something we can encode.  you can't have  
    -- base 1, but if we extended the length of our @character  
    -- string, we could have greater than base 36  
    IF @value < 0 OR @base < 2 OR @base > 36 RETURN NULL;  
  
    -- until the value is completely converted, get the modulus  
    -- of the value and prepend it to the result string.  then  
    -- devide the value by the base and truncate the remainder  
    WHILE @value > 0  
        SELECT @result = SUBSTRING(@characters, @value % @base + 1, 1) + @result,  
               @value = @value / @base;  
  
    -- return our results  
    RETURN @result;  
  
END
GO