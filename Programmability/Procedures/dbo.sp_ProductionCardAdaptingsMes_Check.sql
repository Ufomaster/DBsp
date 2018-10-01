SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   24.02.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   25.01.2013$*/
/*$Version:    1.00$   $Decription: установка статуса выбранному месаджу$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptingsMes_Check]
    @PCID Int,
    @EmployeeID Int,
    @MessageID Int,
    @Status Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ProductionCardCustomizeAdaptingsID Int

    IF @MessageID IS NOT NULL
        UPDATE a
        SET a.[Status] = @Status, a.CompleteDate = GETDATE()
        FROM ProductionCardCustomizeAdaptingsMes a 
        WHERE a.ID = @MessageID

    --на клиенте нет ID адаптинга. поэтому нечего передать. Берем по @PCID ищем текущий статус и по @EmployeeID
    --определяем ID адаптинга
    SELECT @ProductionCardCustomizeAdaptingsID = ac.ID
    FROM ProductionCardCustomizeAdaptings ac
    INNER JOIN ProductionCardCustomize pc ON pc.ID = @PCID AND ac.ProductionCardCustomizeID = pc.ID
    WHERE ac.ProductionCardCustomizeID = @PCID AND ac.StatusID = pc.StatusID AND ac.EmployeeID = @EmployeeID
    
    -- если не сущуствует неподписанных - пытаемся подписать.    
    IF NOT EXISTS(SELECT * FROM ProductionCardCustomizeAdaptingsMes WHERE ProductionCardCustomizeAdaptingsID = @ProductionCardCustomizeAdaptingsID AND [Status] = 0)
        UPDATE a
        SET a.[Status] = 1, a.SignDate = GETDATE()
        FROM ProductionCardCustomizeAdaptings a
        WHERE a.ID = @ProductionCardCustomizeAdaptingsID
    ELSE
        UPDATE a
        SET a.[Status] = 0, a.SignDate = NULL
        FROM ProductionCardCustomizeAdaptings a
        WHERE a.ID = @ProductionCardCustomizeAdaptingsID
END
GO