SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   08.12.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   08.12.2011$
--$Version:    1.00$   $Decription: Удаление ОС из списка контроля$
CREATE PROCEDURE [dbo].[sp_EquipmentTechSupportList_Delete]
    @ID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int    
    SET XACT_ABORT ON
    
    IF EXISTS(SELECT * FROM dbo.EquipmentControl ec WHERE ec.EquipmentID = @ID)
        RAISERROR ('Удаление основного средства запрещено, так как на него существуют точки контроля', 16, 1)
/*    ELSE
    IF EXISTS(SELECT * FROM dbo.EquipmentEmployee ee WHERE ee.EquipmentID = @ID)
        RAISERROR ('Удаление основного средства запрещено, так как по нему существуют работы', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM dbo.SolutionsPlanned sp WHERE sp.EquipmentID = @EquipmentID)
        RAISERROR ('Удаление основного средства запрещено, так как по нему существуют плановые работы', 16, 1)
    */
    BEGIN TRAN
    BEGIN TRY
        DELETE FROM EquipmentEmployee WHERE EquipmentID = @ID
        DELETE FROM EquipmentTechSupportList WHERE EquipmentID = @ID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO