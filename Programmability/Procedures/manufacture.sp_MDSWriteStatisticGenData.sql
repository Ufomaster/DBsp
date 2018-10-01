SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   21.05.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   5.06.2014$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [manufacture].[sp_MDSWriteStatisticGenData]
    @StartFrom int, 
    @Step int, 
    @Count int,
    @Prefix varchar(50),
    @Size int
AS
BEGIN   
    DECLARE @StepCounter int, @Zeros varchar(50)
    DECLARE @Out TABLE (ID int identity(1,1), Number varchar(255))
    SELECT @Zeros = REPLICATE('0', @Size)
    SELECT @StepCounter = 1 -- first refresh

    WHILE @Count > 0
    BEGIN
        SET @Count = @Count - 1
        IF @Step = 0
        BEGIN
            INSERT INTO @Out(Number)
            SELECT @Prefix + RIGHT(@Zeros + CAST(@StartFrom AS varchar), @Size)
            SET @StartFrom = @StartFrom + 1
        END
        ELSE
        BEGIN
            SELECT @StepCounter = CASE WHEN @StepCounter = @Step THEN 1 ELSE @StepCounter + 1 END
            
            INSERT INTO @Out(Number)
            SELECT @Prefix + RIGHT(@Zeros + CAST(@StartFrom AS varchar), @Size)
            
            IF @StepCounter = 1
                SET @StartFrom = @StartFrom + 1
        END
    END

    SELECT * FROM @Out ORDER BY ID
END
GO