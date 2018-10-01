SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   04.06.2015$*/
/*$Modify:     Polyatykin Oleksii$    $Modify date:   09.02.2018$*/
/*$Version:    1.00$   $Decription: Выборка данных из реальной таблицы для редактирования.$*/
CREATE PROCEDURE [shifts].[sp_EmployeeGroupFact_Parse]
    @ShiftID    INT,
    @StartDate  DATETIME,
    @FinishDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Columns INT, @IncDate DATETIME, @I INT

    DECLARE @Query VARCHAR(MAX)
    DECLARE @FieldsSet VARCHAR(MAX)
    DECLARE @FieldsSelect VARCHAR(MAX)

    SET @Columns = DATEDIFF(MI, @StartDate, @FinishDate) / 30

    CREATE TABLE #tmp (
        WorkPlaceID   INT,
        WorkPlaceName VARCHAR(255),
        EmployeeID    INT,
        EmployeeName  VARCHAR(255)
    )

    SET @I = 0
    SET @Query = NULL
    SET @IncDate = @StartDate

    WHILE @i < @Columns
    BEGIN
        SET @Query =        ISNULL(@Query + ',', '') + 'Data' + CAST(@I AS VARCHAR) + ' int DEFAULT 0'
        SET @FieldsSet =    ISNULL(@FieldsSet + ',', '') + 'Data' + CAST(@I AS VARCHAR) + ' = TL.Data' + CAST(@I AS VARCHAR) + ' '
        SET @FieldsSelect = ISNULL(@FieldsSelect + ',', ',') +  '  max(CASE when  ''' + CAST(@IncDate AS VARCHAR) +
                            ''' BETWEEN DATEADD(mi, -15, a.StartDate) AND DATEADD(mi, -15, ISNULL(a.EndDate, GetDate()))  THEN 1 ELSE 0 END) as Data'
                            + CAST(@I AS VARCHAR) + ' '
        SET @I = @I + 1
        SET @IncDate = DATEADD(MI, 30, @IncDate)
    END

    SET @Query = 'ALTER TABLE #tmp ADD ' + @Query + '   '
    IF @Query IS NOT NULL
        EXEC (@Query)

    INSERT INTO #tmp (WorkPlaceID, WorkPlaceName, EmployeeID, EmployeeName)
    SELECT
         f.WorkPlaceID
         , s.[Name]
         , d.EmployeeID
         , e.FullName /*f.StartDate, f.EndDate, f.IP*/
    FROM shifts.EmployeeGroupsFactDetais d
    INNER JOIN shifts.EmployeeGroupsFact f ON f.ID = d.EmployeeGroupsFactID AND ISNULL(f.IsDeleted, 0) = 0
    INNER JOIN manufacture.StorageStructure s ON s.ID = f.WorkPlaceID
    INNER JOIN vw_Employees e ON e.ID = d.EmployeeID
    WHERE f.ShiftID = @ShiftID AND ISNULL(d.IsDeleted, 0) = 0 AND ISNULL(f.AutoCreate, 0) = 0
    GROUP BY f.WorkPlaceID, s.[Name], d.EmployeeID, e.FullName

    SET @Query =
    'UPDATE t
    SET
    '+@FieldsSet+'
    FROM #tmp t
    INNER JOIN
    (
    SELECT a.WorkPlaceID , d.EmployeeID ' + @FieldsSelect + '
    FROM shifts.EmployeeGroupsFact a
    INNER JOIN shifts.EmployeeGroupsFactDetais d ON d.EmployeeGroupsFactID = a.ID
    WHERE a.ShiftID = '+ CAST(@ShiftID AS VARCHAR) + ' AND ISNULL(a.IsDeleted, 0) = 0 AND ISNULL(a.AutoCreate, 0) = 0
    GROUP BY a.WorkPlaceID, d.EmployeeID
    ) TL on t.WorkPlaceID = TL.WorkPlaceID AND t.EmployeeID = TL.EmployeeID
    '

    IF @Query IS NOT NULL
        EXEC (@Query)

    SELECT
        ROW_NUMBER() OVER (ORDER BY WorkPlaceID, EmployeeID ) AS ID
        , *
    FROM #tmp

    DROP TABLE #tmp
END
GO