SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   13.05.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   13.05.2011$
--$Version:    1.00$   $Description: Добавление группы$
CREATE PROCEDURE [dbo].[sp_ReportGroups_Insert]
    @ParentID Int,
    @Name Varchar(250),
    @OutID Bigint = NULL OUTPUT	
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    BEGIN TRY
    BEGIN TRAN
        DECLARE @t TABLE(ID Bigint);
        INSERT INTO ReportGroups(ID, ParentID, NAME)
        OUTPUT INSERTED.ID INTO @t
        SELECT ISNULL(MAX(ID), 0) + 1, @ParentID, @Name 
        FROM ReportGroups
        SELECT @OutID = ID FROM @t;
        IF (@@TRANCOUNT > 0) COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF (@@TRANCOUNT > 0) ROLLBACK TRAN
        DECLARE @Err Int
        SELECT @Err = ERROR_NUMBER()
        EXEC sp_RaiseError @ID = @Err
        RETURN -1
    END CATCH
END
GO