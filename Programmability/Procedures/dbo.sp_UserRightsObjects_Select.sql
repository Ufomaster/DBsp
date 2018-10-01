SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   21.08.2012$*/
/*$Modify:     Oleksii Poliatykin$    $Modify date:   10.07.2017$*/
/*$Version:    1.00$   $Decription: Выборка прав пользователя*/
CREATE PROCEDURE [dbo].[sp_UserRightsObjects_Select]
    @RoleID Int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CASE 
            WHEN uror.RightValue IS NULL THEN uro.IcoIndex
            WHEN uror.RightValue = 3 THEN 43
            WHEN uror.RightValue = 2 THEN 44
            WHEN uror.RightValue = 1 THEN 45
        END
        AS IcoIndex,
        uro.ID,
        /*CAST(uro.ID AS Varchar) + '.' + uro.[Name] AS Name,*/
        uro.[Name],
        uro.ParentID,
        uror.RightValue,
        rv.[Name] AS ValueName,
        uro.Comment,
        uro.DelphiConst
    FROM UserRightsObjects uro
    LEFT JOIN UserRightsObjectRights uror ON uror.ObjectID = uro.ID AND uror.RoleID = @RoleID
    LEFT JOIN UserRightsValues rv ON rv.ID = uror.RightValue
    WHERE uro.ID IN (SELECT ID FROM dbo.fn_UserRightsObjectsNode_Select(1))
    ORDER BY uro.IcoIndex, uro.ParentID, uro.[Name]
END
GO