SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   01.10.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   20.06.2018$*/
/*$Version:    1.00$   $Description: выборка ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomize_Select]
    @ViewAll Bit = 0,
    @StartDate Datetime = NULL,
    @EndDate Datetime = NULL,
    @TypeID Int,
    @OrderID Int
AS
BEGIN
DECLARE @LOG_StartDate datetime SELECT @LOG_StartDate = GetDate()
    IF @ViewAll = 1
    BEGIN
        SELECT
            a.[ID],
            a.[TypeID],
            a.[StatusID],
            a.[Number],
            a.[CreateDate],
            a.[Name],
            a.[CardCountInvoice],
            a.[DateProductionTransfer],
            a.[SketchFileName],
            a.ManSignedDate,
            a.TecSignedDate,
            a.CompleteDate,
            pccs.[Name] + ISNULL(' ' + ChangedPC.Number, '') AS StatusName,
            ChangedPC.Number AS ChangedNumber,
            eManOwner.FullName AS ManOwnerName,
            eTecSigner.FullName AS TecEmployeeName,
            CASE 
                WHEN pcm.ProductionCardCustomizeID IS NULL THEN 0 
                WHEN pcm.ProductionCardCustomizeID IS NOT NULL AND (ss.Status = 1 OR ss.ID IS NULL) THEN 1
                WHEN ss.Status = 1 THEN 2
                WHEN ss.Status = 4 THEN 3
            ELSE 4                
            END AS HasMaterials,
            pct.ID AS [Type],
            NULL AS [PrintReportID],
            pccs.ImageID AS StatusImageID,
            pccs.CanEditLayouts,
            pccs.IsAdaptingFunction,
            pccs.isDeletable,
            pccs.CanEditReleaseDates,
            pccs.CanEditInstruction,
            CASE 
                WHEN detPC.ID IS NOT NULL THEN detPC.Number + ' (' + detS.[Name] + ')'
                WHEN detPC.ID IS NULL AND pct.ID = 4 THEN a.[Number]
            END AS SborkaNumber,
            c.[Name] AS CustomerName,
            po.ID AS OrderID,
            pccs.isReplaceStatus,
            po.CustomerOrderNumber,
            po.[Date] AS OrderDate,
            a.LayoutsSchemes,
            lpcc.SketchFileName AS SketchFileName2,
            a.isGroupedProduction
        FROM ProductionCardCustomize a
        LEFT JOIN ProductionCardCustomize lPCC ON lPCC.ID = a.ProductionCardCustomizeID
        LEFT JOIN ProductionOrdersProdCardCustomize poc ON poc.ProductionCardCustomizeID = a.ID
        LEFT JOIN ProductionOrders po ON po.ID = poc.ProductionOrdersID
        LEFT JOIN Customers c ON c.ID = po.CustomerID
        INNER JOIN ProductionCardTypes pct ON pct.ProductionCardPropertiesID = a.TypeID
        INNER JOIN dbo.ProductionCardStatuses pccs ON pccs.ID = a.StatusID
        LEFT JOIN (SELECT ProductionCardCustomizeID
                   FROM ProductionCardCustomizeMaterials 
                   GROUP BY ProductionCardCustomizeID) pcm ON pcm.ProductionCardCustomizeID = a.ID
        LEFT JOIN vw_Employees eManOwner ON eManOwner.ID = a.ManEmployeeID
        LEFT JOIN vw_Employees eTecSigner ON eTecSigner.ID = a.TecEmployeeID
        LEFT JOIN ProductionCardCustomizeDetails det ON det.LinkedProductionCardCustomizeID = a.ID
        LEFT JOIN ProductionCardCustomize detPC ON detPC.ID = det.ProductionCardCustomizeID
        LEFT JOIN ProductionCardStatuses detS on DetS.ID = detPC.StatusID
        LEFT JOIN ProductionCardCustomize ChangedPC ON ChangedPC.ID = a.ChangedPCCID
        LEFT JOIN sync.[1CSpec] ss ON ss.ProductionCardCustomizeID = a.ID AND ss.Kind = 1
        WHERE 
            (a.CreateDate BETWEEN ISNULL(@StartDate, a.CreateDate) AND ISNULL(@EndDate, a.CreateDate))
            AND        
            (@TypeID = -1 OR (a.TypeID = @TypeID))
    END
    ELSE
    IF @ViewAll = 0
    BEGIN
        SELECT
            a.[ID],
            a.[TypeID],
            a.[StatusID],
            a.[Number],
            a.[CreateDate],
            a.[Name],
            a.[CardCountInvoice],
            a.[DateProductionTransfer],
            a.[SketchFileName],
            a.ManSignedDate,
            a.TecSignedDate,
            a.CompleteDate,
            pccs.[Name] AS StatusName,
            ChangedPC.Number AS ChangedNumber,
            eManOwner.FullName AS ManOwnerName,
            eTecSigner.FullName AS TecEmployeeName,
            CASE 
                WHEN pcm.ProductionCardCustomizeID IS NULL THEN 0 
                WHEN pcm.ProductionCardCustomizeID IS NOT NULL AND (ss.Status = 1 OR ss.ID IS NULL) THEN 1
                WHEN ss.Status = 1 THEN 2
                WHEN ss.Status = 4 THEN 3
            ELSE 4                
            END AS HasMaterials,
            pct.ID AS [Type],
            NULL AS [PrintReportID],
            pccs.ImageID AS StatusImageID,
            pccs.CanEditLayouts,
            pccs.IsAdaptingFunction,
            pccs.isDeletable,
            pccs.CanEditReleaseDates,
            pccs.CanEditInstruction,
            pco.SortOrder,
            CASE 
                WHEN detPC.ID IS NOT NULL THEN detPC.Number + ' (' + detS.[Name] + ')'
                WHEN detPC.ID IS NULL AND pct.ID = 4 THEN a.[Number]
            END AS SborkaNumber,
            c.[Name] AS CustomerName,
            po.ID AS OrderID,
            pccs.isReplaceStatus,
            po.CustomerOrderNumber,
            po.[Date] AS OrderDate,
            a.LayoutsSchemes,
            lpcc.SketchFileName AS SketchFileName,
            a.isGroupedProduction
        FROM ProductionCardCustomize a
        LEFT JOIN ProductionCardCustomize lPCC ON lPCC.ID = a.ProductionCardCustomizeID        
        INNER JOIN ProductionOrdersProdCardCustomize pco ON pco.ProductionCardCustomizeID = a.ID AND pco.ProductionOrdersID = @OrderID
        INNER JOIN ProductionOrders po ON po.ID = pco.ProductionOrdersID
        LEFT JOIN Customers c ON c.ID = po.CustomerID
        INNER JOIN ProductionCardTypes pct ON pct.ProductionCardPropertiesID = a.TypeID
        INNER JOIN dbo.ProductionCardStatuses pccs ON pccs.ID = a.StatusID
        LEFT JOIN (SELECT ProductionCardCustomizeID
                   FROM ProductionCardCustomizeMaterials 
                   GROUP BY ProductionCardCustomizeID) pcm ON pcm.ProductionCardCustomizeID = a.ID
        LEFT JOIN vw_Employees eManOwner ON eManOwner.ID = a.ManEmployeeID
        LEFT JOIN vw_Employees eTecSigner ON eTecSigner.ID = a.TecEmployeeID
        LEFT JOIN ProductionCardCustomizeDetails det ON det.LinkedProductionCardCustomizeID = a.ID
        LEFT JOIN ProductionCardCustomize detPC ON detPC.ID = det.ProductionCardCustomizeID
        LEFT JOIN ProductionCardStatuses detS on DetS.ID = detPC.StatusID
        LEFT JOIN ProductionCardCustomize ChangedPC ON ChangedPC.ID = a.ChangedPCCID   
        LEFT JOIN sync.[1CSpec] ss ON ss.ProductionCardCustomizeID = a.ID AND ss.Kind = 1        
        WHERE (@TypeID = -1 OR (a.TypeID = @TypeID))
    END
EXEC shifts.sp_LogProcedureExecDuration_Insert 'dbo.sp_ProductionCardCustomize_Select', @LOG_StartDate		
END
GO