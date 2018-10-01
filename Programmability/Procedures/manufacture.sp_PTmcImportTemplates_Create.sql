SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   12.03.2014$*/
/*$Modify:     Poliatykin Oleksii$ 		$Modify date:   03.11.2017$*/
/*$Version:    2.00$   $Description: Формируем автоматически шаблон на основании списка проверок$*/
CREATE PROCEDURE [manufacture].[sp_PTmcImportTemplates_Create]
  @JobStageID int,
  @EmployeeID int
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int    
    DECLARE @NewID Int,
            @pTmcID int,
            @ColumnCountReal tinyint
    
    CREATE TABLE #t(ID Int)    

    IF EXISTS(SELECT * FROM manufacture.JobStages js WHERE js.ID = @JobStageID AND ISNULL(js.isDeleted,0) = 0 AND js.isActive = 0)
        RAISERROR ('Шаблон для импорта можно создавать только для активного этапа', 16, 1)
	ELSE     
    IF EXISTS(SELECT * FROM manufacture.PTmcImportTemplates it WHERE it.JobStageID = @JobStageID AND ISNULL(it.isDeleted,0) = 0)
        RAISERROR ('Шаблон импорта для данного этапа уже создан. Создание второго шаблона запрещено', 16, 1)
	ELSE 
    IF NOT EXISTS(SELECT * FROM manufacture.JobStageChecks jsc
                  WHERE jsc.JobStageID = @JobStageID
                        AND ISNULL(jsc.isDeleted,0) = 0
                        --AND jsc.[CheckDB] = 1
                        --AND jsc.CheckLink = 1
                  )
        RAISERROR ('Нет проверок для данного этапа', 16, 1)
	ELSE     
    BEGIN       
        BEGIN TRAN
        BEGIN TRY       
            INSERT INTO manufacture.PTmcImportTemplates (ModifyDate, EmployeeID, JobStageID)
            OUTPUT INSERTED.ID INTO #t        
            Values (GetDate(), @EmployeeID, @JobStageID)  
            
            SELECT @NewID = ID FROM #t            
            DROP TABLE #t            
            
            INSERT INTO manufacture.PTmcImportTemplateColumns([GroupColumnName], [TmcID], [TemplateImportID])
            SELECT 'Column_' + Convert(varchar(10), ROW_NUMBER() OVER(ORDER BY jsc.SortOrder))
                   , jsc.TmcID
                   , @NewID
            FROM manufacture.JobStageChecks jsc
            WHERE jsc.JobStageID = @JobStageID
                  AND ISNULL(jsc.isDeleted,0) = 0
                  --AND jsc.[CheckDB] = 1
                  --AND jsc.CheckLink = 1
                  AND jsc.UseMaskAsStaticValue = 0 --False            
	        ORDER BY jsc.SortOrder    
            
            --update JobStageChecks with new columns
            UPDATE tab
            SET ImportTemplateColumnID = ID
            FROM
                (SELECT Template.ID, Checks.ImportTemplateColumnID
                FROM
                    (SELECT ROW_NUMBER() OVER(ORDER BY itc.TmcID, itc.ID) as num
                           , itc.TmcID
                           , itc.ID
                    FROM manufacture.PTmcImportTemplateColumns itc
                    WHERE itc.TemplateImportID = @NewID) as Template
                LEFT JOIN
                    (SELECT ROW_NUMBER() OVER(ORDER BY jsc.TmcID, jsc.SortOrder) as num
                           , jsc.TmcID
                           , jsc.ID
                           , jsc.ImportTemplateColumnID
                    FROM manufacture.JobStageChecks jsc
                    WHERE jsc.JobStageID = @JobStageID
                          AND ISNULL(jsc.isDeleted,0) = 0
                          --AND jsc.[CheckDB] = 1
                          --AND jsc.CheckLink = 1
                          AND jsc.UseMaskAsStaticValue = 0
                     ) as Checks on (Template.TmcID = Checks.TmcID) AND (Template.Num = Checks.Num)
                ) as tab     
             
            --CREATE TABLES FOR pTMCs    
            SELECT @ColumnCountReal = count(*) 
            FROM manufacture.PTmcImportTemplateColumns itc
                 JOIN manufacture.PTmcImportTemplates it on it.ID = itc.TemplateImportID
            WHERE it.JobStageID = @JobStageID 
                AND  ISNULL(it.isDeleted,0) = 0           
            
            --IF group table for personolized TMC is not exists then create it
            EXEC manufacture.sp_pTMC_CreateGroupTable @JobStageID, @ColumnCountReal        
            
            DECLARE CRSI CURSOR STATIC LOCAL FOR
            SELECT t.TmcID
            FROM
                (SELECT jsc.TmcID as TmcID
                FROM manufacture.JobStageChecks jsc
                WHERE jsc.JobStageID = @JobStageID
                      AND ISNULL(jsc.isDeleted,0) = 0
                      AND jsc.UseMaskAsStaticValue = 0
                UNION 
                SELECT js.OutputTmcID
                FROM manufacture.JobStages js
                WHERE js.ID = @JobStageID
                      AND ISNULL(js.isDeleted,0) = 0) t
            GROUP BY t.TmcID    
             
            OPEN CRSI

            FETCH NEXT FROM CRSI INTO @pTmcID

            WHILE @@FETCH_STATUS=0
            BEGIN
                /*Create table if it isn't exists*/
                EXEC manufacture.sp_pTMC_CreateTable @pTmcID                 
                
	            FETCH NEXT FROM CRSI INTO @pTmcID
            END        
                            
            COMMIT TRAN        
        END TRY
        BEGIN CATCH
            SET @Err = @@ERROR
            IF @@TRANCOUNT > 0 ROLLBACK TRAN
            EXEC sp_RaiseError @ID = @Err
     		SET @NewID = -1;            
        END CATCH
    END   

    SELECT @NewID AS ID    
END
GO