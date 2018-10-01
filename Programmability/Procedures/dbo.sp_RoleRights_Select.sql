SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   30.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   30.03.2011$
--$Version:    1.00$   $Description: Выборка прав для пользователя$
CREATE PROCEDURE [dbo].[sp_RoleRights_Select]
    @UserID Int
AS
BEGIN
    SET NOCOUNT ON
    SELECT MAX(uror.RightValue) AS RightValue, uror.ObjectID
    FROM UserRightsObjectRights uror
    INNER JOIN RoleUsers ru ON ru.UserID = @UserID AND ru.RoleID = uror.RoleID
    GROUP BY uror.ObjectID
END
GO