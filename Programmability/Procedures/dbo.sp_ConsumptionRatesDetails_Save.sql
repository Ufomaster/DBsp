SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    		$Create date:   20.01.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Create date:   30.09.2016$*/
/*$Version:    1.00$   $Description: Апдейт дитейловых записей в таблице ComparisonRates$*/
CREATE PROCEDURE [dbo].[sp_ConsumptionRatesDetails_Save]
    @ID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int
        
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        DELETE a 
        FROM ConsumptionRatesDetails a
             LEFT JOIN (SELECT ObjectTypeID, Negation FROM #ConsumptionRateDetails GROUP BY ObjectTypeID, Negation) AS  b ON a.ObjectTypeID = b.ObjectTypeID AND a.Negation = b.Negation
        WHERE a.ConsumptionRateID = @ID AND b.ObjectTypeID IS NULL

        INSERT INTO ConsumptionRatesDetails(ConsumptionRateID, ObjectTypeID, Negation)
        SELECT @ID, a.ObjectTypeID, a.Negation
        FROM #ConsumptionRateDetails a
	         LEFT JOIN ConsumptionRatesDetails b ON a.ObjectTypeID = b.ObjectTypeID AND b.ConsumptionRateID = @ID AND a.Negation = b.Negation
        WHERE b.ID IS NULL
        GROUP BY a.ObjectTypeID, a.Negation

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO