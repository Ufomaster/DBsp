SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   19.01.2012$
--$Modify:     Oleynik Yuriy$    $Modify date:   30.09.2016$
--$Version:    1.00$   $Description: Копирование записи в таблице ComparisonRates к конкретному ObjectTypesID, Если он не указан, то к ObjectTypesID текущей записи$
CREATE PROCEDURE [dbo].[sp_ConsumptionRates_Copy]
    @OldRateID Int, --старый ИД
    @ObjectTypesMaterialID Int = -1, --праймари кей материал Materials
    @TechOperationID int = -1
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @NewConsumptionID Int
    DECLARE @T TABLE(ID Int)

    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF @ObjectTypesMaterialID = -1
            SELECT @ObjectTypesMaterialID = ObjectTypesmaterialID
            FROM Consumptionrates
            WHERE ID = @OldRateID

        IF @TechOperationID = -1
            SELECT @TechOperationID = TechOperationID
            FROM ConsumptionRates
            WHERE ID = @OldRateID

        INSERT INTO ConsumptionRates (ObjectTypesmaterialID, Script, [Name], TechOperationID)
        OUTPUT INSERTED.ID INTO @T
        SELECT @ObjectTypesmaterialID, Script,  '(Копия) ' + [Name], @TechOperationID
        FROM ConsumptionRates
        WHERE ID = @OldRateID

        SELECT @NewConsumptionID = ID FROM @T

        INSERT INTO ConsumptionRatesDetails (ConsumptionrateID, ObjectTypeID, Negation)
        SELECT @NewConsumptionID, crd.ObjectTypeID, crd.Negation
        FROM ConsumptionRatesDetails crd
        WHERE ConsumptionrateID = @OldRateID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
    
    SELECT @NewConsumptionID
END
GO