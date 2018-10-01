SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   24.04.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   24.04.2012$*/
/*$Version:    1.00$   $Decription: Удаление привязки участника согласования к группе$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptingGroupUser_Delete]
    @AdaptingEmployeesID Int,
    @AdaptingGroupID Int
AS
BEGIN
    SET NOCOUNT ON
    /* добавим кастомного человека в согласователи*/
    IF EXISTS(SELECT * FROM ProductionCardAdaptingGroupEmployees 
                  WHERE ProductionCardAdaptingGroupEmployeesID = @AdaptingEmployeesID 
                        AND AdaptingGroupID = @AdaptingGroupID)
        DELETE FROM ProductionCardAdaptingGroupEmployees 
        WHERE ProductionCardAdaptingGroupEmployeesID = @AdaptingEmployeesID 
              AND AdaptingGroupID = @AdaptingGroupID
END
GO