SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   29.01.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   29.01.2015$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [manufacture].[sp_MDSWriteStatisticTestDataToMove_Select]
    @JobStageID int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @StorageStructureID int, @Name varchar(255)
    DECLARE @Query varchar(max)
    DECLARE @NotIns1 bit, @NotIns2 bit, @NotIns3 bit, @NotIns4 bit, @NotIns5 bit, @NotIns6 bit, @NotIns7 bit, @NotIns8 bit

    SELECT @NotIns1 = c.[CheckDB] FROM manufacture.JobStageChecks c WHERE c.JobStageID = @JobStageID AND c.SortOrder = 1
    SELECT @NotIns2 = c.[CheckDB] FROM manufacture.JobStageChecks c WHERE c.JobStageID = @JobStageID AND c.SortOrder = 2
    SELECT @NotIns3 = c.[CheckDB] FROM manufacture.JobStageChecks c WHERE c.JobStageID = @JobStageID AND c.SortOrder = 3
    SELECT @NotIns4 = c.[CheckDB] FROM manufacture.JobStageChecks c WHERE c.JobStageID = @JobStageID AND c.SortOrder = 4
    SELECT @NotIns5 = c.[CheckDB] FROM manufacture.JobStageChecks c WHERE c.JobStageID = @JobStageID AND c.SortOrder = 5
    SELECT @NotIns6 = c.[CheckDB] FROM manufacture.JobStageChecks c WHERE c.JobStageID = @JobStageID AND c.SortOrder = 6
    SELECT @NotIns7 = c.[CheckDB] FROM manufacture.JobStageChecks c WHERE c.JobStageID = @JobStageID AND c.SortOrder = 7
    SELECT @NotIns8 = c.[CheckDB] FROM manufacture.JobStageChecks c WHERE c.JobStageID = @JobStageID AND c.SortOrder = 8    


    CREATE TABLE #StressTestStepData (
      [NAME] varchar(255) NULL,
      StorageStructureID int,
      [Column1] varchar(255) COLLATE Cyrillic_General_CI_AS NULL,
      [Column2] varchar(255) COLLATE Cyrillic_General_CI_AS NULL,
      [Column3] varchar(255) COLLATE Cyrillic_General_CI_AS NULL,
      [Column4] varchar(255) COLLATE Cyrillic_General_CI_AS NULL,
      [Column5] varchar(255) COLLATE Cyrillic_General_CI_AS NULL,
      [Column6] varchar(255) COLLATE Cyrillic_General_CI_AS NULL,
      [Column7] varchar(255) COLLATE Cyrillic_General_CI_AS NULL,
      [Column8] varchar(255) COLLATE Cyrillic_General_CI_AS NULL,
      SortOrder int)


    DECLARE Cur CURSOR FOR SELECT a.StorageStructureID, ss.[Name] FROM manufacture.StressTestStepData a 
                           INNER JOIN manufacture.StorageStructure ss ON ss.ID = a.StorageStructureID 
                           GROUP BY a.StorageStructureID, ss.[Name]
                           ORDER BY a.StorageStructureID
    OPEN Cur
    FETCH NEXT FROM Cur INTO @StorageStructureID, @Name
    WHILE @@FETCH_STATUS = 0
    BEGIN
        /*МИН*/
        INSERT INTO #StressTestStepData([NAME], StorageStructureID, Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8, SortOrder)
        SELECT TOP 1 @Name AS [Name], @StorageStructureID, 
            CASE WHEN ISNULL(@NotIns1, 1) = 1 THEN a.Column1 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns2, 1) = 1 THEN a.Column2 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns3, 1) = 1 THEN a.Column3 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns4, 1) = 1 THEN a.Column4 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns5, 1) = 1 THEN a.Column5 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns6, 1) = 1 THEN a.Column6 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns7, 1) = 1 THEN a.Column7 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns8, 1) = 1 THEN a.Column8 ELSE NULL END, 
            ROW_NUMBER() OVER (ORDER BY CAST(RIGHT(Column1, LEN(Column1)-3) AS int),
                                        CAST(RIGHT(Column2, LEN(Column2)-3) AS int),
                                        CAST(RIGHT(Column3, LEN(Column3)-3) AS int),
                                        CAST(RIGHT(Column4, LEN(Column4)-3) AS int),
                                        CAST(RIGHT(Column5, LEN(Column5)-3) AS int),
                                        CAST(RIGHT(Column6, LEN(Column6)-3) AS int),
                                        CAST(RIGHT(Column7, LEN(Column7)-3) AS int),
                                        CAST(RIGHT(Column8, LEN(Column8)-3) AS int)) AS SortOrder
        FROM manufacture.StressTestStepData a
        WHERE a.StorageStructureID = @StorageStructureID
        ORDER BY CAST(RIGHT(Column1, LEN(Column1)-3) AS int),
                 CAST(RIGHT(Column2, LEN(Column2)-3) AS int),
                 CAST(RIGHT(Column3, LEN(Column3)-3) AS int),
                 CAST(RIGHT(Column4, LEN(Column4)-3) AS int),
                 CAST(RIGHT(Column5, LEN(Column5)-3) AS int),
                 CAST(RIGHT(Column6, LEN(Column6)-3) AS int),
                 CAST(RIGHT(Column7, LEN(Column7)-3) AS int),
                 CAST(RIGHT(Column8, LEN(Column8)-3) AS int)
        /*МАКС*/
        INSERT INTO #StressTestStepData([NAME], StorageStructureID, Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8, SortOrder)
        SELECT TOP 1 @Name, @StorageStructureID, 
            CASE WHEN ISNULL(@NotIns1, 1) = 1 THEN a.Column1 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns2, 1) = 1 THEN a.Column2 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns3, 1) = 1 THEN a.Column3 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns4, 1) = 1 THEN a.Column4 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns5, 1) = 1 THEN a.Column5 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns6, 1) = 1 THEN a.Column6 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns7, 1) = 1 THEN a.Column7 ELSE NULL END, 
            CASE WHEN ISNULL(@NotIns8, 1) = 1 THEN a.Column8 ELSE NULL END, 
            11 + ROW_NUMBER() OVER (ORDER BY CAST(RIGHT(Column1, LEN(Column1)-3) AS int),
                                        CAST(RIGHT(Column2, LEN(Column2)-3) AS int),
                                        CAST(RIGHT(Column3, LEN(Column3)-3) AS int),
                                        CAST(RIGHT(Column4, LEN(Column4)-3) AS int),
                                        CAST(RIGHT(Column5, LEN(Column5)-3) AS int),
                                        CAST(RIGHT(Column6, LEN(Column6)-3) AS int),
                                        CAST(RIGHT(Column7, LEN(Column7)-3) AS int),
                                        CAST(RIGHT(Column8, LEN(Column8)-3) AS int) DESC) AS SortOrder
        FROM manufacture.StressTestStepData a
        WHERE a.StorageStructureID = @StorageStructureID    
        ORDER BY CAST(RIGHT(Column1, LEN(Column1)-3) AS int) DESC,
                 CAST(RIGHT(Column2, LEN(Column2)-3) AS int) DESC,
                 CAST(RIGHT(Column3, LEN(Column3)-3) AS int) DESC,
                 CAST(RIGHT(Column4, LEN(Column4)-3) AS int) DESC,
                 CAST(RIGHT(Column5, LEN(Column5)-3) AS int) DESC,
                 CAST(RIGHT(Column6, LEN(Column6)-3) AS int) DESC,
                 CAST(RIGHT(Column7, LEN(Column7)-3) AS int) DESC,
                 CAST(RIGHT(Column8, LEN(Column8)-3) AS int) DESC 

        FETCH NEXT FROM Cur INTO @StorageStructureID, @Name
    END
    CLOSE Cur
    DEALLOCATE CUR

    SELECT * FROM #StressTestStepData
    ORDER BY StorageStructureID, SortOrder

    DROP TABLE #StressTestStepData
END
GO