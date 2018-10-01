SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$	$Create date:   10.09.2015$*/
/*$Modify:     Yuriy Oleynik$	$Modify date:   21.09.2016$*/
/*$Version:    1.00$   $Decription: Обрабтываем формулу - заменяем параметры значениями$*/
CREATE FUNCTION [dbo].[fn_ComposeFormula] (@Formula Varchar(8000) = NULL)
    RETURNS Varchar(8000)
AS
BEGIN
    DECLARE @Name varchar(255), @ParamValue varchar(5000), @CharIndexFormula Varchar(8000)
    DECLARE @DefenceCounter int, @ErrorMessage nvarchar(4000)
    
    SET @DefenceCounter = 0

    DECLARE #Cur CURSOR STATIC LOCAL FOR SELECT 
                                p.[Name],
                                p.ParamValue
                            FROM ConsumptionRatesParams p
                            WHERE p.ParamValue IS NOT NULL
    --для того чтобы проигнорировать собачки в глобальных параметрах @Count и @C_Count чтобы не зациклилось - тупо заменим их на фигню.
    --а замену проводить будем в @Formula, то есть @CharIndexFormula это только для цикла.
    SELECT @CharIndexFormula = REPLACE(@Formula, '@Count', 'CharIndexParam')
    SELECT @CharIndexFormula = REPLACE(@CharIndexFormula, '@C_Count', 'CharIndexParam')       
    WHILE CHARINDEX('@', @CharIndexFormula) > 0 
    BEGIN
        OPEN #Cur
        FETCH NEXT FROM #Cur INTO @Name, @ParamValue
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @Formula = REPLACE(@Formula, @Name, @ParamValue) 
            FETCH NEXT FROM #Cur INTO @Name, @ParamValue
        END
        SELECT @CharIndexFormula = REPLACE(@Formula, '@Count', 'CharIndexParam')
        SELECT @CharIndexFormula = REPLACE(@CharIndexFormula, '@C_Count', 'CharIndexParam')
        SET @DefenceCounter = @DefenceCounter + 1
        IF @DefenceCounter = 100 --врядли будет столько замен когда либо. Ситчаем что цикл зациклился.
        BEGIN
            --SET @ErrorMessage = 'Ошибка_зацикливания_компоновки_формулы_для_расчета_материалов'
            CLOSE #Cur
            DEALLOCATE #Cur
            RETURN(@Formula)
           -- RETURN(@ErrorMessage)
        END     
        CLOSE #Cur
    END

    DEALLOCATE #Cur
        
    RETURN(@Formula)
END
GO