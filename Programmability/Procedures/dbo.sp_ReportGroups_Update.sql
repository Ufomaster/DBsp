SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   13.05.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   13.05.2011$
--$Version:    1.00$   $Description: Изменение группы$
CREATE PROCEDURE [dbo].[sp_ReportGroups_Update]
    @ID Bigint,
    @ParentID Int = NULL,
    @Name Varchar (250) = NULL,
    @OutID Bigint = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @Err Int;
    BEGIN TRAN
    BEGIN TRY
        UPDATE ReportGroups SET
            ParentID = CASE
                           WHEN @ParentID IS NULL THEN ParentID
                           WHEN @ParentID = -2 THEN NULL
                       ELSE @ParentID
                       END,
            [Name] = ISNULL(@Name, [Name])
        WHERE ID = @ID;

        SET @OutID = @ID;
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        EXEC sp_RaiseError @ID = @Err;
        SET @OutID = -1;
    END CATCH
END
GO