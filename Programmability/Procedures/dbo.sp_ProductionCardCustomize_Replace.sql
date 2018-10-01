SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   16.01.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   04.03.2013$*/
/*$Version:    1.00$   $Decription: копирование ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomize_Replace]
    @CancelReasonID int,
    @CustomizeID Int,
    @OrderID int,
    @SaveNumber bit = 0
AS
BEGIN
    DECLARE @t TABLE(ID Int)
    DECLARE @OutID Int, @StatusID int, @SetManSignedDate bit, @SetTecSignedDate bit, 
      @SetTecSignedDateClear bit, @SetManSignedDateClear bit, @EmployeeID int, @ManEmployeeID int

    SELECT @EmployeeID = EmployeeID FROM #CurrentUser
    SELECT @ManEmployeeID = ManEmployeeID FROM ProductionCardCustomize WHERE ID = @CustomizeID
            
    /*найдем статус в который будем переходить*/
    SELECT TOP 1 @StatusID = ID FROM ProductionCardStatuses p WHERE p.isReplaceStatus = 1
    /*найдем что нужно делать по карте прохождения. Актуально только подпись - снятие с заказного. Остальное нелогично и игноррируем.*/
    SELECT
        @SetManSignedDate = pm.SetManSignedDate,
        @SetTecSignedDate = pm.SetTecSignedDate,
        @SetTecSignedDateClear = pm.SetTecSignedDateClear,
        @SetManSignedDateClear = pm.SetManSignedDateClear
    FROM ProductionCardProcessMap pm
    INNER JOIN ProductionCardTypes t ON t.ID = pm.[Type]
    INNER JOIN ProductionCardCustomize pc ON pc.ID = @CustomizeID AND t.ProductionCardPropertiesID = pc.TypeID
    INNER JOIN ProductionCardStatuses s ON s.ID = pm.GoStatusID AND s.isReplaceStatus = 1
    WHERE pm.StatusID = pc.StatusID

    IF @StatusID IS NOT NULL
    BEGIN
        /*копируем заказной лист. С сохранением номера.*/
        INSERT INTO @t(ID)
        EXEC sp_ProductionCardCustomize_Copy @CustomizeID, @OrderID, 0, 1

        SELECT @OutID = ID FROM @t

        IF @OutID IS NOT NULL -- если скопировалось
        BEGIN
            --Если сборка заменяется - удаляем старые связи по Комплектам.
            IF EXISTS(SELECT t.ID 
                      FROM ProductionCardCustomize a
                      INNER JOIN ProductionCardTypes t ON t.ProductionCardPropertiesID = a.TypeID
                      WHERE t.ID = 4 AND a.ID = @CustomizeID)
            BEGIN
                DELETE ad 
                FROM ProductionCardCustomizeDetails ad
                WHERE ad.ProductionCardCustomizeID = @CustomizeID AND ad.LinkedProductionCardCustomizeID IS NOT NULL
            END
            ELSE -- если вдруг комплект или сырье, удаляем из связки
                DELETE ad 
                FROM ProductionCardCustomizeDetails ad
                WHERE ad.LinkedProductionCardCustomizeID = @CustomizeID

            /* устанавливаем связь нового Заказного с тем что был заменен. Апдейтим новый ЗЛ старым менеджером*/
            UPDATE ProductionCardCustomize
            SET ChangedPCCID = @CustomizeID, ManEmployeeID = @ManEmployeeID
            WHERE ID = @OutID

            /*старый ЗЛ получил некоторые изменения данных по карте прохожденияи по полям.*/
            UPDATE a
            SET a.StatusID = @StatusID,
                a.CancelReasonID = @CancelReasonID,
/*                a.ManSignedDate = CASE @SetManSignedDate WHEN 1 THEN GetDate() ELSE CASE @SetManSignedDateClear WHEN 1 THEN NULL ELSE a.ManSignedDate END END,
                a.ManEmployeeID = CASE @SetManSignedDate WHEN 1 THEN @ManEmployeeID ELSE CASE @SetManSignedDateClear WHEN 1 THEN NULL ELSE a.ManEmployeeID END END,
*/
                a.TecSignedDate = CASE @SetTecSignedDate WHEN 1 THEN GetDate() ELSE CASE @SetTecSignedDateClear WHEN 1 THEN NULL ELSE a.TecSignedDate END END,
                a.TecEmployeeID = CASE @SetTecSignedDate WHEN 1 THEN @EmployeeID ELSE CASE @SetTecSignedDateClear WHEN 1 THEN NULL ELSE a.TecEmployeeID END END
            FROM ProductionCardCustomize a
            WHERE a.ID = @CustomizeID

            /*история для замененного ЗЛ*/
            EXEC sp_ProductionCardCustomizeHistory_Insert @EmployeeID, @CustomizeID, 1

            /*история для нового ЗЛ*/
            /*инсерт истории был в копировании, теперь апдейт, все из-за одного поля */
            EXEC sp_ProductionCardCustomizeHistory_Insert @EmployeeID, @OutID, 1 
        END
    END
    SELECT @OutID AS ID
END
GO