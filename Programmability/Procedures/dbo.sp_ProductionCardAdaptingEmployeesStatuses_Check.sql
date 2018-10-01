SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   02.10.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   02.10.2012$*/
/*$Version:    1.00$   $Description: добавление статуса соглсования для участия сотрудника$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptingEmployeesStatuses_Check]
    @ID Int,
    @StatusID Int
AS
BEGIN
    IF EXISTS(SELECT ID FROM ProductionCardAdaptingEmployeesStatuses 
              WHERE ProductionCardStatusesID = @StatusID 
                 AND ProductionCardAdaptingEmployeesID = @ID)
        DELETE 
        FROM ProductionCardAdaptingEmployeesStatuses 
        WHERE ProductionCardStatusesID = @StatusID 
            AND ProductionCardAdaptingEmployeesID = @ID
    ELSE
        INSERT INTO ProductionCardAdaptingEmployeesStatuses(ProductionCardStatusesID, ProductionCardAdaptingEmployeesID)
        SELECT @StatusID, @ID
END
GO