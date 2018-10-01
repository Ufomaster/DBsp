SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   26.08.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   15.10.2014$*/
/*$Version:    2.00$   $Description: Выбираем детальную часть из группировочной таблицы$*/
CREATE PROCEDURE [manufacture].[sp_PTmcGroups_SelectDetails]	
	@StorageStructureID smallint,
    @ArrayOfStatusesID varchar(2000),
	@isPacked bit,
    @JobStageID int,
    @TmcID int
AS
BEGIN
    DECLARE @StatusesID TABLE(ID tinyint identity(1,1), StatusID int)
    
    INSERT INTO @StatusesID(StatusID)
    SELECT ID FROM dbo.fn_StringToITable(@ArrayOfStatusesID)
    
    SELECT s.*
           , t.[Name]
           , ps.[Name] as StatusName
           , ss.[Name] as StorageName        
    FROM manufacture.PTmcGroups s
         LEFT JOIN TMC t on t.id = s.TmcID
         LEFT JOIN manufacture.PTmcStatuses ps on ps.ID = s.StatusID
         LEFT JOIN manufacture.StorageStructure ss on ss.ID = s.StorageStructureID
         INNER JOIN @StatusesID si on si.StatusID = ps.ID    
    WHERE 
        --Select all node under current
        (s.StorageStructureID in (SELECT * FROM manufacture.fn_StorageStructureNode_Select (@StorageStructureID)) OR ps.AttachedToStorage = 0)
        AND isPacked in (0, @isPacked)
        AND IsNull(s.JobStageID,0) = @JobStageID
        AND s.TmcID = @TmcID
END
GO