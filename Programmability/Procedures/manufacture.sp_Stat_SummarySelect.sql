SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   18.06.2014$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   08.06.2017$*/
/*$Version:    1.00$   $Decription: Get summary statistic for JobStage $*/
CREATE PROCEDURE [manufacture].[sp_Stat_SummarySelect]
    @JobStageID int
AS
BEGIN   
    SET NOCOUNT ON
    DECLARE @SomeTmcID int, @SomeColumnName varchar(10), @Query varchar(5000)
    
    SELECT TOP 1 @SomeTmcID = a.TmcID
    FROM manufacture.JobStageChecks a
    WHERE a.JobStageID = @JobStageID AND a.TypeID = 2 AND a.isDeleted = 0 AND a.UseMaskAsStaticValue = 0
    ORDER BY a.SortOrder

    SELECT @SomeColumnName = itc.GroupColumnName
    FROM manufacture.PTmcImportTemplates it
         LEFT JOIN manufacture.JobStages js on js.ID = it.JobStageID 
         LEFT JOIN manufacture.PTmcImportTemplateColumns itc on itc.TemplateImportID = it.ID
    WHERE js.ID = @JobStageID AND itc.TmcID = @SomeTmcID
       
    SET @Query = 
    'SELECT 
         Count(*) as PackAll
         , SUM(CASE WHEN p.PackedDate is not null AND p.StatusID <> 4 AND p.StatusID <> 1 AND p.StatusID <> 2 THEN 1 ELSE 0 END) as Pack
         , Count(*) - SUM(CASE WHEN p.PackedDate is not null OR p.StatusID = 4 THEN 1 ELSE 0 END) as PackLeft
         , SUM(CASE WHEN p.StatusID = 4 THEN 1 ELSE 0 END) AS Failed
     FROM StorageData.G_' + CAST(@JobStageID AS Varchar(13)) +  ' AS g     
         LEFT JOIN StorageData.pTMC_'  + CAST(@SomeTmcID AS Varchar(13)) +  ' AS p ON p.ID = g.' + @SomeColumnName 
    EXEC (@Query)
END
GO