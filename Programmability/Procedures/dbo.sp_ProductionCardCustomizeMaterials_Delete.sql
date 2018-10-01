SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    $Create date:   15.10.2015$*/
/*$Modify:     Oleynik Yuiriy$    $Modify date:   15.10.2015$*/
/*$Version:    1.00$   $Description:$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeMaterials_Delete]
    @ID Int /* идентификатор заказного листа*/
AS
BEGIN
    DECLARE @Err Int
    SET NOCOUNT ON

    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*очищаем данные для синхронизации с 1с., остается только шапка спецификации, её удалять нет смысла.*/
        EXEC [sync].sp_Spec_Delete @ID

        DELETE FROM ProductionCardCustomizeMaterials
        WHERE ProductionCardCustomizeID = @ID

        COMMIT TRAN
    END TRY
    BEGIN CATCH

        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO