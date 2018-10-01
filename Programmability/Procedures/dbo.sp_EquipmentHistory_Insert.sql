SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   08.08.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   08.08.2011$
--$Version:    1.00$   $Description: Добавление истории изменения оборудования$
CREATE PROCEDURE [dbo].[sp_EquipmentHistory_Insert]
    @EmployeeID Int,
    @EquipmentID Int,
    @OperationType Int    --0-insert, 1-update, 2-delete
AS
BEGIN
	SET NOCOUNT ON
    INSERT INTO dbo.EquipmentHistory(EquipmentID, TmcID, TmcName, InventoryNum, SerialNum, CommissioningDate,
        CommissioningDocNum, RetirementDate, RetirementDocNum, [Status], StatusName, DepartmentPositionID,
        DepartmentPositionName, EquipmentPlaceID, EquipmentPlaceName, EquipTerms, WarrantyTerms, InvoiceDetailID,
        ModifyEmployeeID, OperationType)
    SELECT
        e.ID,
        e.TmcID,
        t.[Name],
        e.InventoryNum,
        e.SerialNum,
        e.CommissioningDate,
        e.CommissioningDocNum,
        e.RetirementDate,
        e.RetirementDocNum,
        e.[Status],
        CASE e.[Status] WHEN 0 THEN 'В разработке' WHEN 1 THEN 'В эксплуатации' WHEN 2 THEN 'Списано' END,
        e.DepartmentPositionID,
        e.DepartmentName + ' - ' + e.PositionName,
        e.EquipmentPlaceID,
        e.EquipmentPlaceName,
        e.EquipTerms,
        e.WarrantyTerms,
        e.InvoiceDetailID,
        @EmployeeID,
        @OperationType
    FROM vw_Equipment e
    LEFT JOIN Tmc t ON t.ID = e.TmcID
    WHERE e.ID = @EquipmentID
    SELECT 1 AS ID
END
GO