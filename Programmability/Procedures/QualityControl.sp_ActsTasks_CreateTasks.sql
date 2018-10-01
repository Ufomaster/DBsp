SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.04.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   08.05.2015$*/
/*$Version:    1.00$   $Description: создание реальных задач из шаблона акта НС$*/
CREATE PROCEDURE [QualityControl].[sp_ActsTasks_CreateTasks]
    @ID Int,
    @StatusID int,
    @EmployeeAuthorID int
AS
BEGIN
    DECLARE @Err Int
    DECLARE @T TABLE(TaskID int, ActTaskID int)
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF @StatusID = 0 /*создаются черновики*/
        BEGIN
            /*основной принцип - задачи это заготовки для реальных. 1 раз создали и актуальность задач в акте не поддерживается.        */
            /*акт не может менять созданные задачи. поэтому если есть уже кокретные задачи по текущему акту - ничего не делаем.*/
/*            IF EXISTS(SELECT ID FROM dbo.Tasks WHERE QCActID = @ID)
                SELECT 0  return and do nothing
            ELSE
            BEGIN*/
                /*Добавим добавленные*/
                DECLARE @ActTaskID int, @TasksType int
                DECLARE cur CURSOR STATIC LOCAL FOR SELECT a.ID, 
                                                        CASE  --vw_TasksTypes
                                                           WHEN t.ID IS NOT NULL THEN 1 
                                                           WHEN t2.ID IS NOT NULL THEN 5
                                                        ELSE 1
                                                        END
                                                    FROM QualityControl.ActsTasks a
                                                    INNER JOIN QualityControl.Acts ac ON ac.ID = a.ActID
                                                    LEFT JOIN Tasks ta ON ta.ID = a.TasksID
                                                    LEFT JOIN QualityControl.Protocols p ON p.ID = ac.ProtocolID                                                    
                                                    LEFT JOIN QualityControl.Types t ON t.ActTemplatesID = ac.ActTemplatesID AND t.ID = p.TypesID
                                                    LEFT JOIN QualityControl.Types t2 ON t2.ActTemplates2ID = ac.ActTemplatesID AND t2.ID = p.TypesID
                                                    WHERE a.ActID = @ID AND ta.ID IS NULL
                OPEN cur
                FETCH NEXT FROM cur INTO @ActTaskID, @TasksType
                WHILE @@FETCH_STATUS = 0
                BEGIN
                    INSERT INTO Tasks([Name], [EmployeeAuthorID], [AssignedToEmployeeID], [ControlEmployeeID], [Status], [CreateDate], [StartDate],
                        [FinishDate], [ResultMarkID], [Type], [Comment], [QCActID], BeginFromDate, Severity)
                    OUTPUT INSERTED.ID, @ActTaskID INTO @T
                    SELECT a.[Name], @EmployeeAuthorID, a.AssignedToEmployeeID, a.ControlEmployeeID, 0, GetDate(), NULL,
                        NULL, NULL, @TasksType, a.Comment, @ID, a.BeginFromDate, 1
                    FROM QualityControl.ActsTasks a
                    WHERE a.ID = @ActTaskID
                    
                    FETCH NEXT FROM cur INTO @ActTaskID, @TasksType                  
                END
                CLOSE cur
                DEALLOCATE cur

                UPDATE a
                SET a.TasksID = tt.TaskID
                FROM QualityControl.ActsTasks a
                INNER JOIN @T AS tt ON tt.ActTaskID = a.ID

                SELECT 0
/*            END*/
        END
        ELSE
        IF @StatusID = 1 /*апдейтим все черновики котоырм выставлен стартовый статус "в работу" - в работу.*/
        BEGIN
            UPDATE t
            SET t.[Status] = 1, t.StartDate = GetDate()
            FROM Tasks t
            INNER JOIN QualityControl.ActsTasks a ON a.TasksID = t.ID AND a.[Status] = 1
            WHERE a.ActID = @ID
            /*выбираем все задачи по которым будет послано сообщение.*/
            SELECT t.ID, t.AssignedToEmployeeID
            FROM Tasks t 
            INNER JOIN QualityControl.ActsTasks a ON a.TasksID = t.ID AND a.[Status] = 1
            WHERE a.ActID = @ID
        END

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO