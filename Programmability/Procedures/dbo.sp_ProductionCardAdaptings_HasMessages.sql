SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   25.01.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   25.01.2013$*/
/*$Version:    1.00$   $Decription: проверка наличия месаджей$*/
create PROCEDURE [dbo].[sp_ProductionCardAdaptings_HasMessages]
    @PCID Int,
    @EmployeeID Int
AS
BEGIN 
    /*на клиенте нет ID адаптинга. поэтому нечего передать. Берем по @PCID ищем текущий статус и по @EmployeeID*/
    /*определяем ID адаптинга и кол-во месаджей считаем по этому ИД*/
    SELECT COUNT(*)
    FROM ProductionCardCustomizeAdaptingsMes a 
    INNER JOIN ProductionCardCustomize pc ON pc.ID = @PCID
    INNER JOIN ProductionCardCustomizeAdaptings ad ON ad.ID = a.ProductionCardCustomizeAdaptingsID 
       AND ad.ProductionCardCustomizeID = @PCID AND ad.EmployeeID = @EmployeeID
    WHERE pc.StatusID = ad.StatusID
END
GO