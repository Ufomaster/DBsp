SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   25.06.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   05.08.2014$*/
/*$Version:    1.00$   $Decription: $Фулскан по ТМЦ джобстейджа для сбора агрегированных данных*/
create PROCEDURE [manufacture].[sp_JobStages_ReloadStorage]
    @JobStageID int
AS
BEGIN
    DECLARE @TMCID int

    DECLARE #cur CURSOR FOR 
          SELECT a.TmcID 
          FROM manufacture.JobStageChecks a
          WHERE a.JobStageID = @JobStageID
          UNION
          SELECT s.OutputTmcID
          FROM manufacture.JobStages s
          WHERE s.ID = @JobStageID
    OPEN #cur
    FETCH NEXT FROM #cur INTO @TMCID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC manufacture.sp_PTmcGroups_Calculate @TMCID
        FETCH NEXT FROM #cur INTO @TMCID
    END
    CLOSE #cur
    DEALLOCATE #cur
END
GO