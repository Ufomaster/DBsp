SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   30.04.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.01.2015$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_OperatorGetRangesByPlace]
    @JobStageID int, 
    @StorageStructureID int
AS
BEGIN 
    SET NOCOUNT ON        
    DECLARE @TMCID int, @Name varchar(255), @Query varchar(8000), @SomeColumnName varchar(800)
    CREATE TABLE #Ranges(ID int identity(1,1), Name varchar(255), MinVal varchar(255), MaxVal varchar(255))

    DECLARE Cur CURSOR STATIC LOCAL FOR
        SELECT
            j.TmcID,
            REPLACE(t.[Name], '''', ''''''),
            pic.GroupColumnName
        FROM manufacture.JobStageChecks j
        LEFT JOIN Tmc t ON t.ID = j.TmcID
        INNER JOIN manufacture.PTmcImportTemplateColumns pic ON pic.ID = j.ImportTemplateColumnID
        WHERE j.JobStageID = @JobStageID AND j.isDeleted = 0 AND /*j.TypeID = 2 AND*/ j.[CheckDB] = 1
        ORDER BY j.SortOrder
    OPEN Cur
    FETCH NEXT FROM Cur INTO @TmcID, @Name, @SomeColumnName
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @Query =
        'INSERT INTO #Ranges(Name, MinVal, MaxVal)
         SELECT ''' + @Name + ''',
                (SELECT [Value] FROM StorageData.pTMC_' + CAST(@TmcID AS varchar) + ' 
                 WHERE ID = (SELECT MIN(b.ID) FROM StorageData.pTMC_' + CAST(@TmcID AS varchar) + ' b 
                             INNER JOIN StorageData.G_' + CAST(@JobStageID AS Varchar) + ' g ON g.' +  @SomeColumnName + ' = b.ID
                             WHERE b.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + ')
                 ),
                (SELECT [Value] FROM StorageData.pTMC_' + CAST(@TmcID AS varchar) + ' 
                 WHERE ID = (SELECT MAX(b.ID) FROM StorageData.pTMC_' + CAST(@TmcID AS varchar) + ' b 
                             INNER JOIN StorageData.G_' + CAST(@JobStageID AS Varchar) + ' g ON g.' +  @SomeColumnName + ' = b.ID
                             WHERE b.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + ')
                 )'
        EXEC(@Query)

        FETCH NEXT FROM Cur INTO @TmcID, @Name, @SomeColumnName
    END
    CLOSE Cur
    DEALLOCATE Cur

    SELECT * FROM #Ranges

    DROP TABLE #Ranges
END
GO