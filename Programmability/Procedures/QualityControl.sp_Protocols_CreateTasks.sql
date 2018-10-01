SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   20.04.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   08.05.2015$*/
/*$Version:    1.00$   $Description: вызов создания задач по протоколам$*/
CREATE PROCEDURE [QualityControl].[sp_Protocols_CreateTasks]
    @ID Int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int
    DECLARE @tID int
    SET XACT_ABORT ON    
    IF NOT EXISTS(SELECT * FROM Tasks WHERE QCProtocolID = @ID)
    BEGIN 
        BEGIN TRAN
        BEGIN TRY
            DECLARE Cur CURSOR LOCAL STATIC FOR SELECT a.ID
                                                FROM QualityControl.ProtocolTasksTemplates a
            OPEN Cur
            FETCH NEXT FROM Cur INTO @tID
            WHILE @@FETCH_STATUS = 0 
            BEGIN
                INSERT INTO Tasks([Name], EmployeeAuthorID, AssignedToEmployeeID, 
                   ControlEmployeeID, [Status], CreateDate, [Type], BeginFromDate,
                   Severity, QCProtocolID)
                SELECT [Name], 
                    (SELECT EmployeeID FROM #CurrentUser),
                    AssignedToEmployeeID,
                    ControlEmployeeID, [Status], GetDate(), 
                    2, GetDate() + RepeatPeriod, 1, @ID
                FROM QualityControl.ProtocolTasksTemplates a
                WHERE a.ID = @tID

                FETCH NEXT FROM Cur INTO @tID
            END
            CLOSE Cur
            DEALLOCATE Cur                                  
            
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