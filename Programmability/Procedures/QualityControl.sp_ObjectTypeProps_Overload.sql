SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   20.11.2014$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   20.11.2014$*/
/*$Version:    1.00$   $Description: Перегрузка характеристик всех тмц из группы$*/
CREATE PROCEDURE [QualityControl].[sp_ObjectTypeProps_Overload]
    @ObjectTypePropsID int,
    @UpdateDeleted bit
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int

	BEGIN TRAN
	BEGIN TRY
        /*если удален, если галочка @UpdateDeleted = 1 восстанавливаем*/
        IF EXISTS(SELECT ID FROM QualityControl.TMCProps a WHERE a.ObjectTypePropsID = @ObjectTypePropsID AND [Status] = 2)
        BEGIN
            IF @UpdateDeleted = 1 
                DELETE FROM QualityControl.TMCProps
                WHERE ObjectTypePropsID = @ObjectTypePropsID
/*          ELSE ничего не делаем.*/
        END
        ELSE
        /*если не удален */
        IF EXISTS(SELECT ID FROM QualityControl.TMCProps a WHERE a.ObjectTypePropsID = @ObjectTypePropsID AND [Status] = 1)
        BEGIN
            DELETE FROM QualityControl.TMCProps
            WHERE ObjectTypePropsID = @ObjectTypePropsID
        END
         
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
	END CATCH;
END
GO