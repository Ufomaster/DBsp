SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   07.04.2015$*/
/*$Version:    1.00$   $Description: Удаление акта нс$*/
CREATE PROCEDURE [QualityControl].[sp_Acts_Delete]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF EXISTS(SELECT ID FROM QualityControl.Acts 
                  WHERE ID = @ID AND StatusID = 1) 
        BEGIN
            DELETE FROM QualityControl.ActsDetails
            WHERE ActsID = @ID
            DELETE FROM QualityControl.ActsReasons
            WHERE ActID = @ID
            DELETE FROM QualityControl.ActsTasks
            WHERE ActID = @ID                
            
            DELETE FROM QualityControl.Acts
            WHERE ID = @ID
        END
        ELSE
            RAISERROR ('Удаление акта в статусе отличном от "Черновик" запрещено', 16, 1)           
            
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO