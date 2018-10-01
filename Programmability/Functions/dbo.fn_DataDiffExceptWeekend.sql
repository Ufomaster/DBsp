SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   20.06.2014$
--$Modify:     Zapadinskiy Anatoliy$    $Modify date:   20.06.2014$
--$Version:    1.00$   $Decription: возвращает разницу между датами в секундах не учитывая выходные для периода с 9:00 - 18:00$
create FUNCTION [dbo].[fn_DataDiffExceptWeekend] (@db Datetime, @de Datetime)
RETURNS int
AS
BEGIN
  /* Function body */
    RETURN(
    SELECT SUM(datediff(s, case when @db > DateB then @db else DateB end,
                                      case when @de > DateE then DateE else @de end))
    FROM 
      (SELECT DateAdd(hh,9, c.[Date]) as DateB,  DateAdd(hh,18,c.[Date]) as DateE, c.isWeekend
      FROM Calendar c) cal
    WHERE DateB between DateAdd(d, DATEDIFF(d, 0, @db), 0) and @de
          AND DateE > @db
          AND cal.isWeekend = 0 )
END
GO