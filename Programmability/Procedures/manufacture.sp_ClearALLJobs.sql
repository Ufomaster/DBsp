SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   13.10.2014$*/
/*$Modify:     Skliar Nataliia$    $Modify date:   15.06.2017$*/
/*$Version:    2.00$   $Description: Очищаем все таблицы + удаляем динамические. Используем на свой страх и риск $*/
CREATE PROCEDURE [manufacture].[sp_ClearALLJobs]
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @TableName varchar(255), @Err INT 
    
    BEGIN TRAN
    BEGIN TRY      
        DECLARE CRSI CURSOR STATIC LOCAL FOR
        select TABLE_NAME from information_schema.tables t
        WHERE t.TABLE_SCHEMA = 'StorageData'
        ORDER BY t.TABLE_NAME Desc

        OPEN CRSI

        FETCH NEXT FROM CRSI INTO @TableName

        WHILE @@FETCH_STATUS=0               
        BEGIN
            EXEC ('DROP TABLE StorageData.' + @TableName)    

            FETCH NEXT FROM CRSI INTO @TableName                     
        END    
                        
        CLOSE CRSI
        DEALLOCATE CRSI     

        UPDATE manufacture.JobStageChecks
        SET ImportTemplateColumnID = null
        
        DELETE FROM [manufacture].[StressTestAssmQueryLog]

        DELETE FROM manufacture.JobStageChecksHistory

        DELETE FROM manufacture.PTmcImportColumns

        DELETE FROM manufacture.PTmcImportTemplateColumns

        DELETE FROM manufacture.PTmcOperationTmcs

        DELETE FROM manufacture.PTmcOperations

        DELETE FROM manufacture.PTmcImportTemplates

        DELETE FROM manufacture.JobStagesHistory

        UPDATE manufacture.JobStages
        SET OutputNameFromCheckID = null
        
        DELETE FROM manufacture.PTmcGroups
        
        DELETE FROM manufacture.JobStageChecks
        
        DELETE FROM manufacture.PTmcFailRegister
        
        DELETE FROM shifts.EmployeeGroupsFactDetais
        
        DELETE FROM shifts.EmployeeGroupsFact    
           
        DELETE FROM manufacture.JobStageNonPersTMC     
        DELETE FROM manufacture.ProductionTasksDocsDetailsHistory   
        DELETE FROM manufacture.ProductionTasksDocsHistory           
        DELETE FROM manufacture.ProductionTasksDocDetails           
        DELETE FROM manufacture.ProductionTasksDocs
        DELETE FROM manufacture.ProductionTasksLog        
        DELETE FROM manufacture.ProductionTasksHistory
        DELETE FROM manufacture.ProductionTasks
        
        DELETE FROM manufacture.JobStages

        --DELETE FROM manufacture.Jobs
        
        COMMIT TRAN                
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH        
END
GO