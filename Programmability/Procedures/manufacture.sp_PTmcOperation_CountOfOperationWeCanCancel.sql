SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   23.01.2015$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   23.01.2015$*/
/*$Version:    1.00$   $Description: Можем ли мы удалить импорт$*/
create PROCEDURE [manufacture].[sp_PTmcOperation_CountOfOperationWeCanCancel]
	@JobStageID int
AS    
BEGIN
	SET NOCOUNT ON
/*
    SELECT COUNT(ID) FROM manufacture.PTmcOperations 
    WHERE JobStageID = @JobStageID AND IsNull(isCanceled,0) <> 1 
          AND not EXISTS(SELECT ID FROM manufacture.PTmcOperations WHERE OperationTypeID <> 1 AND JobStageID = @JobStageID)*/
    DECLARE @Query varchar(4000), @TableName varchar(50), @TableNameHistory varchar(50), @pTmcID int, @isError bit
            , @Err Int, @OperationID int          
            
    SELECT top 1 @OperationID = o.ID
    FROM manufacture.PTmcOperations o 
    WHERE o.JobStageID = @JobStageID
          AND IsNull(o.isCanceled,0) <> 1
    ORDER BY o.ID DESC
    	
    CREATE TABLE #CancelOperation(ID int)
    /*Can we delete this data*/
    DECLARE CRSI CURSOR STATIC LOCAL FOR
    SELECT itc.TmcID
    FROM manufacture.PTmcImportTemplateColumns itc
         LEFT JOIN manufacture.PTmcImportColumns ic on itc.ID = ic.ImportTemplateColumnID         
         LEFT JOIN manufacture.PTmcImportTemplates it on it.ID = itc.TemplateImportID
         LEFT JOIN manufacture.JobStageChecks jsc on jsc.ImportTemplateColumnID = itc.ID
    WHERE it.JobStageID = @JobStageID
          AND ic.OperationID = @OperationID
          AND (IsNull(it.isDeleted,0) = 0) 
    ORDER BY ic.ID
             
    OPEN CRSI        

    FETCH NEXT FROM CRSI INTO @pTmcID
    SET @isError = 0

    WHILE (@@FETCH_STATUS = 0) AND (@isError = 0)
    BEGIN                       
        SET @TableName = (SELECT manufacture.fn_GetPTmcTableName(@pTmcID))
        SET @TableNameHistory = (SELECT manufacture.fn_GetPTmcTableNameHistory(@pTmcID))        
            
        SELECT @Query = ' INSERT INTO #CancelOperation (ID)
                          SELECT pTMC.ID 
                          FROM ' + @TableName + ' pTMC
                              LEFT JOIN manufacture.PTmcOperations o on pTMC.OperationID = o.ID
                          WHERE (o.OperationTypeID <> 1 
                               OR pTMC.StatusID <> 1
                               OR pTMC.StorageStructureID is not null)
                               AND pTmc.OperationID = ' + CAST(@OperationID as varchar(13))
        EXEC (@Query)     

        SELECT @Query = ' INSERT INTO #CancelOperation (ID)
                          SELECT pTMC.pTMCID 
                          FROM ' + @TableNameHistory + ' pTMC
                              INNER JOIN ' + @TableNameHistory + ' pTMC2 on (pTmc.pTMCID = pTMC2.pTMCID) AND (pTmc.ID <> pTMC2.ID)
                              LEFT JOIN manufacture.PTmcOperations o on pTMC2.OperationID = o.ID                                  
                          WHERE pTmc.OperationID = ' + CAST(@OperationID as varchar(13)) + '
                                AND o.OperationTypeID <> 1'
                              
        EXEC (@Query)   
                        
        SELECT @isError = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
        FROM #CancelOperation
            
        FETCH NEXT FROM CRSI INTO @pTmcID
    END        
            
    CLOSE CRSI    
    DEALLOCATE CRSI       
        
    DROP TABLE #CancelOperation   

    SELECT CASE WHEN (@isError = 1) OR @OperationID is null THEN 0 ELSE 1 END
       
END
GO