SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   08.11.2013$*/
/*$Modify:     Poliatykin Oleksii$    $Modify date:   19.10.2017$*/
/*$Version:    1.00$   $Description: выборка протоколов$*/
CREATE PROCEDURE [QualityControl].[sp_Protocols_Select]
    @StartDate Datetime = NULL,
    @EndDate Datetime = NULL,
    @TypeID Int
AS
BEGIN
DECLARE @LOG_StartDate datetime SELECT @LOG_StartDate = GetDate()

    
    SELECT
        p.ID,
        p.CreateDate,
        p.EmployeeID,
        p.EmployeeSpecialistID,
        p.Number,
        p.PCCID,
        p.StatusID,
        p.TmcID,
        p.TypesID,
        p.EmployeeSignDate,
        p.EmployeeSpecialistSignDate,
        eAuthOwner.FullName AS AuthorName,
        eSPSigner.FullName AS SpecialistName,
        p.[Result],
        p.CustomerID,
        pt.[Name] AS PCTypeName,
        pc.Number AS PCNumber,
        pc.[Name] AS PCName,
        pc.CardCountInvoice,
        QualityControl.fn_ProtocolsDetailsGetUP(p.ID) AS CuttedParamsNames,
        p.ActOfTestCloseDate,
        p.ActOfTestCreateDate,
        t.[Name] AS TmcName,
        p.IncomingCount,
        sborka.Number AS [SborkaNumber],
        c.[Name] AS CustomerName
    FROM QualityControl.Protocols p
    LEFT JOIN ProductionCardCustomize pc ON pc.ID = p.PCCID
    LEFT JOIN ProductionCardCustomizeDetails det ON det.LinkedProductionCardCustomizeID = p.PCCID
    LEFT JOIN ProductionCardCustomize sborka ON sborka.ID = det.ProductionCardCustomizeID    
    LEFT JOIN Tmc t ON t.ID = p.TmcID
    LEFT JOIN ProductionCardTypes pt ON pt.ProductionCardPropertiesID = pc.TypeID
    LEFT JOIN vw_Employees eAuthOwner ON eAuthOwner.ID = p.EmployeeID
    LEFT JOIN vw_Employees eSPSigner ON eSPSigner.ID = p.EmployeeSpecialistID
    LEFT JOIN Customers c on c.id = p.CustomerID
    WHERE 
        (p.CreateDate BETWEEN ISNULL(@StartDate, p.CreateDate) AND ISNULL(@EndDate, p.CreateDate))
        AND
        (@TypeID = -1 OR (p.TypesID = @TypeID))
        AND p.isDeleted = 0
    ORDER BY p.CreateDate

EXEC shifts.sp_LogProcedureExecDuration_Insert 'QualityControl.sp_Protocols_Select', @LOG_StartDate
END
GO