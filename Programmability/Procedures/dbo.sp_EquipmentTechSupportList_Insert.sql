SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   08.12.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   08.12.2011$
--$Version:    1.00$   $Decription: Удаление ОС из списка контроля$
CREATE PROCEDURE [dbo].[sp_EquipmentTechSupportList_Insert]
    @EquipmentID Int,
    @TechSupportElementID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int    
    SET XACT_ABORT ON
    
    IF EXISTS(SELECT * FROM dbo.EquipmentTechSupportList ets WHERE ets.EquipmentID = @EquipmentID AND ets.TechSupportElementID = @TechSupportElementID)
        RAISERROR ('Основное средство уже добавлено в список. Добавление запрещено', 16, 1)
    BEGIN TRAN
    BEGIN TRY
        INSERT INTO EquipmentTechSupportList(EquipmentID, TechSupportElementID)
        VALUES(@EquipmentID, @TechSupportElementID)
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO