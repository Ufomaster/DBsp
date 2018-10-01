SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   16.07.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   12.08.2014$*/
/*$Version:    1.00$   $Description: Выбор списка внутренних ТМЦ в ТМЦ $*/
CREATE PROCEDURE [manufacture].[sp_PTmc_GetInners]
	@MainTmcID int,
    @Number varchar(255),
    @JobStageID int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @TmcID int, @Query varchar(8000)      

    --поиск входящего внутрь ТМЦ
    SELECT TOP 1 @TmcID = TmcID
    FROM manufacture.JobStageChecks j
    WHERE j.isDeleted = 0 AND
          j.JobStageID = @JobStageID AND
          j.SortOrder > (SELECT  top 1 j.SortOrder
                         FROM manufacture.JobStageChecks j
                         WHERE j.isDeleted = 0 AND j.JobStageID = @JobStageID AND j.TmcID = @MainTmcID ORDER BY j.ID)
    ORDER BY j.SortOrder
    
    
    SET @Query = 'INSERT INTO #Box(ID, State, [Value]) ' +
    'SELECT sd.ID, 0, sd.[Value]
     FROM StorageData.pTMC_' + CAST(@TmcID AS Varchar)+ ' sd 
     WHERE sd.ParentTMCID = ' + CAST(@MainTmcID AS Varchar)+ ' AND 
          sd.ParentPTMCID = (SELECT a.ID
                            FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar)+ ' a
                            WHERE a.[Value] = ''' + @Number + ''')'
                            
    EXEC(@Query)
    --SELECT * FROM #Box
END
GO