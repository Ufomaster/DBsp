SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   03.05.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   03.05.2012$*/
/*$Version:    1.00$   $Decription: Удаление группы пользователей и связей всех пользователей с этой группой$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptingGroups_Delete]
    @AdaptingGroupID Int
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    BEGIN TRY
    BEGIN TRAN
        --Сначала удаляем связку пользователи - группа
        DELETE FROM ProductionCardAdaptingGroupEmployees WHERE AdaptingGroupID = @AdaptingGroupID
        
        --Теперь удаляем саму группу
        DELETE FROM ProductionCardAdaptingGroups WHERE ID = @AdaptingGroupID
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