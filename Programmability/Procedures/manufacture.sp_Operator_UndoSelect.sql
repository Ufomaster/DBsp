SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   19.08.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   19.08.2014$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_Operator_UndoSelect]
    @JobStageID int,
    @StorageStructureID int,
    @SomeID int
AS
BEGIN   
    SET NOCOUNT ON

    DECLARE @SomeTmcID int, @SomeColName varchar(255)

            SELECT TOP 1 @SomeTmcID = jj.TmcID, @SomeColName = itc.GroupColumnName
            FROM manufacture.JobStageChecks jj
            INNER JOIN manufacture.PTmcImportTemplateColumns itc ON itc.ID = jj.ImportTemplateColumnID
            WHERE jj.[CheckDB] = 1 AND jj.isDeleted = 0 AND jj.JobStageID = @JobStageID AND jj.TypeID = 2
            ORDER BY jj.SortOrder
            
        DECLARE @GroupColumnName varchar(255), @Name varchar(255), @TmcID int, @Query varchar(8000)

        SELECT @Query = ISNULL(@Query + ' UNION ALL ' + Char(13) + Char(10), '') +
            ' SELECT @ID AS G_ID, ID, [Value], ''' + jj.[Name] + ''' AS Name ' + Char(13) + Char(10) + 
            ' FROM StorageData.pTMC_' + CAST(jj.TmcID AS VarChar) + Char(13) + Char(10) + ' WHERE ID = ' +
            '(SELECT ' + ic.GroupColumnName + ' FROM [StorageData].G_'+ CAST(@JobStageID AS varchar) + 
            ' WHERE ID = @ID)' + Char(13) + Char(10)
        FROM manufacture.JobStageChecks jj 
        INNER JOIn manufacture.PTmcImportTemplateColumns ic ON ic.ID = jj.ImportTemplateColumnID
        WHERE ic.GroupColumnName IS NOT NULL AND jj.JobStageID = @JobStageID AND jj.isDeleted = 0
        ORDER BY jj.SortOrder
        
        
        SELECT
         @Query = ' DECLARE @ID int SELECT @ID = ID FROM [StorageData].G_' + CAST(@JobStageID AS varchar) + 
                  ' WHERE ' + @SomeColName + ' = ' + CAST(@SomeID AS varchar) + + Char(13) + Char(10) + @Query
        EXEC (@Query)
END
GO