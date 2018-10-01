SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   07.05.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   07.05.2012$*/
/*$Version:    1.00$   $Decription: Удаление пользователя из группы$*/
CREATE PROCEDURE [dbo].[sp_RoleUser_Delete]
    @AUserID Int,
    @ARoleID Int
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS(SELECT * FROM RoleUsers 
              WHERE RoleID = @ARoleID 
                    AND UserID = @AUserID)
        DELETE FROM RoleUsers
        WHERE RoleID = @ARoleID 
             AND UserID = @AUserID
END
GO