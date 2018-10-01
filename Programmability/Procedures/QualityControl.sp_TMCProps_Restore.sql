SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   20.11.2014$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   20.11.2014$*/
/*$Version:    1.00$   $Description: Удаление характеристики ТМЦ*/
CREATE PROCEDURE [QualityControl].[sp_TMCProps_Restore]
    @PropID int,
    @TMCID int
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
    DECLARE @t TABLE(ID Int)    

	BEGIN TRAN
	BEGIN TRY    
        DELETE FROM QualityControl.TMCProps
        WHERE ObjectTypePropsID = @PropID AND TMCID = @TMCID 

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
	END CATCH;
    SELECT ID FROM @t
END
GO