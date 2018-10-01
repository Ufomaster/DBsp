SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	 $Create date:   07.07.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   10.04.2015$
--$Version:    1.00$   $Description: Вьюшка с данными оборудования
CREATE VIEW [dbo].[vw_Equipment]
AS
    SELECT
        ot.[Name] + ' (Инв. № ' + e.InventoryNum + ') ' + t.[Name] AS WebName,
        e.[Status],
        e.ID,
        e.TmcID,
        t.[Name],
        t.ObjectTypeID,
        e.InventoryNum,
        e.SerialNum,
        e.CommissioningDate,
        e.CommissioningDocNum,
        e.RetirementDocNum,
        e.DepartmentPositionID,
        e.RetirementDate,
        d.[Name] AS DepartmentName,
        p.[Name] AS PositionName,
        em.FullName,
        ot.[Name] AS ObjectTypeName,
        CASE 
            WHEN id.RecieveDate IS NULL OR e.WarrantyTerms IS NULL THEN NULL 
        ELSE 
            CASE 
                WHEN DATEADD(m, e.WarrantyTerms, id.RecieveDate) >= GetDate() THEN 'На гарантии'
            ELSE 'Нет гарантии' END
        END AS WarrantyState,
        CASE 
            WHEN e.EquipTerms IS NULL THEN NULL 
        ELSE
            CASE
                WHEN DATEADD(m, e.EquipTerms, e.CommissioningDate) < GetDate() THEN 'Истёк'
            ELSE NULL END
        END AS EquipState,
        dp.DepartmentID AS EquipmentDepartmentID,
        em.DepartmentID AS EmployeeDepartmentID,
        em.ID AS EmployeeID,
        e.EquipmentPlaceID,
        ep.[Name] AS EquipmentPlaceName,
        e.EquipTerms,
        e.WarrantyTerms,
        e.InvoiceDetailID,
        IsTor = CASE WHEN ta.ID IS NOT NULL THEN 1 ELSE 0 END,
        IsIT = CASE WHEN ta1.ID IS NOT NULL THEN 1 ELSE 0 END,
        e.WorkTotalsPresent
    FROM dbo.Equipment e
    INNER JOIN dbo.Tmc t ON e.TmcID = t.ID
    INNER JOIN dbo.ObjectTypes ot ON ot.ID = t.ObjectTypeID
    LEFT JOIN dbo.TMCAttributes ta ON ta.TMCID = t.ID AND ta.AttributeID = 9 --TOP
    LEFT JOIN dbo.TMCAttributes ta1 ON ta1.TMCID = t.ID AND ta1.AttributeID = 10 --TOP    
    LEFT JOIN dbo.EquipmentPlaces ep ON ep.ID = e.EquipmentPlaceID
    LEFT JOIN dbo.DepartmentPositions dp ON dp.ID = e.DepartmentPositionID
    LEFT JOIN dbo.Departments d ON d.ID = dp.DepartmentID
    LEFT JOIN dbo.Positions p ON p.ID = dp.PositionID
    LEFT JOIN dbo.vw_Employees em ON em.DepartmentPositionID = dp.ID
    LEFT JOIN dbo.InvoiceDetail id ON id.ID = e.InvoiceDetailID
GO