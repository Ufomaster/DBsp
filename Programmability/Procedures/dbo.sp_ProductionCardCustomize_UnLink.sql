SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   03.01.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   03.01.2013$*/
/*$Version:    1.00$   $Description: Отвязка ЗЛ от заказа$*/
create PROCEDURE [dbo].[sp_ProductionCardCustomize_UnLink]
   @ID int, 
   @ZLOrderID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @SortOrder int
    /*Если есть только одна привязка - удалить нельзя.*/
    IF EXISTS(SELECT COUNT(ID)
              FROM ProductionOrdersProdCardCustomize a
              WHERE a.ProductionCardCustomizeID = @ID
              GROUP BY a.ProductionCardCustomizeID
              HAVING COUNT(ID) < 2)
    BEGIN
        RAISERROR('Нельзя удалить единственную связь ЗЛ с Заказом', 16, 1);
        RETURN;
    END;
    
    BEGIN TRANSACTION;
    SELECT @SortOrder = SortOrder 
    FROM ProductionOrdersProdCardCustomize a
    WHERE a.ProductionCardCustomizeID = @ID AND a.ProductionOrdersID = @ZLOrderID;

    UPDATE a
    SET a.SortOrder = a.SortOrder - 1
    FROM ProductionOrdersProdCardCustomize a
    WHERE a.ProductionOrdersID = @ZLOrderID AND a.SortOrder > @SortOrder;

    DELETE FROM ProductionOrdersProdCardCustomize
    WHERE ProductionOrdersID = @ZLOrderID AND ProductionCardCustomizeID = @ID;
    
    COMMIT TRANSACTION;
END
GO