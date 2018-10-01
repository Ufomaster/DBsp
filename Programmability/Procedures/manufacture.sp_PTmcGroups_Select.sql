SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   13.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   14.04.2017$*/
/*$Version:    2.00$   $Description: Выбираем данные из группировочной таблицы$*/
CREATE PROCEDURE [manufacture].[sp_PTmcGroups_Select]	
    @StorageStructureID smallint,
    @ArrayOfStatusesID varchar(2000),
    @isPacked bit,
    @NotIsActive bit
AS
BEGIN    
    SELECT CAST(t.XMLData.value('(/TMC/Props/Value)[1]', 'varchar(max)') AS varchar(max)) AS [Name]           
           , js.[Name] as JobName
           , t.ID as TmcID
           , js.ID as JobStageID
           , CAST(ROW_NUMBER() OVER (PARTITION BY ck.JobStageID ORDER BY ck.SortOrder) AS Varchar) + '. ' + ck.Name AS CheckName
    FROM       
        (SELECT s.TmcID, s.JobStageID       
         FROM manufacture.PTmcGroups s         
         INNER JOIN manufacture.PTmcStatuses ps on ps.ID = s.StatusID        
         INNER JOIN dbo.fn_StringToITable(@ArrayOfStatusesID) si on si.ID = s.StatusID
         WHERE (s.StorageStructureID IN (SELECT * FROM manufacture.fn_StorageStructureNode_Select(@StorageStructureID)) OR ps.AttachedToStorage = 0)
            AND isPacked IN (0, @isPacked)
         GROUP BY s.TmcID, s.JobStageID) AS gr
    INNER JOIN TMC t ON t.id = gr.TmcID
    LEFT JOIN manufacture.JobStages js on js.ID = gr.JobStageID
    LEFT JOIN manufacture.JobStageChecks ck ON ck.TmcID = gr.TmcID AND ISNULL(ck.isDeleted, 0) = 0 AND ck.JobStageID = gr.JobStageID
    WHERE (js.isActive = 1) OR (@NotIsActive = 1)
    ORDER BY ck.SortOrder 
END
GO