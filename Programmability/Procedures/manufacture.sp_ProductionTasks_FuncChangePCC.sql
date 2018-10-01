SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   29.11.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   13.01.2017$*/
/*$Version:    1.00$   $Decription: Запуск функции переброс зл у готовой продукции на другой $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncChangePCC]
    @PCCID int,
    @PCCFromID int,
    @TMCID int, 
    @Amount decimal(38,10),
    @SectorID int, 
    @StatusID int,
    @ProdTaskID int,
    @EmployeeID int
AS
BEGIN
    DECLARE @Err Int, @DocID int
    DECLARE @t TABLE(ID int)           
/*    IF EXISTS(SELECT ID 
              FROM manufacture.ProductionStorage  
              WHERE TMCID = @TMCID AND StorageStructureSectorID = @SectorID
              AND ProductionTasksStatusID = @StatusID AND ProductionCardCustomizeID = @PCCID AND Amount < @Amount)
        RAISERROR('Количество превышает допустимое ', 16, 1)*/

    SET XACT_ABORT ON;    
    BEGIN TRAN
    BEGIN TRY    
        INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
            StorageStructureSectorID, ProductionTasksOperTypeID, EmployeeToID)
        OUTPUT INSERTED.ID INTO @t
        SELECT @ProdTaskID, @EmployeeID, @SectorID, 9/*смена ЗЛ*/, @EmployeeID
        SELECT @DocID = ID FROM @t
        
        DELETE FROM @t
        
        /*Next Step - Insert Position*/

        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
            StatusID, ProductionTasksDocsID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
        OUTPUT INSERTED.ID INTO @t
        SELECT pc.TmcID, @PCCID, @Amount, t.[Name], 1,
            @StatusID, @DocID, 1, @StatusID, @PCCFromID
--        FROM Tmc t
--        WHERE t.ID = @TMCID
        FROM ProductionCardCustomize pc
        INNER JOIN Tmc t ON t.ID = pc.TmcID
        WHERE pc.ID = @PCCID
        
        UNION ALL
        
        SELECT @TMCID, @PCCFromID, @Amount, t.[Name], -1,
            @StatusID, @DocID, 1, @StatusID, @PCCFromID
        FROM Tmc t
        WHERE t.ID = @TMCID
 
        SELECT @DocID, ID FROM @t
        COMMIT TRAN      
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH  
END
GO