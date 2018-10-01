SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   29.03.2011$
--$Modify:     Oleksii Poliatykin$    $Modify date:   06.09.2017$
--$Version:    1.00$   $Decription: Добавление записи в таблицу Roles$
CREATE PROCEDURE [dbo].[sp_Roles_Insert]
	  @Name Varchar (50),
      @CopyID Int,
      @isFolder Bit,
      @ParentID Int,
	  @ID Int = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Err Int;
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        DECLARE @t TABLE(ID Bigint)
        INSERT INTO Roles ([Name], isFolder, ParentID)
        OUTPUT INSERTED.ID INTO @t
        VALUES(@Name, @isFolder, @ParentID)

        SELECT @ID = ID FROM @t
	       
        IF @CopyID > 0
            INSERT INTO UserRightsObjectRights(ObjectID, RightValue, RoleID)
            SELECT
                a.ObjectID,
                a.RightValue,
                @ID
            FROM UserRightsObjectRights a
            WHERE a.RoleID = @CopyID
            		
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
        SET @ID = -1
    END CATCH
    
    SELECT @ID AS Result
END
GO