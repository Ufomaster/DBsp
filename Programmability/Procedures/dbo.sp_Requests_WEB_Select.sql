SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   20.05.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   26.05.2011$
--$Version:    1.00$   $Description: Список заявок для веба$
CREATE PROCEDURE [dbo].[sp_Requests_WEB_Select]
    @UserID Int = NULL,
    @Filter Int = NULL --NULL - ALL, 0 New Only, 1 Fixed, 2-NotFixed, 3-canceled, 
AS
BEGIN
--Статус заявки 0-новая, 1-прочтена, 2-выполняется, 3-отменена, 4-закрыта, 5-заново открыта,6 - Отложена
    SELECT
        ID AS '№',
        dbo.fn_DateToString([Date], 'ddmmyy') AS [Дата],
        a.[Status] AS [Ст],
        a.Severity AS [Вж],
        CASE WHEN a.HasAttachment = 1 THEN 'True' ELSE 'False' END AS [Вл],
        CASE WHEN a.HasComplains = 1 THEN 'True' ELSE 'False' END AS [Жб],
        a.Description AS [Описание],
        a.DepartmentName AS [Подразделение],
        a.EmployeeFullName AS [Заявитель],
        ISNULL(a.EmployeeSolFullName, '-') AS [Исполнитель],
        CASE WHEN a.PlanDate IS NULL THEN '-' ELSE dbo.fn_DateToString(a.PlanDate, 'ddmmyy') END AS [Плановая дата],
        CASE WHEN a.StartDate IS NULL THEN '-' ELSE dbo.fn_DateToString(a.StartDate, 'ddmmyy') END  AS [Начата],
        CASE WHEN a.EndDate IS NULL THEN '-' ELSE dbo.fn_DateToString(a.EndDate, 'ddmmyy') END  AS [Окончена],
        CASE WHEN a.SpendTime IS NULL THEN '-' ELSE
          CAST(DATEPART(HH, a.SpendTime) AS Varchar) + 'ч ' + CAST(DATEPART(mi, a.SpendTime) AS Varchar) + 'м '
        END AS [Затраченное время],
        ISNULL(a.InventoryNum + ' ' + a.EquipmentName, '-')  AS [Оборудование],
        CASE WHEN a.Solution IS NULL THEN '-' ELSE a.Solution END AS [Решение проблемы]
    FROM dbo.vw_Requests a
    WHERE (a.Deleted = 0 AND 
           (@UserID IS NULL OR (@UserID IS NOT NULL AND a.EmployeeID = (SELECT u.EmployeeID FROM dbo.Users u WHERE u.ID = @UserID)))
          )
          AND
          (
          --filter conditions
          (@Filter IS NULL) OR
          (@Filter = 0 AND (a.[Status] = 0 OR a.[Status] = 1 OR a.[Status] = 5)) OR 
          (@Filter = 1 AND (a.[Status] = 4 OR a.[Status] = 6)) OR
          (@Filter = 2 AND (a.[Status] = 0 OR a.[Status] = 1 OR a.[Status] = 2 OR a.[Status] = 5)) OR
          (@Filter = 3 AND a.[Status] = 3)
          --end filter conditions
          )
          
    ORDER BY a.[Date]
END
GO