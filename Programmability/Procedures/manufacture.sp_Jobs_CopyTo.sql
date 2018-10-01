SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    	$Create date:   15.07.2016$*/
/*$Modify:     Yuriy Oleynik$       $Modify date:   15.07.2016$*/
/*$Version:    1.00$   $Description: Копирование этапа в работу*/
create PROCEDURE [manufacture].[sp_Jobs_CopyTo]
    @SourceStageID Int,
    @TargetJobID int,
    @EmployeeID int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int, @NewStageID int
    DECLARE @Ts TABLE(NewStageID int)
        
    SET XACT_ABORT ON
    BEGIN       
        BEGIN TRAN
        BEGIN TRY       
            INSERT INTO manufacture.JobStages(Name, isActive, ModemID, JobID, OperatorsCount, OutputTmcID, OutputNameFromCheckID,
              isDeleted, MinQuantity, EmptyStage, TekOp)
            OUTPUT INSERTED.ID INTO @Ts
            SELECT Name, 0, ModemID, @TargetJobID, OperatorsCount, OutputTmcID, NULL,
              0,0,0, TekOp
            FROM  manufacture.JobStages js
            WHERE ID = @SourceStageID
            
            SELECT @NewStageID = NewStageID FROM @Ts
            
            INSERT INTO manufacture.JobStageChecks(Name, JobStageID, SortOrder, TmcID, AddPrefix,
              AddSufix, DelBefore, DelAfter, CheckMask, CheckLink, CheckSortTmcID, CheckSortMsg, CheckSort,
              TypeID, CheckOrder, CheckCorrectPacking, CheckDB, isDeleted, ImportTemplateColumnID, CheckUniqOnInsert,
              MaxCount, MinCount, EqualityCheckID, UseMaskAsStaticValue, BarCodeDeviceKind, BarCodeType)
            SELECT Name, @NewStageID, SortOrder, TmcID, AddPrefix,
              AddSufix, DelBefore, DelAfter, CheckMask, CheckLink, CheckSortTmcID, CheckSortMsg, CheckSort,
              TypeID, CheckOrder, CheckCorrectPacking, [CheckDB], 0, NULL, CheckUniqOnInsert,
              MaxCount, MinCount, NULL, UseMaskAsStaticValue, BarCodeDeviceKind, BarCodeType
            FROM manufacture.JobStageChecks
            WHERE JobStageID = @SourceStageID AND ISNULL(isDeleted, 0) = 0
            ORDER BY SortOrder
            
            UPDATE j
            SET j.OutputNameFromCheckID = t.ID 
            FROM manufacture.JobStages j
            INNER JOIN manufacture.JobStageChecks t ON j.ID = t.JobStageID            
            INNER JOIN manufacture.JobStageChecks s ON s.SortOrder = t.SortOrder AND s.JobStageID = @SourceStageID
            INNER JOIN manufacture.JobStages js ON js.OutputNameFromCheckID = s.ID
            WHERE js.ID = @SourceStageID AND j.ID = @NewStageID
            
            UPDATE t
            SET t.EqualityCheckID = tE.ID
            FROM manufacture.JobStageChecks t            
            INNER JOIN manufacture.JobStageChecks s ON s.JobStageID = @SourceStageID
            INNER JOIN manufacture.JobStageChecks sE ON sE.ID = s.EqualityCheckID
            INNER JOIN manufacture.JobStageChecks tE ON tE.SortOrder = sE.SortOrder AND tE.JobStageID = @NewStageID
            WHERE t.JobStageID = @NewStageID

            
            EXEC [manufacture].[sp_JobStagesHistory_Insert] @EmployeeID, @NewStageID, 0            
            COMMIT TRAN        
        END TRY
        BEGIN CATCH
            SET @Err = @@ERROR
            IF @@TRANCOUNT > 0 ROLLBACK TRAN
            EXEC sp_RaiseError @ID = @Err
        END CATCH
    END
END
GO