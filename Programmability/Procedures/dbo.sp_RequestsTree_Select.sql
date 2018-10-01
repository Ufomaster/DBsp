SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   18.02.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   22.12.2011$
--$Version:    1.00$   $Description: Дерево фильтров слева заявок$
CREATE PROCEDURE [dbo].[sp_RequestsTree_Select]
    @Type Int = 0 --фильтр условий отбора папок. пока не работает
AS
BEGIN
    --EnabledOperations 0-можно всё, 1 - нельзя ничего --далее неиспользуется(, 2-можно добавлять, 3-удалять)
	SET NOCOUNT ON
    DECLARE @Result TABLE(ID Int, ParentID Int, NAME Varchar(50), FilterType Int, IcoIndex Int, EnabledOperations Int)
    
    DECLARE @StartDate Datetime, @Now Datetime
    
    SET @Now = GetDate()
    SELECT @StartDate = dbo.fn_DateCropTime(@Now)
    
    INSERT INTO @Result(ID, ParentID, NAME, FilterType, IcoIndex, EnabledOperations)    
    SELECT 
        0, 
        NULL,
        'Все',-- + (SELECT '(' + CAST(COUNT(*) AS Varchar) + ')' FROM Requests WHERE [Date] BETWEEN @StartDate AND @Now),
        -1,
        24,
        0
    UNION ALL
    SELECT
        1, 
        NULL,
        'Важность',
        -1,
        24,
        0
    UNION ALL
    SELECT
        2,
        NULL,
        'Статус',
        -1,
        24,
        0
    UNION ALL
    SELECT 
        2 + ROW_NUMBER() OVER (ORDER BY a.ID),
        1,
        a.[Name],-- + (SELECT '(' + CAST(COUNT(*) AS Varchar) + ')' FROM Requests WHERE Severity = a.ID AND [Date] BETWEEN @StartDate AND @Now),
        100 + a.ID,
        a.ImageIndex,
        0
    FROM vw_RequestSeverities a
    UNION ALL
    SELECT 
        2 + (SELECT COUNT(*) FROM vw_RequestSeverities) + ROW_NUMBER() OVER (ORDER BY b.ID),
        2,
        b.[Name],-- + (SELECT '(' + CAST(COUNT(*) AS Varchar) + ')' FROM Requests WHERE [Status] = b.ID AND [Date] BETWEEN @StartDate AND @Now),
        b.ID,
        b.ImageIndex,
        0
    FROM vw_RequestStatuses b

    IF @Type = 0
        INSERT INTO @Result(ID, ParentID, NAME, FilterType, IcoIndex, EnabledOperations)
        SELECT 
            MAX(ID) + 1,
            NULL,
            'Удалённые',
            110,
            24,
            1
        FROM @Result
    --IF @Type = 1 -- только по доступным подразделениям.
    --IF @Type = 2 -- только свои заявки по EmployeeID

    SELECT * FROM @Result
    ORDER BY ID, ParentID
END
GO