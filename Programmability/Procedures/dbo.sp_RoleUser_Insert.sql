SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   07.05.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   07.05.2012$*/
/*$Version:    1.00$   $Decription: Добавление пользователя в группу$*/
CREATE PROCEDURE [dbo].[sp_RoleUser_Insert]
    @AUserID Int,
    @ARoleID Int
AS
BEGIN
    SET NOCOUNT ON
    IF NOT EXISTS(SELECT * FROM RoleUsers 
                  WHERE RoleID = @ARoleID 
                        AND UserID = @AUserID)
        INSERT INTO RoleUsers ([RoleID], [UserID])
        SELECT @ARoleID, @AUserID
END
GO