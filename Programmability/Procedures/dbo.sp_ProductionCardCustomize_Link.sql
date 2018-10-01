SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   03.01.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   03.01.2013$*/
/*$Version:    1.00$   $Description: Привязка ЗЛ к заказу$*/
create PROCEDURE [dbo].[sp_ProductionCardCustomize_Link]
   @ID int, 
   @ZLOrderID int, 
   @NewOrderID int
AS
BEGIN
    SET NOCOUNT ON
    IF NOT EXISTS(SELECT ID FROM dbo.ProductionOrdersProdCardCustomize WHERE ProductionCardCustomizeID = @ID AND ProductionOrdersID = @NewOrderID)
       INSERT INTO dbo.ProductionOrdersProdCardCustomize(ProductionCardCustomizeID, ProductionOrdersID, SortOrder)
       SELECT @ID, @NewOrderID, ISNULL(MAX(SortOrder), 0) + 1
       FROM ProductionOrdersProdCardCustomize
       WHERE ProductionOrdersID = @NewOrderID    
END
GO