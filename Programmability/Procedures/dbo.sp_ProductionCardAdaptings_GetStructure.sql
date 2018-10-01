SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   23.01.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   23.01.2013$*/
/*$Version:    1.00$   $Decription: Получение текста запроса на выборку данных для таблицы согласования ЗЛ$*/
create PROCEDURE [dbo].[sp_ProductionCardAdaptings_GetStructure]
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @t TABLE(ID Int, Num Tinyint, Del Bit)
    DECLARE @Query Varchar(8000), @flds Varchar(8000), @Num Int, @MaxNum Int, @StatusID Int, @Maxflds Varchar(8000)

    INSERT INTO @t(ID, Num, Del)
    SELECT 
        ID,
        ROW_NUMBER() OVER (ORDER BY ID),
        0
    FROM ProductionCardStatuses WHERE IsAdaptingFunction = 1
    
    SELECT @MaxNum = MAX(Num) FROM @t


    SELECT @flds = '', @Maxflds = '', @Query = '
SELECT
    a.EmployeeID, 
    e.FullName AS EmployeeName, 
    a.[Date],
    a.SignDate, '
    WHILE EXISTS(SELECT * FROM @t WHERE Del = 0)
    BEGIN
        SELECT @StatusID = ID, @Num = Num FROM @T WHERE Del = 0 ORDER BY Num
        
        SELECT @flds =
        '    CASE WHEN a.StatusID = ' + CAST(@StatusID AS Varchar) + ' THEN a.[Date] ELSE NULL END AS [Date' + CAST(@Num AS Varchar) + '], ' + Char(13) + Char(10) +
        '    CASE WHEN a.StatusID = ' + CAST(@StatusID AS Varchar) + ' THEN a.SignDate ELSE NULL END AS [SignDate' + CAST(@Num AS Varchar) + '], ' + Char(13) + Char(10) + 
        @flds
        
        SELECT @Maxflds = ', MAX([Date' + CAST(@Num AS Varchar) + ']) AS Date' + CAST(@Num AS Varchar) + 
                          ', MAX([SignDate' + CAST(@Num AS Varchar) + ']) AS SignDate' + CAST(@Num AS Varchar) + 
                          @Maxflds

        UPDATE @t SET Del = 1 WHERE Num = @Num
    END
    SET @Query = @Query + Char(13) + Char(10) + @flds + '  0 AS [Status]' + Char(13) + Char(10) + 
    'INTO #tmp ' + Char(13) + Char(10) + 
    'FROM ProductionCardCustomizeAdaptings a' + Char(13) + Char(10) +
    'INNER JOIN vw_Employees e ON e.ID = a.EmployeeID ' + Char(13) + Char(10) +
    'WHERE ProductionCardCustomizeID = :ID ' + Char(13) + Char(10) +
    '
SELECT 
    ROW_NUMBER() OVER (ORDER BY EmployeeName) AS ID,
    EmployeeID,
    EmployeeName ' + @Maxflds + '
    ,CASE WHEN COUNT([SignDate]) = COUNT([Date]) THEN 1 ELSE 0 END AS [Status]
FROM #tmp
GROUP BY EmployeeID, EmployeeName

DROP TABLE #tmp'

    SELECT @Query AS [SelectSQL], s.ID, s.[Name], Num AS SortOrder, 'Date' + CAST(Num AS Varchar) AS InFieldName, 'SignDate' + CAST(Num AS Varchar) AS SignFieldName
    FROM @t AS a 
    INNER JOIN ProductionCardStatuses s ON s.ID = a.ID
    ORDER BY Num
END
GO