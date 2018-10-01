SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   03.12.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   06.08.2015$*/
/*$Version:    1.00$   $Decription: Выбор элементов хранилища$*/
CREATE PROCEDURE [dbo].[sp_Equipment_ListSelect]
    @DepartmentID int,
    @DepartmentName varchar(1000) = NULL
AS
BEGIN
    IF @DepartmentName IS NULL
    BEGIN
        SELECT
            e.[Status],
            e.ID,
            e.TmcID,
            t.[Name],
            t.ObjectTypeID,
            e.InventoryNum,
            e.SerialNum,
            e.CommissioningDate,
            e.RetirementDate,
            d.[Name] AS DepartmentName,
            p.[Name] AS PositionName,
            em.FullName,
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
            END AS EquipState
        FROM dbo.Equipment e
        INNER JOIN dbo.Tmc t ON e.TmcID = t.ID
        INNER JOIN dbo.ObjectTypes ot ON ot.ID = t.ObjectTypeID
        INNER JOIN dbo.TmcObjectLinks ol ON ol.TmcID = t.ID
        LEFT JOIN dbo.DepartmentPositions dp ON dp.ID = e.DepartmentPositionID
        LEFT JOIN dbo.Departments d ON d.ID = dp.DepartmentID AND ISNULL(d.IsHidden, 0) = 0
        LEFT JOIN dbo.Positions p ON p.ID = dp.PositionID
        LEFT JOIN dbo.vw_Employees em ON em.DepartmentPositionID = dp.ID
        LEFT JOIN dbo.InvoiceDetail id ON id.ID = e.InvoiceDetailID
        WHERE (e.[Status] = 1) 
            AND (dp.DepartmentID IN (SELECT ID from dbo.fn_DepartmentsNode_Select(@DepartmentID)) OR dp.DepartmentID = @DepartmentID)
    END
    ELSE
    BEGIN
       SELECT
            e.[Status],
            e.ID,
            e.TmcID,
            t.[Name],
            t.ObjectTypeID,
            e.InventoryNum,
            e.SerialNum,
            e.CommissioningDate,
            e.RetirementDate,
            d.[Name] AS DepartmentName,
            p.[Name] AS PositionName,
            em.FullName,
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
            END AS EquipState
        FROM dbo.Equipment e
        INNER JOIN dbo.Tmc t ON e.TmcID = t.ID
        INNER JOIN dbo.ObjectTypes ot ON ot.ID = t.ObjectTypeID
        INNER JOIN dbo.TmcObjectLinks ol ON ol.TmcID = t.ID
        LEFT JOIN dbo.DepartmentPositions dp ON dp.ID = e.DepartmentPositionID
        LEFT JOIN dbo.Departments d ON d.ID = dp.DepartmentID AND ISNULL(d.IsHidden, 0) = 0
        LEFT JOIN dbo.Positions p ON p.ID = dp.PositionID
        LEFT JOIN dbo.vw_Employees em ON em.DepartmentPositionID = dp.ID
        LEFT JOIN dbo.InvoiceDetail id ON id.ID = e.InvoiceDetailID
        WHERE (e.[Status] = 1) 
            AND (d.[Name] = @DepartmentName)
    END
END
GO