SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   03.03.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   26.06.2014$*/
/*$Version:    1.00$   $Decription: получаем усредненное время на выполнение импорта$*/
CREATE FUNCTION [manufacture].[fn_GetEverageTime] (@RowCount int)
RETURNS float
AS
BEGIN
	DECLARE @ETime float
    
    SET @ETime = (SELECT CEILING(Convert(float, sum(i.[Time]))/Convert(float, sum(i.Count)) * Convert(float,@RowCount) / 1000.0)
                 FROM manufacture.PTmcOperations i 
                 WHERE i.[Count] is not null 
                       AND i.[Time] is not null
                       AND i.OperationTypeID = 1)
    
    RETURN (SELECT IsNull(@ETime,30))
END
GO