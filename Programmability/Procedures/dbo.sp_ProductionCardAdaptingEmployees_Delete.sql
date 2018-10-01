SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   03.05.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   03.05.2012$*/
/*$Version:    1.00$   $Decription: Удаление участника согласования и связей его с группами согласователей$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptingEmployees_Delete]
    @AdaptingEmployeeID Int
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    BEGIN TRY
    BEGIN TRAN
        --Сначала удаляем связку пользователь - группы
        DELETE FROM ProductionCardAdaptingGroupEmployees WHERE ProductionCardAdaptingGroupEmployeesID = @AdaptingEmployeeID
        
        --Теперь удаляем саму группу
        DELETE FROM ProductionCardAdaptingEmployees WHERE ID = @AdaptingEmployeeID
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