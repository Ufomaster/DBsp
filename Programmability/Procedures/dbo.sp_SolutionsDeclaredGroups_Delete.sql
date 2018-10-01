SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   10.08.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   10.08.2011$
--$Version:    1.00$   $Description: Удаление группы регламентных работ
CREATE PROCEDURE [dbo].[sp_SolutionsDeclaredGroups_Delete]
    @ID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int

    IF EXISTS(SELECT * FROM dbo.SolutionsDetail a 
              WHERE a.SolutionsDeclaredID IN (SELECT b.ID 
                                              FROM dbo.SolutionsDeclared b 
                                              WHERE b.SolutionsDeclaredGroupsID = @ID))
        RAISERROR ('Регламентные работы выбранного вида обслуживания используются. Удаление запрещено. ', 16, 1)
    ELSE
    BEGIN
        SET XACT_ABORT ON
        BEGIN TRAN
        BEGIN TRY
            DELETE FROM SolutionsDeclared WHERE SolutionsDeclaredGroupsID = @ID
            DELETE FROM SolutionsDeclaredGroups WHERE ID = @ID

            COMMIT TRAN
        END TRY
        BEGIN CATCH
            SET @Err = @@ERROR
            IF @@TRANCOUNT > 0 ROLLBACK TRAN
            EXEC sp_RaiseError @ID = @Err
        END CATCH
    END
END
GO