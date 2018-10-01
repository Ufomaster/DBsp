SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   21.03.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   10.10.2013$*/
/*$Version:    1.00$   $Decription: проверка возможности редактирования$*/
CREATE PROCEDURE [dbo].[sp_ProductionOrders_CheckEditing]
    @ID Int
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS(SELECT a.ID
              FROM ProductionOrdersProdCardCustomize a 
              WHERE a.ProductionOrdersID = @ID)    
        SELECT COUNT(a.ID)
        FROM ProductionOrdersProdCardCustomize a 
        INNER JOIN ProductionCardCustomize pc ON pc.ID = a.ProductionCardCustomizeID AND pc.StatusID NOT IN (4,5,6,10,11) 
        WHERE a.ProductionOrdersID = @ID
    ELSE
        SELECT 1
END
GO