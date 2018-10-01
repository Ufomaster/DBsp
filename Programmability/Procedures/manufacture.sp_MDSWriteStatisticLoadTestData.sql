SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   22.05.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   22.05.2014$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [manufacture].[sp_MDSWriteStatisticLoadTestData]
    @StorageStructureID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        ROW_NUMBER() OVER (ORDER BY CAST(RIGHT(Column1, LEN(Column1)-3) AS int),
                                    CAST(RIGHT(Column2, LEN(Column2)-3) AS int),
                                    CAST(RIGHT(Column3, LEN(Column3)-3) AS int),
                                    CAST(RIGHT(Column4, LEN(Column4)-3) AS int),
                                    CAST(RIGHT(Column5, LEN(Column5)-3) AS int),
                                    CAST(RIGHT(Column6, LEN(Column6)-3) AS int),
                                    CAST(RIGHT(Column7, LEN(Column7)-3) AS int),
                                    CAST(RIGHT(Column8, LEN(Column8)-3) AS int)) AS ID,
        a.Column1,
        a.Column2,
        a.Column3,
        a.Column4,
        a.Column5,
        a.Column6,
        a.Column7,
        a.Column8
    INTO #test
    FROM manufacture.StressTestStepData a
    WHERE a.StorageStructureID = @StorageStructureID
    ORDER BY 
    CAST(RIGHT(Column1, LEN(Column1)-3) AS int),
    CAST(RIGHT(Column2, LEN(Column2)-3) AS int),
    CAST(RIGHT(Column3, LEN(Column3)-3) AS int),
    CAST(RIGHT(Column4, LEN(Column4)-3) AS int),
    CAST(RIGHT(Column5, LEN(Column5)-3) AS int),
    CAST(RIGHT(Column6, LEN(Column6)-3) AS int),
    CAST(RIGHT(Column7, LEN(Column7)-3) AS int),
    CAST(RIGHT(Column8, LEN(Column8)-3) AS int)
    
    
    SELECT 
        CASE WHEN ISNULL(b.Column1, '') = a.Column1 THEN '' ELSE a.Column1 END AS Column1,
        CASE WHEN ISNULL(b.Column2, '') = a.Column2 THEN '' ELSE a.Column2 END AS Column2,
        CASE WHEN ISNULL(b.Column3, '') = a.Column3 THEN '' ELSE a.Column3 END AS Column3,
        CASE WHEN ISNULL(b.Column4, '') = a.Column4 THEN '' ELSE a.Column4 END AS Column4,
        CASE WHEN ISNULL(b.Column5, '') = a.Column5 THEN '' ELSE a.Column5 END AS Column5,
        CASE WHEN ISNULL(b.Column6, '') = a.Column6 THEN '' ELSE a.Column6 END AS Column6,
        CASE WHEN ISNULL(b.Column7, '') = a.Column7 THEN '' ELSE a.Column7 END AS Column7,
        CASE WHEN ISNULL(b.Column8, '') = a.Column8 THEN '' ELSE a.Column8 END AS Column8
    FROM #test a
    LEFT JOIN #test b ON a.ID = b.ID + 1
    ORDER BY a.ID

    DROP TABLE #test
END
GO