SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   20.07.2016$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   06.10.2016$*/
/*$Version:    1.00$   $Decription: Получаем значение из указанной таблицы на основании заданного параметра$*/
CREATE FUNCTION [dbo].[fn_GetTableValue] (@TableName varchar(255), @Value decimal(38,10), @RoundType varchar(4) = 'AVG')
RETURNS decimal(38,10)
AS
BEGIN    
    DECLARE @MinID int, @MaxID int, @MinCount decimal(38,10), @MaxCount decimal(38,10), @MinValue decimal(38,10), @MaxValue decimal(38,10), @Res decimal(38,10)
    
    IF @TableName = 'Plastic' 
    BEGIN
        SELECT @MinID = max(pc.ID)
        FROM Library.PlasticCalc pc 
        WHERE pc.[Value] <= @Value

        SELECT @MaxID = min(pc.ID)
        FROM Library.PlasticCalc pc 
        WHERE pc.[Value] >= @Value

        SELECT @MinCount = Count, @MinValue = Value
        FROM Library.PlasticCalc pc 
        WHERE pc.ID = @MinID

        SELECT @MaxCount = Count, @MaxValue = Value
        FROM Library.PlasticCalc pc 
        WHERE pc.ID = @MaxID
    END    
    
    IF @TableName = 'Carton' 
    BEGIN
        SELECT @MinID = max(pc.ID)
        FROM Library.CartonCalc pc 
        WHERE pc.[Value] <= @Value

        SELECT @MaxID = min(pc.ID)
        FROM Library.CartonCalc pc 
        WHERE pc.[Value] >= @Value

        SELECT @MinCount = Count, @MinValue = Value
        FROM Library.CartonCalc pc 
        WHERE pc.ID = @MinID

        SELECT @MaxCount = Count, @MaxValue = Value
        FROM Library.CartonCalc pc 
        WHERE pc.ID = @MaxID
    END        
    
    SELECT top 1 @Res = ROUND(
            CASE WHEN @MinValue = @MaxValue THEN @MinCount 
                 WHEN @RoundType = 'MIN' THEN 
                      -- IF value is less then the minimal table value
                      CASE WHEN @MinValue is null THEN @MaxCount ELSE @MinCount END
                 WHEN @RoundType = 'MAX' THEN
                      -- IF value is more then the maximum table value     
                      CASE WHEN @MaxValue is null THEN @MinCount ELSE @MaxCount END          
                 WHEN @RoundType = 'AVG' THEN 
                      -- IF value is less then the minimal table value
                      CASE WHEN @MinValue is null THEN @MaxCount ELSE 
                          -- IF value is more then the maximum table value
                          CASE WHEN @MaxValue is null THEN @MinCount ELSE
                              (@Value - @MinValue)*(@MaxCount - @MinCount)/(@MaxValue - @MinValue) + @MinCount 
                          END 
                      END   
                 WHEN @RoundType = 'NEAR' THEN 
                      -- IF value is less then the minimal table value
                      CASE WHEN @MinValue is null THEN @MaxCount ELSE 
                          -- IF value is more then the maximum table value
                          CASE WHEN @MaxValue is null THEN @MinCount ELSE
                              -- IF value - min is less then max - value then Min ELSE Max
                              CASE WHEN (@Value - @MinValue) < (@MaxValue - @Value) THEN @MinCount ELSE @MaxCount 
                              END
                          END 
                      END                      
                 ELSE  0
            END,0)
          
    RETURN @Res
END
GO