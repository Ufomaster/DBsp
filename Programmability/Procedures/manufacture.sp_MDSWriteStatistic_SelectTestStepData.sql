SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   29.05.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   31.10.2014$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_MDSWriteStatistic_SelectTestStepData]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StorageStructureID int, @Name varchar(255)
    DECLARE @Query varchar(max)

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
    OPEN Cur
    FETCH NEXT FROM Cur INTO @StorageStructureID, @Name
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO #StressTestStepData([NAME], StorageStructureID, Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8, SortOrder)
        SELECT TOP 3 @Name AS [Name], @StorageStructureID, a.Column1, a.Column2, a.Column3, a.Column4, a.Column5, a.Column6, a.Column7, a.Column8, 
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
     
        INSERT INTO #StressTestStepData([NAME], StorageStructureID, Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8, SortOrder)
        SELECT @Name, @StorageStructureID, '...', '...', '...', '...', '...', '...', '...', '...', 10

        INSERT INTO #StressTestStepData([NAME], StorageStructureID, Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8, SortOrder)
        SELECT TOP 3 @Name, @StorageStructureID, a.Column1, a.Column2, a.Column3, a.Column4, a.Column5, a.Column6, a.Column7, a.Column8, 
            11 + ROW_NUMBER() OVER (ORDER BY CAST(RIGHT(Column1, LEN(Column1)-3) AS int ),
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