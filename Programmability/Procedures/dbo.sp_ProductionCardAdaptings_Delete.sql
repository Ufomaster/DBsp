SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   06.03.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   04.03.2013$*/
/*$Version:    1.00$   $Decription: Удаление участника согласования$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptings_Delete]
    @EmployeeID Int, 
    @StatusID int,
    @ID int
AS
BEGIN
    SET NOCOUNT ON
    DELETE mc
    FROM ProductionCardCustomizeAdaptingsMesChat mc
    INNER JOIN ProductionCardCustomizeAdaptingsMes mes ON mes.ID = mc.ProductionCardCustomizeAdaptingsMesID
    INNER JOIN ProductionCardCustomizeAdaptings a ON a.ID = mes.ProductionCardCustomizeAdaptingsID 
    WHERE a.EmployeeID = @EmployeeID AND a.StatusID = @StatusID AND a.ProductionCardCustomizeID = @ID

    DELETE mes
    FROM ProductionCardCustomizeAdaptingsMes mes 
    INNER JOIN ProductionCardCustomizeAdaptings a ON a.ID = mes.ProductionCardCustomizeAdaptingsID 
    WHERE a.EmployeeID = @EmployeeID AND a.StatusID = @StatusID AND a.ProductionCardCustomizeID = @ID

    DELETE a
    FROM ProductionCardCustomizeAdaptings a
    WHERE a.EmployeeID = @EmployeeID AND a.StatusID = @StatusID AND a.ProductionCardCustomizeID = @ID
END
GO