SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   22.05.2015$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   22.05.2015$*/
/*$Version:    1.00$   $Description: Выборка истории редактирования протоколов$*/
create PROCEDURE [QualityControl].[sp_Protocols_History_Select]
    @ProtocolID Int
AS
BEGIN
    SELECT 
        h.*,
        e.FullName AS ModifyEmployeeName,
        e1.FullName AS CreateEmployeeName,
        e2.FullName AS SpecEmployeeName,
        e3.FullName AS WareHouseEmployeeName,        
        t.[Name] AS TypeName,        
        s.[Name] AS StatusName,
        cust.[Name] AS CustomerName,
        PC.Number AS [PCCNumber],
        tmc.[Name] AS [TmcName],
        ss.[Name] AS [StorageStructureName]
    FROM QualityControl.ProtocolsHistory h
    LEFT JOIN vw_Employees e ON e.ID = h.ModifyEmployeeID
    LEFT JOIN vw_Employees e1 ON e1.ID = h.EmployeeID    
    LEFT JOIN vw_Employees e2 ON e2.ID = h.EmployeeSpecialistID
    LEFT JOIN QualityControl.Types t ON t.ID = h.TypesID
    LEFT JOIN QualityControl.TypesStatuses s ON s.ID = h.StatusID    
    LEFT JOIN ProductionCardCustomize PC ON PC.ID = h.PCCID
    LEFT JOIN Tmc ON Tmc.ID = h.TmcID    
    LEFT JOIN Customers cust ON cust.ID = h.CustomerID
    LEFT JOIN vw_Employees e3 ON e3.ID = h.WarehouseEmployeeID
    LEFT JOIN manufacture.StorageStructure ss ON ss.ID = h.StorageStructureID
    LEFT JOIN Units u ON u.ID = ss.ID
    WHERE h.ProtocolsID = @ProtocolID
    ORDER BY h.ModifyDate
END
GO