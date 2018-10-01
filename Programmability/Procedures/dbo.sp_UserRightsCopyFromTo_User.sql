SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   10.07.2017$
--$Modify:     Poliatykin Oleksii$    $Modify date:   14.08.2017$
--$Version:    1.00$   $Decription: Копирование ролей от пользователя к пользователю Roles$
CREATE PROCEDURE [dbo].[sp_UserRightsCopyFromTo_User] @CopyFromId INT,
@CopyToId INT,
@CopyOrReplase INT
AS
BEGIN
    IF @CopyOrReplase = 0
    BEGIN
        INSERT INTO RoleUsers (RoleID, UserID)
            SELECT
                RoleId
               ,@CopyToId
            FROM RoleUsers
            WHERE UserID = @CopyFromId
            AND NOT RoleId IN (SELECT
                    RoleID
                FROM RoleUsers
                WHERE UserID = @CopyToId)
    END

    IF @CopyOrReplase = 1
    BEGIN
        DELETE RoleUsers
        WHERE UserID = @CopyToId
        INSERT INTO RoleUsers (RoleID, UserID)
            SELECT
                RoleId
               ,@CopyToId
            FROM RoleUsers
            WHERE UserID = @CopyFromId
    END

END
GO