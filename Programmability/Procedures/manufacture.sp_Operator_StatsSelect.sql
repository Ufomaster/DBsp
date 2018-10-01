SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   23.04.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   05.02.2018$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_Operator_StatsSelect]
    @JobStageID int,
    @StorageStructureID int,
    @ShiftID int
AS
BEGIN   
    SET NOCOUNT ON
    DECLARE @CurDate datetime, @Query varchar(8000), @SomeTmcID int, @SomeColumnName varchar(8000), @SortOrder int
--вощшедший юзер постит дату входа своей бригады.
--нужно найти по рабочему месту этого компа, запущеную смену(ЕНД ДЕЙТ = НУЛЛ)
    SELECT @CurDate = GetDate()

    --Если инсертные значения, то мы не можем посчитать выданные, поэтом выводмм по другому.
    IF EXISTS(SELECT ID FROM manufacture.JobStageChecks WHERE JobStageID = @JobStageID AND TypeID = 2 AND isDeleted = 0 AND [CheckDB] = 1)    
        SELECT TOP 1 @SomeTmcID = jj.TmcID, @SomeColumnName = itc.GroupColumnName
        FROM manufacture.JobStageChecks jj
        INNER JOIN manufacture.PTmcImportTemplateColumns itc ON itc.ID = jj.ImportTemplateColumnID
        WHERE jj.isDeleted = 0 AND jj.JobStageID = @JobStageID AND jj.TypeID = 2 AND jj.[CheckDB] = 1 
        ORDER BY jj.SortOrder
    ELSE
        SELECT TOP 1 @SomeTmcID = jj.TmcID, @SomeColumnName = itc.GroupColumnName
        FROM manufacture.JobStageChecks jj
        INNER JOIN manufacture.PTmcImportTemplateColumns itc ON itc.ID = jj.ImportTemplateColumnID
        WHERE jj.isDeleted = 0 AND jj.JobStageID = @JobStageID AND jj.TypeID = 2
        ORDER BY jj.SortOrder               

    CREATE TABLE #Res(TotalPacked int, TotalLeft int, TotalAssigned int)
    SELECT s.ID, s.FactStartDate, @CurDate AS FactEndDate
    INTO #PeriodShift
    FROM shifts.Shifts s
    WHERE s.ID = @ShiftID
--WITH (NOLOCK)
    SELECT @Query = 
    'INSERT INTO #Res(TotalPacked)
    SELECT COUNT(b.ID) FROM StorageData.pTMC_' + CAST(@SomeTmcID AS Varchar) + ' b  
    INNER JOIN StorageData.G_' + CAST(@JobStageID AS Varchar) + ' g ON g.' +  @SomeColumnName + ' = b.ID 
    INNER JOIN #PeriodShift sfact ON b.PackedDate BETWEEN sfact.FactStartDate AND sfact.FactEndDate
    WHERE b.StatusID = 3 AND b.StorageStructureID = ' + CAST(@StorageStructureID AS Varchar)

    EXEC (@Query)

    IF @SomeTmcID IS NOT NULL
    BEGIN
        SELECT @Query = 
            'UPDATE #Res
            SET TotalLeft = (SELECT COUNT(b.ID) 
            FROM StorageData.pTMC_' + CAST(@SomeTmcID AS Varchar) + ' b
            INNER JOIN StorageData.G_' + CAST(@JobStageID AS Varchar) + ' g ON g.' +  @SomeColumnName + ' = b.ID
            WHERE b.StatusID = 2 AND b.StorageStructureID = ' + CAST(@StorageStructureID AS Varchar) + ')'
        EXEC (@Query)
    END

    SELECT 
        TotalPacked, 
        ISNULL(TotalLeft, 0) AS TotalLeft, 
        ISNULL(TotalLeft, 0) + TotalPacked AS TotalAssigned
    FROM #Res

    DROP TABLE #Res
    DROP TABLE #PeriodShift
END
GO