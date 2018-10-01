SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   09.12.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   09.12.2011$
--$Version:    1.00$   $Decription: Удаление ОС из списка контроля$
CREATE PROCEDURE [dbo].[sp_EquipmentTechSupportList_DeleteUsers]
    @EquipmentID Int,
    @EmployeeID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int    
    SET XACT_ABORT ON

    BEGIN TRAN
    BEGIN TRY
        DELETE FROM EquipmentEmployee 
        WHERE EquipmentID = @EquipmentID AND EmployeeID = @EmployeeID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO