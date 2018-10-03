SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   23.01.2015$*/
/*$Modify:     Poliatykin Oleksii$      $Modify date:   03.10.2018$*/
/*$Version:    1.00$   $Description: Помечаем на удаление шаблон для импорта$*/
CREATE PROCEDURE [manufacture].[sp_PTmcImportTemplates_Delete] @JobStageID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @OperationID INT ,@Err INT ,@TemplateID INT ,@TmcID INT, @query VARCHAR(MAX), @CR varchar(5)
    SET @CR = CHAR(13) + CHAR(10)           
    DECLARE Cur_col CURSOR STATIC LOCAL FOR SELECT c.TmcID AS TmcID
                                            FROM manufacture.JobStages js
                                            INNER JOIN manufacture.PTmcImportTemplates i ON i.JobStageID = js.ID AND ISNULL(i.isDeleted,0) = 0
                                            INNER JOIN manufacture.PTmcImportTemplateColumns c ON c.TemplateImportID = i.ID
                                            WHERE js.ID = @JobStageID
                                            UNION
                                            SELECT js.OutputTmcID
                                            FROM manufacture.JobStages js
                                            WHERE js.ID = @JobStageID

    SELECT TOP 1 @OperationID = o.ID
    FROM manufacture.PTmcOperations o
    WHERE o.JobStageID = @JobStageID AND ISNULL(o.isCanceled, 0) <> 1
    ORDER BY o.ID DESC

    IF @OperationID IS NOT NULL
    BEGIN
        RAISERROR ('Удаление текущего шаблона импорта невозможно, поскольку были импортированы данные', 16, 1)
        RETURN
    END

    SELECT TOP 1  @TemplateID = ID
    FROM manufacture.PTmcImportTemplates it
    WHERE it.JobStageID = @JobStageID AND ISNULL(it.isDeleted, 0) <> 1   

    SET @query = ' DECLARE @Count int ' + @CR +
                 ' DECLARE @Err Int' + @CR +
                 ' SET XACT_ABORT ON' + @CR +
                 ' BEGIN TRAN' + @CR +
                 ' BEGIN TRY' + @CR +
                 ' UPDATE manufacture.PTmcImportTemplates SET isDeleted = 1 WHERE ID = ' + CAST(@TemplateID AS VARCHAR(MAX)) +  @CR 
    OPEN Cur_col
    FETCH NEXT FROM Cur_col INTO @TmcID
    WHILE @@fetch_status = 0
    BEGIN
        SET @query = @query + ' IF OBJECT_ID(''StorageData.pTMC_' + CAST(@TmcID AS VARCHAR(MAX)) + ''',''U'') is not null' + @CR +
                              ' IF NOT EXISTS (SELECT * FROM StorageData.pTMC_' + CAST(@TmcID AS VARCHAR(MAX)) + ') ' + @CR +
                              ' BEGIN ' + @CR +
                              ' DROP TABLE  StorageData.pTMC_' + CAST(@TmcID AS VARCHAR(MAX)) + @CR +
                              ' DROP TABLE  StorageData.pTMC_' + CAST(@TmcID AS VARCHAR(MAX)) + 'h ' + @CR +
                              ' END '

    FETCH NEXT FROM Cur_col INTO @TmcID
    END
    CLOSE Cur_col
    DEALLOCATE Cur_col

    SET @query = @query + ' UPDATE manufacture.JobStages SET isActive = 0 WHERE id = ' + CAST(@JobStageID AS VARCHAR(MAX)) + @CR +
                          ' UPDATE manufacture.JobStageChecks SET ImportTemplateColumnID = NULL WHERE JobStageID = ' + CAST(@JobStageID AS VARCHAR(MAX)) + @CR +
                          ' IF OBJECT_ID(''StorageData.G_' + CAST(@JobStageID AS VARCHAR(20)) + ''',''U'') is not null' + @CR +
                          ' DROP TABLE StorageData.G_' + CAST(@JobStageID AS VARCHAR(20)) +  @CR +
                          ' COMMIT' + @CR +
                          ' END TRY' + @CR +
                          ' BEGIN CATCH' + @CR +
                          '    SET @Err = @@ERROR;' + @CR +
                          '    IF @@TRANCOUNT > 0 ROLLBACK TRAN' + @CR +
                          '    EXEC sp_RaiseError @ID = @Err;' + @CR +
                          ' END CATCH' + @CR

    EXEC (@query)
    --SELECT @query
        
    EXEC manufacture.sp_Pallets_DropTables @JobStageID
END
GO