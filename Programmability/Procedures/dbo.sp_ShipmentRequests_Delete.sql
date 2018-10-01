SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   10.12.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   10.12.2015$*/
/*$Version:    1.00$   $Description: удаление заявок на перевозки$*/
CREATE PROCEDURE [dbo].[sp_ShipmentRequests_Delete]
    @ID int
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
	BEGIN TRAN
	BEGIN TRY 
/*        DELETE 
        FROM ShipmentRequestsDetails
        WHERE ShipmentRequestID = @ID*/

        DELETE 
        FROM ShipmentRequests
        WHERE ID = @ID
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
	END CATCH;
END
GO