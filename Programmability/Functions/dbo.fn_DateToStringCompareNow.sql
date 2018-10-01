SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$	$Create date:   02.12.2015$*/
/*$Modify:     Yuriy Oleynik$	$Modify date:   02.12.2015$*/
/*$Version:    1.00$   $Decription: дата в строку$*/
create FUNCTION [dbo].[fn_DateToStringCompareNow] (@InputDate datetime)
    RETURNS Varchar(30)
AS
BEGIN
    DECLARE @Now date, @D datetime
    SET @Now = GETDATE()
    SELECT @D = dbo.fn_DateCropTime(@InputDate)

    RETURN(
      SELECT
          CASE
            WHEN @D + 3 <= @Now THEN 10 /*'Давно'    */
            WHEN @D + 2 = @Now THEN 11 /*'Позавчера'*/
            WHEN @D + 1 = @Now THEN 12 /*'Вчера'      */
            WHEN @D     = @Now THEN 13 /*'Сегодня'*/
            WHEN @D - 1 = @Now THEN 14 /*'Завтра'*/
            WHEN @D - 2 = @Now THEN 15 /*'Послезавтра'*/
            WHEN @D - 3 = @Now THEN 16 /*'Через 2 дня'*/
            WHEN @D - 4 = @Now THEN 17 /*'Через 3 дня'*/
            WHEN @D - 5 >= @Now THEN 18 /*'Cкоро'*/
          END
    )
    /*тексты в vw_DateStringsCompareNow*/
END
GO