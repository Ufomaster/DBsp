SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   04.12.2013$*/
/*$Modify:     Poliatykin Oleksii$    $Modify date:   30.08.2017$*/
/*$Version:    1.00$   $Description: выборка актов НС*/
CREATE PROCEDURE [QualityControl].[sp_Acts_Select]
    @StartDate Datetime = NULL,
    @EndDate Datetime = NULL,
    @TemplateID Int = -1,
    @StatusID Int = -1
AS
BEGIN
    SELECT
        a.*,
        eAuthOwner.FullName AS AuthorName,
        eSPSigner.FullName AS SpecialistName,
        s.EnableMassSigning,
        p.Number AS PNumber,
        p.CreateDate AS PCreateDate,
        t.[Name] AS PTypeName,
        CASE
            WHEN z.Number IS NOT NULL THEN z.Number
        ELSE (SELECT TOP 1 pc.Number
              FROM QualityControl.ActsZL d
              INNER JOIN dbo.ProductionCardCustomize PC ON pc.ID = d.PCCID
              WHERE d.ActsID = a.ID)
        END AS ZLNumber,
        CASE
            WHEN z.[Name] IS NOT NULL THEN z.[Name]
        ELSE (SELECT TOP 1 pc.[Name]
              FROM QualityControl.ActsZL d
              INNER JOIN dbo.ProductionCardCustomize PC ON pc.ID = d.PCCID
              WHERE d.ActsID = a.ID)
        END AS ZLName,
        z.CardCountInvoice AS ZLCount,
        vp.[Name] AS ViolationPlaceName,
        CASE WHEN p.PCCID IS NOT NULL THEN 
            (SELECT TOP 1 c.[Name]
                   FROM ProductionOrders o
                   INNER JOIN dbo.ProductionOrdersProdCardCustomize pco ON pco.ProductionCardCustomizeID = p.PCCID AND pco.ProductionOrdersID = o.ID
                   INNER JOIN dbo.Customers c ON c.ID = o.CustomerID)
        ELSE (SELECT TOP 1 c.[Name]
              FROM QualityControl.ActsZL d
              INNER JOIN dbo.ProductionCardCustomize PC ON pc.ID = d.PCCID
              INNER JOIN dbo.ProductionOrdersProdCardCustomize pco ON pco.ProductionCardCustomizeID = d.PCCID
              INNER JOIN dbo.ProductionOrders o ON o.ID = pco.ProductionOrdersID
              INNER JOIN dbo.Customers c ON c.ID = o.CustomerID
              WHERE d.ActsID = a.ID)
        END AS CustomerName,
        te.[Name] AS TemplateName,
        c.Name AS SupplyCustomerName,
        DATEPART(YEAR, a.CreateDate) AS Year,
        ISNULL(c1.Name, c2.Name) AS CustomerAddName,
        ISNULL(ma.Number, a.Number) AS MasterNumber,
        fc.Code as FaultsClassCode,
        fc.[Name] as FaultsClassName,
        fg.[Name] as FaultsGroupsName,
        ISNULL( CAST(frc.Code as Varchar(20)) + ' - ','') + ISNULL(frc.[Name],'')  as FaultsReasonsClassName,
        amr.Name as MainReason
    FROM QualityControl.Acts a
    LEFT JOIN QualityControl.Acts Ma ON Ma.ID = a.MasterActID
    INNER JOIN QualityControl.ActTemplates te ON te.ID = a.ActTemplatesID
    LEFT JOIN vw_Employees eAuthOwner ON eAuthOwner.ID = a.AuthorEmployeeID
    LEFT JOIN vw_Employees eSPSigner ON eSPSigner.ID = a.PVREmployeeID
    LEFT JOIN QualityControl.ActStatuses s ON s.ID = a.StatusID
    LEFT JOIN QualityControl.Protocols p ON p.ID = a.ProtocolID
    LEFT JOIN Customers c ON c.ID = p.SupplyCustomerID
    LEFT JOIN Customers c1 ON c1.ID = p.CustomerID 
    LEFT JOIN Customers c2 ON c2.ID = a.CustomerID   
    LEFT JOIN dbo.ProductionCardCustomize Z ON z.ID = p.PCCID
    LEFT JOIN QualityControl.Types t ON t.ID = p.TypesID
    LEFT JOIN QualityControl.ViolationPlaces vp ON vp.ID = a.ViolationPlaceID
    LEFT JOIN QualityControl.FaultsReasonsClass frc ON frc.ID = a.FaultsReasonsClassID
    LEFT JOIN QualityControl.FaultsGroups fg on fg.ID = frc.FaultsGroupsID
    LEFT JOIN QualityControl.FaultsClass fc on fc.ID = fg.FaultsClassID
    LEFT JOIN QualityControl.ActsMainReason amr on amr.ID = a.MainReasonID
    WHERE 
        (a.CreateDate BETWEEN ISNULL(@StartDate, a.CreateDate) AND ISNULL(@EndDate, a.CreateDate))
        AND
        (@TemplateID = -1 OR (a.ActTemplatesID = @TemplateID))
        AND 
        (@StatusID = -1 OR (a.StatusID = @StatusID))
END
GO