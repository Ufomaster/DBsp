SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   12.03.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   14.10.2014$*/
/*$Version:    1.00$   $Description: Проверяем корректность импорта$*/
CREATE PROCEDURE [manufacture].[sp_PTmcImportTemplateColumns_Check]
  @JobStageID int,
  /*string with TMCs ID*/
  @TMCs varchar(1000)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
    DECLARE @ErrStr varchar(1000)

    SET @ErrStr = null
    SELECT top 1 @ErrStr = 'В шаблоне импорта нет ''' + t.[Name] +''' или для него не была установлена проверка взаимосвязи. Удалите из импортируемых ТМЦ или создайте новый шаблон.'
    FROM (SELECT ID, count(*) as cnt FROM fn_StringToITable(@TMCs) GROUP BY ID) tt
         LEFT JOIN (SELECT itc.ID, count(*) as cnt 
                    FROM manufacture.PTmcImportTemplateColumns itc
                         LEFT JOIN manufacture.PTmcImportTemplates it on it.ID = itc.TemplateImportID
                         LEFT JOIN manufacture.JobStageChecks jsc on jsc.ImportTemplateColumnID = itc.ID
                    WHERE it.JobStageID = @JobStageID    
                          AND ISNULL(jsc.isDeleted,0) = 0
                          AND jsc.[CheckDB] = 1
                         -- AND jsc.CheckLink = 1                              
                    GROUP BY itc.ID) itc on itc.ID = tt.ID
         LEFT JOIN manufacture.PTmcImportTemplateColumns itcTmc on itcTmc.ID = tt.ID           
         LEFT JOIN tmc t on itcTmc.TmcID = t.ID           
    WHERE itc.ID is null
          OR itc.cnt <> tt.cnt          
          
    IF @ErrStr is not null
	    RAISERROR (@ErrStr, 16, 1)  
	ELSE
    BEGIN
        SET @ErrStr = null
        SELECT top 1 @ErrStr = 'В шаблоне предполагалось наличие ''' + t.[Name] +'''. Добавьте в импортируемые ТМЦ или подправьте шаблон.'
        FROM (SELECT ID, count(*) as cnt FROM fn_StringToITable(@TMCs) GROUP BY ID) tt
             RIGHT JOIN (SELECT itc.ID, count(*) as cnt 
                        FROM manufacture.PTmcImportTemplateColumns itc
                             LEFT JOIN manufacture.PTmcImportTemplates it on it.ID = itc.TemplateImportID
                        	 LEFT JOIN manufacture.JobStageChecks jsc on jsc.ImportTemplateColumnID = itc.ID
                        WHERE it.JobStageID = @JobStageID    
                              AND ISNULL(jsc.isDeleted,0) = 0
                              AND jsc.[CheckDB] = 1
                             -- AND jsc.CheckLink = 1                              
                        GROUP BY itc.ID) itc on itc.ID = tt.ID
             LEFT JOIN manufacture.PTmcImportTemplateColumns itcTmc on itcTmc.ID = itc.ID                                   
             LEFT JOIN tmc t on itcTmc.TmcID = t.ID           
        WHERE tt.ID is null
              OR itc.cnt <> tt.cnt      
                 
        IF @ErrStr is not null
            RAISERROR (@ErrStr, 16, 1)                
    END

    SELECT @JobStageID AS ID    
END
GO