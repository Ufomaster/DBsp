SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   11.06.2008$
--$Modify:     Yuriy Oleynik$	$Modify date:   22.02.2012$
--$Version:    1.00$   $Decription: дата в строку$
CREATE FUNCTION [dbo].[fn_DateToString] (@D Datetime, @Format Varchar(14) = NULL )
    RETURNS Varchar(20)
AS
BEGIN
    RETURN(
	CASE @Format
	WHEN 'ddmmyy' THEN
		CASE WHEN DAY(@D) >9 THEN '' ELSE '0' END + CAST(DAY(@D) AS Varchar(2) )+ '.' + CASE WHEN MONTH(@D) >9 THEN '' ELSE '0' END + CAST(MONTH(@D) AS Varchar(2)) + '.' + RIGHT( CAST(YEAR(@D) AS Varchar(4)) , 2)

    WHEN 'ddmmyyyy' THEN
        CASE WHEN DAY(@D) >9 THEN '' ELSE '0' END + CAST(DAY(@D) AS Varchar(2) )+ '.' + CASE WHEN MONTH(@D) >9 THEN '' ELSE '0' END + CAST(MONTH(@D) AS Varchar(2)) + '.' + CAST(YEAR(@D) AS Varchar(4))

/*    WHEN 'd mmmm yyyy' THEN
        CAST(DAY(@D) AS varchar(2) )+ ' ' + dbo.stf_MONTH2String(MONTH(@D), '')  + ' ' + CAST(YEAR(@D) AS varchar(4))

    WHEN 'd mmmm yyyy[R]' THEN
        CAST(DAY(@D) AS varchar(2) )+ ' ' + dbo.stf_MONTH2String(MONTH(@D), 'R')  + ' ' + CAST(YEAR(@D) AS varchar(4))*/

    WHEN 'mdyyyy' THEN
        CAST(MONTH(@D) AS Varchar(2) )+ '.' + CAST(DAY(@D) AS Varchar(2)) + '.' + CAST(YEAR(@D) AS Varchar(4))

    WHEN 'hh:nn' THEN
        CAST(DATEPART( hh, @D) AS Varchar(2) )+ ':' + CASE WHEN DATEPART( n, @D)  < 10 THEN '0' ELSE '' END + CAST(DATEPART( n, @D) AS Varchar(2) )
    WHEN 'hh:nn:ss' THEN
        CAST(DATEPART( hh, @D) AS Varchar(2) )+ ':' + CASE WHEN DATEPART( n, @D)  < 10 THEN '0' ELSE '' END + CAST(DATEPART( n, @D) AS Varchar(2) )+ ':' + CASE WHEN DATEPART(ss, @D)  < 10 THEN '0' ELSE '' END + CAST(DATEPART(ss, @D) AS Varchar(2))
            
    WHEN 'yyyymmdd' THEN
        CAST(YEAR(@D) AS Varchar(4)) + CASE WHEN MONTH(@D) >9 THEN '' ELSE '0' END + CAST(MONTH(@D) AS Varchar(2)) + CASE WHEN DAY(@D) >9 THEN '' ELSE '0' END + CAST(DAY(@D) AS Varchar(2))
   
      ELSE
        CASE WHEN DAY(@D) >9 THEN '' ELSE '0' END + CAST(DAY(@D) AS Varchar(2) )+ '.' + CASE WHEN MONTH(@D) >9 THEN '' ELSE '0' END + CAST(MONTH(@D) AS Varchar(2)) + '.' + CAST(YEAR(@D) AS Varchar(4))
    END
    )
END
GO

GRANT EXECUTE ON [dbo].[fn_DateToString] TO [QlikView]
GO