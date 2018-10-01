SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Skliar Nataliia$    $Create date:   11.05.2017$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.05.2017$*/
/*$Version:    1.00$   $Description: Выборка прав закрепленных за ролью$*/
CREATE PROCEDURE [dbo].[sp_UserRightsRolePermissions_Select]
    @RoleID Int
AS
BEGIN
    SET NOCOUNT ON;
      
    SELECT uro.ID
          ,uro.ParentID
          ,uror.RoleID
    INTO #Tmp
    FROM dbo.UserRightsObjects uro
    LEFT JOIN dbo.UserRightsObjectRights uror ON uror.ObjectID = uro.ID 
    WHERE uror.RightValue IN (3)
      AND uror.RoleID = @RoleID

    ;WITH #Res (ID, ParentID)
    AS
      (
          SELECT ID, ParentID
          FROM #Tmp
            
          UNION ALL
            
          SELECT uro.ID, uro.ParentID
          FROM dbo.UserRightsObjects uro
          INNER JOIN #Res as t2 on uro.ID= t2.ParentID
          WHERE uro.IcoIndex = 24
       )
    SELECT #Res.ID, #Res.ParentID, uroP.[Name] AS ParentName, uro.[Name], uro.DelphiConst
    FROM #Res
    LEFT JOIN dbo.UserRightsObjects uro on uro.id = #Res.ID
    LEFT JOIN dbo.UserRightsObjects uroP on uroP.id = #Res.ParentID
    GROUP BY #Res.ID, #Res.ParentID, uroP.[Name], uro.[Name], uro.DelphiConst
    ORDER BY #Res.ParentID
    DROP TABLE #Tmp
END
GO