SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   01.10.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   07.07.2015$*/
/*$Version:    1.00$   $Description: Список заявок*/
CREATE PROCEDURE [dbo].[sp_Requests_Select]
    @StartDate datetime = NULL,
    @EndDate datetime = NULL    
AS
BEGIN
    DECLARE @EmployeeID int
    SET NOCOUNT ON    
    
    DECLARE @IT bit, @TOR bit, @XO bit, @OwnOnly bit
    SELECT /*1 can view. 0 no view*/
        @OwnOnly =  CASE WHEN ISNULL(MAX(uro1.RightValue), 1) = 3 THEN 1 ELSE 0 END,
        @IT =  CASE WHEN ISNULL(MAX(uro2.RightValue), 1) = 3 THEN 1 ELSE 0 END, 
        @TOR = CASE WHEN ISNULL(MAX(uro3.RightValue), 1) = 3 THEN 1 ELSE 0 END,
        @XO =  CASE WHEN ISNULL(MAX(uro4.RightValue), 1) = 3 THEN 1 ELSE 0 END
    FROM RoleUsers ru
    LEFT JOIN UserRightsObjectRights uro1 ON uro1.RoleID = ru.RoleID AND uro1.ObjectID = 110 /*urOrdersViewByEmployee - urRequestsViewByEmployee*/
    LEFT JOIN UserRightsObjectRights uro2 ON uro2.RoleID = ru.RoleID AND uro2.ObjectID = 111 /*urOrdersViewByDepartment - urRequestsViewIT*/
    LEFT JOIN UserRightsObjectRights uro3 ON uro3.RoleID = ru.RoleID AND uro3.ObjectID = 113 /*urOrdersViewAll - urRequestsViewTOP*/
    LEFT JOIN UserRightsObjectRights uro4 ON uro4.RoleID = ru.RoleID AND uro4.ObjectID = 131 /*urOrdersViewByOwnDepartment - urRequestsViewXO*/
    WHERE ru.UserID = (SELECT ID FROM #CurrentUser)
    
    SELECT @EmployeeID = u.EmployeeID
    FROM Users u 
    WHERE u.ID = (SELECT ID FROM #CurrentUser)

    SELECT * 
    FROM vw_Requests a
    WHERE 
        a.Deleted = 0 
        AND        
        /*view conditions by rights*/
        ( 
          (@OwnOnly = 1 AND a.EmployeeID = @EmployeeID)
          OR
          (@IT      = 1 AND a.TargetID IN (1,4))
          OR
          (@TOR     = 1 AND a.TargetID = 2)
          OR
          (@XO      = 1 AND a.TargetID = 3)
        )
        AND 
        (a.[Date] BETWEEN ISNULL(@StartDate, a.[Date]) AND ISNULL(@EndDate, a.[Date]))
    ORDER BY a.[Date]
END
GO