SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   21.05.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   05.06.2014$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_MDSWriteStatisticCreateData]
    @Count int, -- count per StorageStructureID
    @StorageStructureArrayOfID varchar(8000)
AS
BEGIN
    SET NOCOUNT ON
       
    DECLARE @StartFrom int, @Step int, @Prefix varchar(50), @Total int, @SortOrder int, @Size int
    CREATE TABLE #Out (ID int identity(1,1), [Column1] varchar(255), [Column2] varchar(255),  [Column3] varchar(255), [Column4] varchar(255),
      [Column5] varchar(255), [Column6] varchar(255), [Column7] varchar(255), [Column8] varchar(255))

    DECLARE @OutNum TABLE(ID int, Number varchar(255))
    DECLARE @SS TABLE (ID int IDENTITY(1,1), SSID int)
    
    INSERT INTO @SS(SSID)
    SELECT ID FROM dbo.fn_StringToITable(@StorageStructureArrayOfID)
    
    SELECT @Total = COUNT(SSID)*@Count FROM @SS
    
    --в схеме Полный набор на все рабочие места. Нужно сгенерить Каунт штук на 1-е рабочее место потом на второе и тд.
    DECLARE Cur CURSOR FOR SELECT StartFrom, Step, [Prefix], Size, ROW_NUMBER() OVER (ORDER BY ID)  FROM manufacture.StressTestSettings ORDER BY ID
    OPEN Cur
    FETCH NEXT FROM Cur INTO @StartFrom, @Step, @Prefix, @Size, @SortOrder
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO @OutNum(ID, Number)
        EXEC manufacture.sp_MDSWriteStatisticGenData @StartFrom, @Step, @Total, @Prefix, @Size
        
        IF @SortOrder > 1
        BEGIN 
            UPDATE a
            SET 
                a.Column2 = CASE WHEN @SortOrder = 2 THEN b.Number ELSE a.Column2 END,
                a.Column3 = CASE WHEN @SortOrder = 3 THEN b.Number ELSE a.Column3 END,
                a.Column4 = CASE WHEN @SortOrder = 4 THEN b.Number ELSE a.Column4 END,
                a.Column5 = CASE WHEN @SortOrder = 5 THEN b.Number ELSE a.Column5 END,
                a.Column6 = CASE WHEN @SortOrder = 6 THEN b.Number ELSE a.Column6 END,
                a.Column7 = CASE WHEN @SortOrder = 7 THEN b.Number ELSE a.Column7 END,
                a.Column8 = CASE WHEN @SortOrder = 8 THEN b.Number ELSE a.Column8 END
            FROM #Out a
            INNER JOIN @OutNum b ON a.ID = b.ID
        END
        ELSE
        BEGIN
            INSERT INTO #Out(Column1)
            SELECT Number FROM @OutNum
            ORDER BY ID
        END

        DELETE FROM @OutNum
        FETCH NEXT FROM Cur INTO @StartFrom, @Step, @Prefix, @Size, @SortOrder
    END
    CLOSE Cur
    DEALLOCATE Cur
        
    INSERT INTO manufacture.StressTestStepData(StorageStructureID, Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8)
    SELECT b.SSID, a.Column1,a.Column2,a.Column3,a.Column4,a.Column5,a.Column6,a.Column7,a.Column8 
    FROM #Out a
    INNER JOIN @SS b ON b.ID = ((a.ID-1)/@Count)+1
    ORDER BY a.ID
/*    ORDER BY CAST(RIGHT(a.Column1, LEN(Column1)-3) AS int),
             CAST(RIGHT(Column2, LEN(Column2)-3) AS int),
             CAST(RIGHT(Column3, LEN(Column3)-3) AS int),
             CAST(RIGHT(Column4, LEN(Column4)-3) AS int),
             CAST(RIGHT(Column5, LEN(Column5)-3) AS int),
             CAST(RIGHT(Column6, LEN(Column6)-3) AS int),
             CAST(RIGHT(Column7, LEN(Column7)-3) AS int),
             CAST(RIGHT(Column8, LEN(Column8)-3) AS int)*/
     
    DROP TABLE  #Out
END
GO