SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   29.02.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   12.05.2017$*/
/*$Version:    1.00$   $Decription: Запуск функции добавить $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncNew]
    @ProdTaskID int,
    @SectorID int, 
    @EmployeeID int,
    @isBreakThrought bit = 0, --определяет происходит ли приход ГП в разрез процесса.
    @NewStatsID tinyint = 0 --будущий статус входящей ГП
AS
BEGIN
    --#NewMaterials(ID, Name, UnitName, Amount, Number)
    DECLARE @Err Int, @DocID int, @OutProdClass int
    DECLARE @t TABLE(ID int)
    DECLARE @PCC TABLE(ID int, Number varchar(20))    
    IF NOT EXISTS(SELECT ID FROM #NewMaterials a WHERE a.Amount > 0)
        RETURN

    SELECT @OutProdClass = st.OutProdClass 
    FROM manufacture.ProductionTasksStatuses st
    WHERE st.ID = @NewStatsID
    
    INSERT INTO @PCC(ID, Number)
    SELECT pc.ID, a.Number
    FROM #NewMaterials a
    INNER JOIN ProductionCardCustomize pc ON pc.Number = a.Number AND pc.StatusID NOT IN (6,10,11)
    WHERE a.Amount > 0
    GROUP BY pc.ID, a.Number
    
    SET XACT_ABORT ON;    
    BEGIN TRAN
    BEGIN TRY
        /*Step - Insert Header*/
        INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID], [StorageStructureSectorID], [ProductionTasksOperTypeID])
        OUTPUT INSERTED.ID INTO @t
        SELECT @ProdTaskID, @EmployeeID, @SectorID, 1/*приход*/
        SELECT @DocID = ID FROM @t
        
        /*Next Step - Insert Position*/
        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
            isMajorTMC, 
            StatusID, 
            ProductionTasksDocsID, StatusFromID, ProductionCardCustomizeFromID)
        SELECT a.ID, p.ID, a.Amount, a.Name, 1, 
            CASE WHEN @isBreakThrought = 1 AND @OutProdClass <> 3 THEN 1 ELSE 0 END, 
            CASE WHEN @isBreakThrought = 1 THEN @NewStatsID ELSE 1 END,
            @DocID, CASE WHEN @isBreakThrought = 1 THEN @NewStatsID ELSE 1 END, p.ID
        FROM #NewMaterials a
        LEFT JOIN @PCC p ON p.Number = a.Number
        WHERE a.Amount > 0
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH      
END
GO