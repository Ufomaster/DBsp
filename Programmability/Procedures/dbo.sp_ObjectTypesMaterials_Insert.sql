SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   19.01.2012$
--$Modify:     Oleynik Yuiriy$          $Modify date:   02.11.2015$
--$Version:    1.00$   $Description: Добавление связки значения справочников с материалами$
CREATE PROCEDURE [dbo].[sp_ObjectTypesMaterials_Insert]
    @ID Int, --праймари кей записи ObjectTypes
    @TmcID Int, --праймари кей материал TMC
    @GroupName varchar(30) = NULL--группировка одинаковых тмц
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @ObjectTypesMaterialID Int, @OldConsumptionrateID Int, @NewObjectTypesMaterialID Int
    DECLARE @T TABLE(ID Int)
        IF @GroupName = '' 
            SET @GroupName = NULL
            
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF NOT EXISTS(SELECT * FROM ObjectTypesAttributes ota 
                      WHERE ota.AttributeID = 5 AND ota.ObjectTypeID = @ID)
            RAISERROR('Добавление элементов, которые не явлюятся значениями справочников производства, запрещено', 16, 1)

        IF EXISTS(SELECT * FROM ObjectTypesMaterials otm 
                      WHERE otm.ObjectTypeID = @ID AND otm.TmcID = @TmcID
                            AND otm.BeginDate IS NULL
                            AND (otm.GroupName = @GroupName OR (otm.GroupName IS NULL AND @GroupName IS NULL)))
            RAISERROR('Значение уже существует', 16, 1)
            
        INSERT INTO ObjectTypesMaterials (ObjectTypeID, TmcID, GroupName)
        OUTPUT INSERTED.ID INTO @T
        VALUES (@ID, @TmcID, @GroupName)

        SELECT TOP 1 @ObjectTypesMaterialID = otm.ID 
        FROM ObjectTypesMaterials otm 
        WHERE otm.ObjectTypeID = @ID AND otm.TmcID = @TmcID
             AND otm.BeginDate IS NOT NULL
             AND (otm.GroupName = @GroupName OR (otm.GroupName IS NULL AND @GroupName IS NULL))
        ORDER BY otm.BeginDate DESC

        SELECT @NewObjectTypesMaterialID = ID FROM @T

        --Копируем нормы расходов из @ObjectTypesmaterialID
        DECLARE CRS CURSOR STATIC LOCAL FOR SELECT ID FROM ConsumptionRates AS cr
                                            WHERE cr.ObjectTypesMaterialID = @ObjectTypesmaterialID
        OPEN CRS
        FETCH NEXT FROM CRS INTO @OldConsumptionrateID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC sp_ConsumptionRates_Copy @OldConsumptionrateID, @NewObjectTypesMaterialID
            FETCH NEXT FROM CRS INTO @OldConsumptionrateID
        END

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO