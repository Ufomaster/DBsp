SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   26.12.2011$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   4.01.2013$*/
/*$Version:    1.00$   $Description: Перемещение группы ЗЛ в другой заказ$*/
create PROCEDURE [dbo].[sp_ProductionOrders_MovePCC]
    @ID Int,
    @AArrayOfID Varchar(8000),
    @OldOrderID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int

    /*Задача*/
    /* 1) нужно перенумеровать все оставшиеся ЗЛ в том заказе, из которого вытягиваем*/
    /* 2) нужно добавить в конец все перетягиваемые зл в новый заказ*/

    IF @OldOrderID = @ID
        RETURN

    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалили перемещаемые связи*/
        DELETE a
        FROM ProductionOrdersProdCardCustomize a
        INNER JOIN dbo.fn_StringToITable(@AArrayOfID) b ON b.ID = a.ProductionCardCustomizeID

        /*перенумеруем связи ЗЛ старого заказа.*/
        UPDATE a
        SET a.SortOrder = b.SortOrder
        FROM ProductionOrdersProdCardCustomize a
        INNER JOIN (SELECT ROW_NUMBER() OVER (ORDER BY a.SortOrder) AS SortOrder, ID
                    FROM ProductionOrdersProdCardCustomize a 
                    WHERE a.ProductionOrdersID = @OldOrderID) b ON b.ID = a.ID
        WHERE a.ProductionOrdersID = @OldOrderID
        /*Задача 1 решена.*/
        
        INSERT INTO ProductionOrdersProdCardCustomize(ProductionOrdersID, ProductionCardCustomizeID, SortOrder)
        SELECT 
             @ID, 
             ID,
             ROW_NUMBER() OVER (ORDER BY ID) + (SELECT ISNULL(MAX(SortOrder), 0) FROM ProductionOrdersProdCardCustomize WHERE ProductionOrdersID = @ID)
        FROM dbo.fn_StringToITable(@AArrayOfID)        
        /*Задача 2 решена.*/
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO