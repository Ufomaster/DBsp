SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   17.07.2014$*/
/*$Modify:     Anatoliy Zapadinskiy$    $Modify date:   04.11.2014$*/
/*$Version:    1.00$   $Description: Фиксация операции ропверки коробка ящик $*/
CREATE PROCEDURE [manufacture].[sp_PTmc_BoxBoxOperationID_Update]
	@MainTmcID int,
    @JobStageID int,
    @EmployeeID int,
    @Number varchar(255)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int    
    SET XACT_ABORT ON
    DECLARE @TmcID int, @Query varchar(8000)
    
    BEGIN TRAN
    BEGIN TRY
        /*поиск входящего внутрь ТМЦ*/
        SELECT TOP 1 @TmcID = TmcID
        FROM manufacture.JobStageChecks j
        WHERE j.isDeleted = 0 AND
              j.JobStageID = @JobStageID AND
              j.TypeID = 1 AND
              j.SortOrder > (SELECT j.SortOrder
                             FROM manufacture.JobStageChecks j
                             WHERE j.isDeleted = 0 AND j.JobStageID = @JobStageID AND j.TmcID = @MainTmcID)
        ORDER BY j.SortOrder DESC

        /*создание операции с типом 3 -- подправил на 6, чтобы различить в логе как-то*/
        CREATE TABLE #t(ID int)
        INSERT INTO manufacture.PTmcOperations (ModifyDate, EmployeeID,  OperationTypeID, JobStageID)
        OUTPUT INSERTED.ID INTO #t
        SELECT GetDate(), @EmployeeID, 6, @JobStageID
        /*апдейт ТМЦ затронутых операцией*/
        INSERT INTO manufacture.PTmcOperationTmcs(OperationID, TmcID)
        SELECT ID, @MainTmcID
        FROM #t
        UNION ALL
        SELECT ID, @TmcID 
        FROM #t

        SET @Query =
        'UPDATE sd
         SET sd.OperationID = (SELECT ID FROM #t)
         FROM StorageData.pTMC_' + CAST(@TmcID AS Varchar)+ ' sd 
         WHERE sd.ParentTMCID = ' + CAST(@MainTmcID AS Varchar)+ ' AND 
               sd.ParentPTMCID = (SELECT a.ID
                                  FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar)+ ' a
                                  WHERE a.[Value] = ''' + @Number + ''')

         UPDATE sd
         SET sd.OperationID = (SELECT ID FROM #t)
         FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar)+ ' sd 
         WHERE sd.[Value] = ''' + @Number + ''''
                                  
        EXEC(@Query)
        --Запись в хистори
        SELECT @Query = 
        'INSERT INTO StorageData.pTMC_' + CAST(@TmcID AS Varchar)+ 'H (StatusID, StorageStructureID, ParentTMCID, pTmcID,
          ParentPTMCID,  ModifyDate,  ModifyEmployeeID,  OperationID,  EmployeeGroupsFactID,
          PackedDate, OperationType)
        SELECT StatusID, StorageStructureID, ParentTMCID, ID, ParentPTMCID, GetDate(), ' + CAST(@EmployeeID AS Varchar) +  ', 
        OperationID, EmployeeGroupsFactID, PackedDate, 1 
        FROM StorageData.pTMC_' + CAST(@TmcID AS Varchar)+ '
        WHERE ParentTMCID = ' + CAST(@MainTmcID AS Varchar)+ ' AND 
              ParentPTMCID = (SELECT a.ID
                              FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar)+ ' a
                              WHERE a.[Value] = ''' + @Number + ''')

        INSERT INTO StorageData.pTMC_' + CAST(@MainTmcID AS Varchar)+ 'H (StatusID, StorageStructureID, ParentTMCID, pTmcID,
          ParentPTMCID,  ModifyDate,  ModifyEmployeeID,  OperationID,  EmployeeGroupsFactID,
          PackedDate, OperationType)
        SELECT StatusID, StorageStructureID, ParentTMCID, ID, ParentPTMCID, GetDate(), ' + CAST(@EmployeeID AS Varchar) +  ', 
        OperationID, EmployeeGroupsFactID, PackedDate, 1 
        FROM StorageData.pTMC_' + CAST(@MainTmcID AS Varchar) + ' AS a
        WHERE a.[Value] = ''' + @Number + ''''
        EXEC(@Query)
        
        DROP TABLE #t   
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO