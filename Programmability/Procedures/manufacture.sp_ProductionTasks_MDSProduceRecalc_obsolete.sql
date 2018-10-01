SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   00.13.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   19.05.2017$*/
/*$Version:    1.00$   $Decription: Production for assembling     $*/
create PROCEDURE  [manufacture].[sp_ProductionTasks_MDSProduceRecalc_obsolete]
    @ShiftID int,
    @EmployeeID int,
    @MoveProdTaskID int,
    @MoveSectorID int
AS
BEGIN
    DECLARE @JobStageID int, @Err int,  @StorageStructureID int
    
    IF OBJECT_ID('tempdb..#MDSProduce') IS NOT NULL 
         TRUNCATE TABLE #MDSProduce ELSE 
    CREATE TABLE #MDSProduce (ID tinyint IDENTITY(1,1), --[Min] varchar(255), [Max] varchar(255), 
      [Amount] decimal(38, 10), TmcID int, isMajorTMC bit, EmployeeID int, Name varchar(255),
      StatusID int)
    DECLARE Cu CURSOR STATIC LOCAL FOR 
                              SELECT f.JobStageID, f.WorkPlaceID
                              FROM shifts.EmployeeGroupsFact f
                              INNER JOIN manufacture.JobStages js ON js.ID = f.JobStageID AND ISNULL(js.isDeleted, 0) = 0
                              INNER JOIN manufacture.StorageStructureSectorsDetails ssd ON ssd.StorageStructureID = f.WorkPlaceID
                              INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = ssd.StorageStructureSectorID AND ss.ID = @MoveSectorID
                              WHERE f.ShiftID = @ShiftID AND ISNULL(f.IsDeleted,0) = 0 AND f.JobStageID IS NOT NULL
                              GROUP BY f.JobStageID, f.WorkPlaceID
    OPEN CU
    FETCH NEXT FROM Cu INTO @JobStageID, @StorageStructureID
    WHILE @@FETCH_STATUS = 0
    BEGIN            
        BEGIN TRAN
        BEGIN TRY
            TRUNCATE TABLE #MDSProduce
            EXEC manufacture.sp_ProductionTasks_MDSProduceEx @JobStageID, @StorageStructureID, @MoveProdTaskID, @ShiftID, @EmployeeID, 0
            COMMIT TRAN      
        END TRY
        BEGIN CATCH
            SET @Err = @@ERROR
            IF @@TRANCOUNT > 0 ROLLBACK TRAN
            EXEC sp_RaiseError @ID = @Err
        END CATCH
        
        FETCH NEXT FROM Cu INTO @JobStageID, @StorageStructureID
    END
    CLOSE Cu
    DEALLOCATE Cu    
    IF OBJECT_ID('tempdb..#MDSProduce') IS NOT NULL 
       DROP TABLE #MDSProduce
END
GO