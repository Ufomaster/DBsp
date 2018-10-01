SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   30.09.2016$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Create date:   30.09.2016$*/
/*$Version:    1.00$   $Description: Установка/снятие отметки об отрицание в таблице ComparisonRates$*/
create PROCEDURE [dbo].[sp_ConsumptionRatesDetails_Mark]
    @ObjectTypeID Int
AS
BEGIN
    SET NOCOUNT ON
    
    IF OBJECT_ID('tempdb..#ConsumptionRateDetails') IS NOT NULL
    UPDATE #ConsumptionRateDetails
    SET Negation  = CASE WHEN IsNull(Negation,0) = 0 THEN 1 ELSE 0 END
    WHERE ObjectTypeID = @ObjectTypeID
END
GO