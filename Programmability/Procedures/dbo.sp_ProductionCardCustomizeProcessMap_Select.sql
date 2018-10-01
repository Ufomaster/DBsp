SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   23.03.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.06.2018$*/
/*$Version:    1.00$   $Decription: выборка карты статусов$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeProcessMap_Select]
    @Type Int,
    @StatusID Int
AS
BEGIN
    SELECT
        pm.ID,
        pm.Type,
        pm.StatusID,
        pm.GoStatusID,
        pm.NotifyEventID,
        pm.NeedAdaptingCheck,
        pm.SetManSignedDate,
        pm.SetManSignedDateClear,
        pm.SetTecSignedDate,
        pm.SetTecSignedDateClear,        
        pm.SetCompleteDate,
        pm.CheckAdaptingEmployees,
        pm.SetProductionDate,
        pm.CheckReleaseDates,
        pm.CheckFieldNumber,
        pm.CheckFieldCardCountInvoice,
        pm.CheckFieldName,
        pm.CheckFieldSketchFileName,
        pm.CheckFieldSourceType,
        pm.NeedTechFillCheck,
        pm.CheckDBFields,
        pm.NeedDetailsFillCheck,
        pm.CheckDetailsNormaUnit,
        pm.UseSendNotifyToAllAdaptingMembers,
        pm.UseSendNotifyToManager,
        pm.UseSendNotifyToTech,
        pm.CheckDBRequirements,
        pm.CheckInstructionExistance,
        pm.CheckOrigSchemesText,
        pm.CheckCancelReasonID,
        pm.CheckLayoutsExistance,
        pm.CheckPersRequirements,
        pm.CheckRawMatSuplierCustomerName,
        pm.CheckSpecificationDate,
        pm.SetTO,
        pm.CheckTechCardNumber,
        pm.CheckisGroupedProduction,
        pm.CheckWeight
    FROM ProductionCardProcessMap pm
    INNER JOIN ProductionCardStatuses s ON s.ID = pm.GoStatusID
    WHERE pm.[Type] = @Type AND pm.StatusID = @StatusID AND s.isReplaceStatus = 0

    UNION ALL

    SELECT TOP 1
        pm.ID,
        pm.Type,
        @StatusID,
        @StatusID,
        NULL,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,        
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
    FROM ProductionCardProcessMap pm
    WHERE pm.[Type] = @Type AND pm.StatusID = @StatusID
END
GO