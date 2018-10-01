SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$        $Create date:   26.12.2012$*/
/*$Modify:     Oleynik Yuriy$        $Modify date:   03.12.2013$*/
/*$Version:    1.00$   $Description: Удаление заказа$*/
CREATE PROCEDURE [dbo].[sp_ProductionOrders_Delete]
    @ID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int

    IF EXISTS(SELECT TOP 1 * FROM ProductionOrdersProdCardCustomize WHERE ProductionOrdersID = @ID)
    BEGIN
        RAISERROR ('Удаление непустых заказов запрещено!', 16, 1)
        RETURN;
    END
/*    ELSE
    IF EXISTS(SELECT * FROM AStorageStructure as sstr WHERE sstr.AStorageSchemeID = @ID)
        RAISERROR ('Удаление узла дерева, с которым связаны реальные объекты, запрещено', 16, 1)*/

    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY     
        DELETE
        FROM ProductionOrders 
        WHERE ID = @ID
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO