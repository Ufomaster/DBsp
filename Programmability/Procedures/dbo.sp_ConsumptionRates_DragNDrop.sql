SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuiriy$    $Create date:   09.04.2012$
--$Modify:     Oleynik Yuiriy$    $Modify date:   06.01.2017$
--$Version:    1.00$   $Description: $
CREATE PROCEDURE [dbo].[sp_ConsumptionRates_DragNDrop]
    @ID Int, -- что бросили
    @ObjectTypeID Int, -- Объект, куда бросили. (или) oldObjectTypesMaterialsID 
    @ObjectTypesMaterialsID Int = NULL, -- связка о-м, в которую бросили. (или)      
    @NewTechOperationID Int = NULL, -- технологическая операция в которую бросили. (или)    
    @Type Int -- как бросили, 0 - объект. 1- норма(Rates)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @tObjectTypesMaterialID Int, @TmcID Int
    DECLARE @T TABLE(ID Int)

    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF @Type = 0
        BEGIN
            --проверка возможности ДРОП. Можем драг дропнуть только если никогда небыло такого материала или он закрыт. Логично?
            --Или следует оверлоаднуть все что было новыми настройками? Это было бы полезно если нужно исправить в одном месте и размножить в других

            --получаем материал того что кидаем.
            SELECT @TmcID = otm.TmcID
            FROM dbo.ConsumptionRates cr
            LEFT JOIN ObjectTypesMaterials otm ON otm.ID = cr.ObjectTypesMaterialID
            WHERE cr.ID = @ID
            --проверки
            IF EXISTS(SELECT * FROM ObjectTypesMaterials otm 
                      WHERE otm.ObjectTypeID = @ObjectTypeID AND otm.TmcID = @TmcID
                            AND otm.BeginDate IS NULL)
    --            RAISERROR('Связка Значение + Материал уже существует', 16, 1)
                --кидаем в этот же АЙДИ, так как анедр констракшн - нам позволяет все
                SELECT @tObjectTypesMaterialID = otm.ID FROM ObjectTypesMaterials otm 
                WHERE otm.ObjectTypeID = @ObjectTypeID AND otm.TmcID = @TmcID
                      AND otm.BeginDate IS NULL
            ELSE
            BEGIN        
                --ДРОП - то есть, тупо инсерт материала
                INSERT INTO ObjectTypesMaterials (ObjectTypeID, TmcID)
                OUTPUT INSERTED.ID INTO @T
                VALUES (@ObjectTypeID, @TmcID)

                -- получаем новый Ид из ObjectTypesMaterials
                SELECT @tObjectTypesMaterialID = ID FROM @t
            END

            EXEC sp_ConsumptionRates_Copy  @ID, @tObjectTypesMaterialID, -1
        END
        ELSE
        IF @Type = 1
        BEGIN
            EXEC sp_ConsumptionRates_Copy  @ID, @ObjectTypesMaterialsID, @NewTechOperationID
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