SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   16.01.2012$
--$Modify:     Yuriy Oleynik$    $Modify date:   15.11.2017$
--$Version:    1.00$   $Decription: копирование ЗЛ$
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomize_Copy]
    @CustomizeID Int,
    @OrderID int,
    @SaveDate Bit = 0,
    @SaveNumber bit = 0
AS
BEGIN
    DECLARE @t TABLE(ID Int)
    DECLARE @OutID Int, @EmployeeID Int
    DECLARE @Root Int, @Date Datetime, @InsertProps Bit, @NewNumber varchar(6)
    
    SET NOCOUNT ON
    DECLARE @Err Int
        
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT @EmployeeID = EmployeeID FROM #CurrentUser
        SELECT @NewNumber = CAST(ISNULL(MAX(SUBSTRING(NUMBER, 1, 5)), '0') AS Int) + 1
        FROM ProductionCardCustomize
        WHERE SUBSTRING(NUMBER, 1, 1) IN ('0','1','2','3','4','5','6','7','8','9') AND 
              SUBSTRING(NUMBER, 2, 1) IN ('0','1','2','3','4','5','6','7','8','9') AND 
              SUBSTRING(NUMBER, 3, 1) IN ('0','1','2','3','4','5','6','7','8','9') AND
              SUBSTRING(NUMBER, 4, 1) IN ('0','1','2','3','4','5','6','7','8','9') AND
              SUBSTRING(NUMBER, 5, 1) IN ('0','1','2','3','4','5','6','7','8','9')
      
        INSERT INTO dbo.ProductionCardCustomize([Name],  Number, CreateDate, ManEmployeeID,
          CardCountInvoice, PrintOrientPCCID, PrintOrientActNumber, CustomerPresence, DBDateIncome,
          DBWayIncome, DBDateStore, SpecificationNumber,
          OfficialNote, CardDemoSomewhere,  ApprovedSampleOfPersonalization,  ApprovedTestScreenPrinting,
          DemoSample, LayoutsSchemes, SketchFileName, PrintOrientID, PrintOrientAdvID,
          ProductionCardCustomizeID, StatusID, TypeID,
          DemoPackPaper, DocTasks, ColorPick, PersonalizationDescription, 
          AdaptingGroupID,RawMatSuppliedByCustomer, RawMatSpekl, RawMatPurchaseByCustomer, RawMatIndepContractor,
          [DBRequirements], [PackingRequirements], [ProductionRequirements], [PersonalizeRequirements],
          RawMatSuppliedByCustomerName, TechnologicalCardID, SpecificationDate, RawMatPurchaseIndepContractor, RawMatIndepContractor2, 
          RawMatSpeklTraf, RawMatSpeklCyfra, PVHPrintSide, PVHFormat, TechnologistPresence, PersonalizeRequirementsExtended)
        OUTPUT INSERTED.ID INTO @t      
        SELECT [Name], CASE @SaveNumber WHEN 0 THEN @NewNumber ELSE Number END, CASE @SaveDate WHEN 0 THEN GetDate() WHEN 1 THEN CreateDate END, @EmployeeID,
          CardCountInvoice, PrintOrientPCCID, PrintOrientActNumber, CustomerPresence,  DBDateIncome,
          DBWayIncome,  DBDateStore,  SpecificationNumber,
          OfficialNote,  CardDemoSomewhere,  ApprovedSampleOfPersonalization,  ApprovedTestScreenPrinting,
          DemoSample, LayoutsSchemes, SketchFileName,  PrintOrientID, PrintOrientAdvID, 
          ProductionCardCustomizeID,  0/*status*/, TypeID,
          DemoPackPaper, DocTasks, ColorPick, PersonalizationDescription, 
          AdaptingGroupID, RawMatSuppliedByCustomer, RawMatSpekl, RawMatPurchaseByCustomer, RawMatIndepContractor,
          [DBRequirements], [PackingRequirements], [ProductionRequirements], [PersonalizeRequirements],
          RawMatSuppliedByCustomerName, TechnologicalCardID, SpecificationDate, RawMatPurchaseIndepContractor, RawMatIndepContractor2, 
          RawMatSpeklTraf, RawMatSpeklCyfra, PVHPrintSide, PVHFormat, TechnologistPresence, PersonalizeRequirementsExtended
        FROM ProductionCardCustomize
        WHERE ID = @CustomizeID

        SELECT @OutID = ID FROM @t
        -- tech
        -- технологию копировать можно только если небыло От даты создания зл и до даты копирования новой версии. Иначе в хистория клеятся данные из
        -- старой опубликованной версии, хотя сам заказной уже принадлежит новой (по дате создания), в итоге плохие данные в истории версиий взаимосвязей
        IF @SaveDate = 1 --с сохранением даты копируем без проблем.
            SET @InsertProps = 1
        ELSE -- иначе проверяем есть ли более новые версии tree
        BEGIN
            --выберем данные о записи истории. дата публикации и корневой узел.
            SELECT TOP 1 @Root = h.RootProductionCardPropertiesID, @Date = h.StartDate
            FROM ProductionCardPropertiesHistoryDetails d
            INNER JOIN ProductionCardPropertiesHistory h ON h.ID = d.ProductionCardPropertiesHistoryID
            LEFT JOIN ProductionCardCustomizeProperties p ON p.PropHistoryValueID = d.ID 
            WHERE p.ProductionCardCustomizeID = @CustomizeID
            -- проверяем есть ли новые публикации, если нет - копируем.
            IF EXISTS(SELECT ph.ID FROM ProductionCardPropertiesHistory ph WHERE ph.RootProductionCardPropertiesID = @Root AND ph.StartDate > @Date)
                SET @InsertProps = 0
            ELSE
                SET @InsertProps = 1
        END
        IF @InsertProps = 1
            INSERT INTO ProductionCardCustomizeProperties(PropHistoryValueID, ProductionCardCustomizeID, HandMadeValue, HandMadeValueOwnerID, SourceType)
            SELECT PropHistoryValueID, @OutID, HandMadeValue, HandMadeValueOwnerID, SourceType
            FROM ProductionCardCustomizeProperties
            WHERE ProductionCardCustomizeID = @CustomizeID        
        
        -- layouts
        INSERT INTO ProductionCardCustomizeLayout([Date], [Data], [EmployeeID], [ProductionCardCustomizeID], [PictureTypeID], FileName, LinkType)
        SELECT [Date], [Data], [EmployeeID], @OutID, PictureTypeID, FileName, LinkType
        FROM ProductionCardCustomizeLayout
        WHERE ProductionCardCustomizeID = @CustomizeID        
        ORDER BY [Date] DESC
        
        -- release dates
