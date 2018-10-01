SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   30.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   30.03.2011$
--$Version:    1.00$   $Description: Сохранение прав для роли$
CREATE PROCEDURE [dbo].[sp_RoleRights_Save]
    @RoleID Int,
    @ObjectID Int,
    @RightValue Int
AS
BEGIN
    SET NOCOUNT ON
    IF (@RightValue < 1) OR (@RightValue > 3) OR (@RightValue) IS NULL 
    BEGIN
        DELETE FROM UserRightsObjectRights WHERE RoleID = @RoleID AND ObjectID = @ObjectID
        RETURN
    END

    IF EXISTS(SELECT * FROM UserRightsObjectRights WHERE RoleID = @RoleID AND ObjectID = @ObjectID)
        UPDATE UserRightsObjectRights
        SET RightValue = @RightValue
        WHERE RoleID = @RoleID AND ObjectID = @ObjectID
    ELSE
        INSERT INTO UserRightsObjectRights(RoleID, ObjectID, RightValue)
        SELECT @RoleID, @ObjectID, @RightValue
END
GO