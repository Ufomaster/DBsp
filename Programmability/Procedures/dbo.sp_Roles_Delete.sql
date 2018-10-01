SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   29.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   29.03.2011$
--$Version:    1.00$   $Decription: Удаление роли$
CREATE PROCEDURE [dbo].[sp_Roles_Delete]
	  @ID Int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Err Int;
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        DELETE FROM UserRightsObjectRights
        WHERE RoleID = @ID
        
        DELETE FROM RoleUsers
        WHERE RoleID = @ID

        DELETE FROM Roles
        WHERE ID = @ID
            		
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
    END CATCH
END
GO