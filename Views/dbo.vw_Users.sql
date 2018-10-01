SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   17.02.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   14.08.2015$
--$Version:    1.00$   $Decription: vw_Users$
CREATE VIEW [dbo].[vw_Users]
AS
    SELECT
        u.ID,
        u.EmployeeID,
        u.IsBlocked,
        CASE u.IsBlocked
            WHEN 0 THEN 'Активен'
            WHEN 1 THEN 'Заблокирован'
        END AS IsBlockedVisible,
        u.Outdated,
        CASE u.Outdated
            WHEN 0 THEN 'Действителен'
            WHEN 1 THEN 'Не действителен'
        END AS OutdatedVisible,
        u.[Password],
        u.[Password] AS OldPassword,
        u.[Login],
        e.FullName,
        u.IsAdmin,
        e.DepartmentID,
        trgts.RequestTargetID,
        sc.CustomerID AS SysCustomerID,
        dbo.fn_GetSystemSetStringValue(5) + RIGHT('00000' + CAST(u.ID AS VARCHAR), 5) AS PersonalCode
    FROM Users u
    LEFT JOIN vw_Employees e ON e.ID = u.EmployeeID
    LEFT JOIN (SELECT a.EmployeeID, MIN(a.RequestTargetID) AS RequestTargetID 
               FROM RequestTargetEmployees a GROUP BY a.EmployeeID) trgts ON trgts.EmployeeID = u.EmployeeID
    LEFT JOIN SystemCustomers sc ON sc.IsDefault = 1
GO