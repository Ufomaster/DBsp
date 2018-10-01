SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   11.12.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   08.06.2017$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_Stat_Flt_ShiftSelect]
    @JobStageID int
AS
BEGIN   
    SET NOCOUNT ON;
    DECLARE @TMCID int, @Query varchar(8000)

    SELECT TOP 1 @TMCID = j.TmcID
    FROM manufacture.JobStageChecks j
    WHERE j.JobStageID = @JobStageID AND ISNULL(j.isDeleted, 0) = 0 AND j.TypeID = 2 AND j.UseMaskAsStaticValue = 0

    CREATE TABLE #tmp(ID int, SSID int)

    SELECT @Query = 
    '
    INSERT INTO #tmp(ID, SSID)
    SELECT a.EmployeeGroupsFactID, ef.WorkPlaceID
    FROM StorageData.pTMC_' + CAST(@TMCID AS VarChar) + ' a
    INNER JOIN shifts.EmployeeGroupsFact ef ON a.EmployeeGroupsFactID = ef.ID
    GROUP BY a.EmployeeGroupsFactID, ef.WorkPlaceID'

    EXEC (@Query)

    SELECT s.ID, CAST(s.ID AS varchar) + ' ' + dbo.fn_DateToString(s.FactStartDate, 'ddmmyyyy') + ' ' + st.[Name] + ' ' + ms.[Name] as Name
    FROM #tmp a
        INNER JOIN shifts.EmployeeGroupsFact f ON f.ID = a.ID
        INNER JOIN shifts.Shifts s ON s.ID = f.ShiftID
        --INNER JOIN shifts.WorkPlaces wp ON wp.ShiftID = s.ID AND wp.StorageStructureID = a.SSID
        INNER JOIN shifts.ShiftsTypes st ON st.ID = s.ShiftTypeID
        INNER JOIN manufacture.ManufactureStructure ms ON ms.ID = st.ManufactureStructureID
    GROUP BY s.ID, s.FactStartDate, s.FactEndDate, s.ShiftTypeID, st.[Name], ms.[Name]
    ORDER BY s.ID DESC    

    DROP TABLE #tmp
END
GO