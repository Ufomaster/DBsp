SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   12.03.2012$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   20.06.2018*/
/*$Version:    1.00$   $Description: Добавление истории редактирования заказных$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeHistory_Insert]
    @EmployeeID Int,
    @ProductionCardCustomizeID Int,
    @OperationType Int    /*0-insert, 1-update, 2-delete*/
AS
BEGIN
	SET NOCOUNT ON
    CREATE TABLE #tblID(ID Int)
    
    INSERT INTO dbo.ProductionCardCustomizeHistory(ProductionCardCustomizeID, CreateDate,
        ModifyEmployeeID, ModifyDate, OperationType, [Name], [Number], PrintOrientPCCID, PrintOrientActNumber,
        CardCountInvoice, DateProductionTransfer, 
        CustomerPresence, DBDateIncome, DBWayIncome, LayoutsSchemes,
        DBDateStore, SpecificationNumber, OfficialNote, CardDemoSomewhere,
        ApprovedSampleOfPersonalization, ApprovedTestScreenPrinting,
        DemoSample, SketchFileName, PrintOrientID, 
        LinkProductionCardCustomizeID,
        StatusID, ManEmployeeID, ManSignedDate, 
        CompleteDate, TypeID, DemoPackPaper, DocTasks, ColorPick, 
        PersonalizationDescription, AdaptingGroupID, TecEmployeeID, TecSignedDate,
        RawMatSuppliedByCustomer, RawMatSpekl, RawMatPurchaseByCustomer, RawMatIndepContractor,
        [DBRequirements], [PackingRequirements], [ProductionRequirements], CancelReasonID, 
        PersonalizeRequirements, RawMatSuppliedByCustomerName, TechnologicalCardID, TmcID,
        SpecificationDate, RawMatPurchaseIndepContractor, RawMatIndepContractor2, RawMatSpeklTraf, 
        RawMatSpeklCyfra, PVHPrintSide, PVHFormat, TechnologistPresence, PersonalizeRequirementsExtended,
        DBReceiveDate, WeightGross, WeightNet, PackingID, WeightPlaceCount, isGroupedProduction, GroupedZLText)
    OUTPUT INSERTED.ID INTO #tblID
    SELECT ID, CreateDate,
        @EmployeeID, GetDate(), @OperationType, [Name], [Number], PrintOrientPCCID, PrintOrientActNumber,
        CardCountInvoice, DateProductionTransfer, 
        CustomerPresence, DBDateIncome, DBWayIncome, LayoutsSchemes,
        DBDateStore, SpecificationNumber, OfficialNote, CardDemoSomewhere,
        ApprovedSampleOfPersonalization, ApprovedTestScreenPrinting,
        DemoSample, SketchFileName, PrintOrientID, 
        ProductionCardCustomizeID,
        StatusID, ManEmployeeID, ManSignedDate, 
        CompleteDate, TypeID, DemoPackPaper, DocTasks, ColorPick,
        PersonalizationDescription, AdaptingGroupID, TecEmployeeID, TecSignedDate,
        RawMatSuppliedByCustomer, RawMatSpekl, RawMatPurchaseByCustomer, RawMatIndepContractor,
        [DBRequirements], [PackingRequirements], [ProductionRequirements], CancelReasonID, 
        PersonalizeRequirements, RawMatSuppliedByCustomerName, TechnologicalCardID, TmcID,
        SpecificationDate, RawMatPurchaseIndepContractor, RawMatIndepContractor2, RawMatSpeklTraf, 
        RawMatSpeklCyfra, PVHPrintSide, PVHFormat, TechnologistPresence, PersonalizeRequirementsExtended,
        DBReceiveDate, WeightGross, WeightNet, PackingID, WeightPlaceCount, isGroupedProduction, GroupedZLText
    FROM ProductionCardCustomize
    WHERE ID = @ProductionCardCustomizeID

    DECLARE @ProductionCardCustomizeHistoryID Int

    SELECT @ProductionCardCustomizeHistoryID = ID FROM #tblID

    INSERT INTO ProductionCardCustomizePropertiesHistory(PropHistoryValueID, HandMadeValue, HandMadeValueOwnerID,
        ProductionCardCustomizeHistoryID, SourceType)
    SELECT PropHistoryValueID, HandMadeValue, HandMadeValueOwnerID, @ProductionCardCustomizeHistoryID, SourceType
    FROM ProductionCardCustomizeProperties
    WHERE ProductionCardCustomizeID = @ProductionCardCustomizeID

    INSERT INTO ProductionCardCustomizeDetailsHistory(LinkedProductionCardCustomizeID,
         ProductionCardCustomizeHistoryID, Norma, TmcName, UnitName, Kind) 
    SELECT a.LinkedProductionCardCustomizeID,
         @ProductionCardCustomizeHistoryID, a.Norma, t.[Name], u.[Name], a.Kind
    FROM ProductionCardCustomizeDetails a
    LEFT JOIN Tmc t ON t.ID = a.TmcID
    LEFT JOIN Units u ON u.ID = a.UnitID
    WHERE a.ProductionCardCustomizeID = @ProductionCardCustomizeID

    INSERT INTO ProductionCardCustomizeDocDetailsHistory(Number, [Name], [Format], NeedCheck, ProductionCardCustomizeHistoryID) 
    SELECT Number, [Name], [Format], NeedCheck, @ProductionCardCustomizeHistoryID
    FROM ProductionCardCustomizeDocDetails
    WHERE ProductionCardCustomizeID = @ProductionCardCustomizeID

    DROP TABLE #tblID
END
GO