/*        INSERT INTO ProductionCardCustomizeReleaseDates(ReleaseDate, ReleaseCount, ProductionCardCustomizeID)
        SELECT ReleaseDate, ReleaseCount, @OutID
        FROM ProductionCardCustomizeReleaseDates
        WHERE ProductionCardCustomizeID = @CustomizeID */
         
        -- assembly details
        --Если сборка - не копируем привязанные ЗЛ.
        IF EXISTS(SELECT t.ID 
                  FROM ProductionCardCustomize a
                  INNER JOIN ProductionCardTypes t ON t.ProductionCardPropertiesID = a.TypeID
                  WHERE t.ID = 4 AND a.ID = @CustomizeID)
        BEGIN
            INSERT INTO ProductionCardCustomizeDetails(ProductionCardCustomizeID, LinkedProductionCardCustomizeID,
                TmcID, Norma, UnitID)
            SELECT @OutID, LinkedProductionCardCustomizeID,
                TmcID, Norma, UnitID
            FROM ProductionCardCustomizeDetails
            WHERE ProductionCardCustomizeID = @CustomizeID AND LinkedProductionCardCustomizeID IS NULL
        END
        ELSE        
            INSERT INTO ProductionCardCustomizeDetails(ProductionCardCustomizeID, LinkedProductionCardCustomizeID,
                TmcID, Norma, UnitID)
            SELECT @OutID, LinkedProductionCardCustomizeID,
                TmcID, Norma, UnitID
            FROM ProductionCardCustomizeDetails
            WHERE ProductionCardCustomizeID = @CustomizeID
           
        -- doc details
        INSERT INTO ProductionCardCustomizeDocDetails(Number, [Name], [Format], NeedCheck, [ProductionCardCustomizeID])
        SELECT Number, [Name], [Format], NeedCheck, @OutID
        FROM ProductionCardCustomizeDocDetails
        WHERE ProductionCardCustomizeID = @CustomizeID

        -- Instruction
        INSERT INTO ProductionCardCustomizeAssemblyInstructions([AssemblyInstructionHeaderID], [Data],
            [ModifyDate], [ModifyEmployeeID], [ProductionCustomizeID])
        SELECT [AssemblyInstructionHeaderID], [Data],
            [ModifyDate], [ModifyEmployeeID], @OutID
        FROM ProductionCardCustomizeAssemblyInstructions
        WHERE ProductionCustomizeID = @CustomizeID
        
        INSERT INTO ProductionOrdersProdCardCustomize(ProductionOrdersID, ProductionCardCustomizeID, SortOrder)
        SELECT @OrderID, @OutID, ISNULL(MAX(SortOrder), 0) + 1
        FROM ProductionOrdersProdCardCustomize WHERE ProductionOrdersID = @OrderID

        --вставка в историю
        EXEC sp_ProductionCardCustomizeHistory_Insert @EmployeeID, @OutID, 0
        
        SELECT @OutID AS ID
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO