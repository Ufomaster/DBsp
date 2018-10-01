SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Inna Kazantseva$	$Create date:   11.01.2007$*/
/*$Modify:     Inna Kazantseva$	$Modify date:   11.01.2007$*/
/*$Version:    1.00$   $Decription: Year, Quarter, Month translate$*/
CREATE FUNCTION [dbo].[fn_DatePartTranslate] (
	@Date datetime, 
	@DatePart tinyint /* 1 - Year, 2 - Quarter, 3 - Month, 4 - Декада, 5- День тижня*/
	)
	RETURNS varchar(30)
AS
BEGIN
	DECLARE @Res varchar(30), @Part int
	IF @DatePart = 1 BEGIN /*Year*/
		SET @Res = CONVERT(varchar(4), YEAR(@Date)) + ' - год'
	END ELSE IF @DatePart = 2 BEGIN /*Quarter*/
		SET @Part = DATEPART(qq, @Date)
		SET @Res = CASE WHEN @Part = 1 THEN 'I'
			WHEN @Part = 2 THEN 'II'
			WHEN @Part = 3 THEN 'III'
			ELSE 'IV' END + ' - Квартал'
	END ELSE IF @DatePart = 4 BEGIN /*Decada*/
		SET @Part = round(DATEPART(dd, @Date)/11,0)
		SET @Res = CASE 
			WHEN @Part = 0 THEN '  I Декада 01-10 '
			WHEN @Part = 1 THEN ' II Декада 11-20 '
			ELSE 'III Декада 21-31' END
	END ELSE IF @DatePart = 5 BEGIN /*День тижня*/
		SET @Part = DATEPART(w, @Date)
		SET @Res = CASE 
			WHEN @Part = 1 THEN 'Понедельник'
			WHEN @Part = 2 THEN 'Вторник'
			WHEN @Part = 3 THEN 'Середа'
			WHEN @Part = 4 THEN 'Четверг'
			WHEN @Part = 5 THEN 'Пятница'
			WHEN @Part = 6 THEN 'Суббота'
			ELSE 'Воскресенье' END
	END ELSE BEGIN /*Month*/
		SET @Part = MONTH(@Date)
		SET @Res = CASE WHEN @Part = 1 THEN 'Январь'
			WHEN @Part = 2 THEN 'Февраль'
			WHEN @Part = 3 THEN 'Март'
			WHEN @Part = 4 THEN 'Апрель'
			WHEN @Part = 5 THEN 'Май'
			WHEN @Part = 6 THEN 'Июнь'
			WHEN @Part = 7 THEN 'Июль'
			WHEN @Part = 8 THEN 'Август'
			WHEN @Part = 9 THEN 'Сентябрь'
			WHEN @Part = 10 THEN 'Октябрь'
			WHEN @Part = 11 THEN 'Ноябрь'
			ELSE 'Декабрь' END
	END
	RETURN @Res
END
GO