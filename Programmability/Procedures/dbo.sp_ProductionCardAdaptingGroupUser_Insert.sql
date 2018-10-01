SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   24.04.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   24.04.2012$*/
/*$Version:    1.00$   $Decription: Добавление привязки участника согласования к группе$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptingGroupUser_Insert]
    @AdaptingEmployeesID Int,
    @AdaptingGroupID Int
AS
BEGIN
    SET NOCOUNT ON
    /* добавим кастомного человека в согласователи*/
    IF NOT EXISTS(SELECT * FROM ProductionCardAdaptingGroupEmployees 
                  WHERE ProductionCardAdaptingGroupEmployeesID = @AdaptingEmployeesID 
                        AND AdaptingGroupID = @AdaptingGroupID)
        INSERT INTO ProductionCardAdaptingGroupEmployees ([AdaptingGroupID], [ProductionCardAdaptingGroupEmployeesID])
        SELECT @AdaptingGroupID, @AdaptingEmployeesID
END
GO