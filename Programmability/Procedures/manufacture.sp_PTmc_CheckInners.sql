SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   17.07.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   24.06.2015$*/
/*$Version:    1.00$   $Description: Проверка списка внутренних ТМЦ в ТМЦ $*/
CREATE PROCEDURE [manufacture].[sp_PTmc_CheckInners]
	@MainTmcID int,
    @FromNumber varchar(255),
    @ToNumber varchar(255),
    @JobStageID int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @TmcID int, @Query varchar(8000), @FromID int, @ToID int
    

    --поиск входящего внутрь ТМЦ
    SELECT TOP 1 @TmcID = TmcID
    FROM manufacture.JobStageChecks j
    WHERE j.isDeleted = 0 AND
          j.JobStageID = @JobStageID AND
          j.TypeID = 1 AND
          j.SortOrder > (SELECT top 1 j.SortOrder
                         FROM manufacture.JobStageChecks j
                         WHERE j.isDeleted = 0 AND j.JobStageID = @JobStageID AND j.TmcID = @MainTmcID
                         ORDER BY j.ID)
    ORDER BY j.SortOrder
    
    --Елси есть внутри тара, проводим следующую проверку не проходила ли проверку коробка ящик
    IF @TmcID IS NOT NULL
    BEGIN
        --поиск всех ИД тары которые не прошли проверку тары.
        --нужно найти и проверить все номера из диапазона- требуют ли они проверки сразу
        SELECT @Query =        
       'DECLARE @MinID int, @MaxID int
        SELECT @MinID = ID 
        FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar) + ' a WHERE a.[Value] = ''' + @FromNumber + ''' 

        SELECT @MaxID = ID 
        FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar) + ' a WHERE a.[Value] = ''' + @ToNumber + '''
        
        IF @MinID > @MaxID
        BEGIN
            SELECT @MinID = ID 
            FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar) + ' a WHERE a.[Value] = ''' + @ToNumber + ''' 

            SELECT @MaxID = ID 
            FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar) + ' a WHERE a.[Value] = ''' + @FromNumber + '''
        END
         
        INSERT INTO #Res(ID, Number)
        SELECT r.ID, r.[Value]
        FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar) + ' r
        LEFT JOIN StorageData.pTMC_' + CAST(@MainTmcID AS Varchar) + 'H h ON h.pTmcID = r.ID AND h.OperationID IN
                    (SELECT o.ID
                    FROM manufacture.PTmcOperationTmcs ot
                    INNER JOIN manufacture.PTmcOperations o ON o.ID = ot.OperationID AND 
                          ot.TmcID = ' + CAST(@MainTmcID AS Varchar) + ' AND 
                          o.JobStageID = ' + CAST(@JobStageID AS Varchar) + ' AND 
                          o.OperationTypeID = 6)
        WHERE r.ID BETWEEN @MinID AND @MaxID
        AND h.ID IS NULL
        AND r.PackedDate IS NOT NULL'
        EXEC(@Query)
    END
END
GO