SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   19.01.2012$
--$Modify:     Yuriy Oleynik$    		$Modify date:   25.06.2015$ 
--$Version:    1.00$   $Description:Удаление записи в таблице ComparisonRates и ConsumptionRatesDetails
CREATE PROCEDURE [dbo].[sp_ConsumptionRates_Delete]
    @ID Int --идентификатор ConsumptionRates  
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int
        
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        
        DELETE FROM ConsumptionRatesDetails WHERE ConsumptionRateID = @ID
        
        DELETE FROM ConsumptionRates WHERE ID = @ID        

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO