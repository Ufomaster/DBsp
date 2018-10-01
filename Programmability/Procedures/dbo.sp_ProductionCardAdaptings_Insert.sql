SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   06.03.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   25.01.2013$*/
/*$Version:    1.00$   $Decription: Добавление участника согласования$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptings_Insert]
    @EmployeeID Int,
    @ProductionCustomizeID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @StatusID Int
    SELECT @StatusID = StatusID
    FROM ProductionCardCustomize p 
    INNER JOIN ProductionCardStatuses s ON s.ID = p.StatusID AND s.IsAdaptingFunction = 1 --только для статусов с функцией адаптинга
    WHERE p.ID = @ProductionCustomizeID
    
    IF NOT @StatusID IS NULL     
        /* добавим кастомного человека в согласователи*/
        IF NOT EXISTS(SELECT * FROM ProductionCardCustomizeAdaptings 
                      WHERE EmployeeID = @EmployeeID 
                            AND ProductionCardCustomizeID = @ProductionCustomizeID 
                            AND StatusID = @StatusID)
            INSERT INTO ProductionCardCustomizeAdaptings ([EmployeeID], [ProductionCardCustomizeID], [Date], [Status], StatusID)
            SELECT @EmployeeID, @ProductionCustomizeID, GetDate(), NULL, @StatusID

END
GO