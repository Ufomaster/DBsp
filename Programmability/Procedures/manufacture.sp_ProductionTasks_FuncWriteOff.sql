SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   01.03.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   22.08.2016$*/
/*$Version:    1.00$   $Decription: Запуск функции списать $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncWriteOff]
    @PCCID int,
    @TMCID int,
    @Amount decimal(38, 10),
    @DocID int, 
    @SectorID int, 
    @StatusID int,
    @ProdTaskID int,
    @EmployeeID int,
    @PCCFromID int,
    @Comments varchar(8000)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @AmountMinus decimal(38,10)
    DECLARE @t TABLE(ID int)
    
    SELECT @PCCID = CASE WHEN @PCCID = 0 THEN NULL ELSE @PCCID END, 
           @AmountMinus = -@Amount
           
    SET XACT_ABORT ON;    
    BEGIN TRAN
    BEGIN TRY
        IF @DocID = 0
        BEGIN
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID], StorageStructureSectorID, [ProductionTasksOperTypeID])
            OUTPUT INSERTED.ID INTO @t
            SELECT @ProdTaskID, @EmployeeID, 
                @SectorID, 5/*списание*/
            SELECT @DocID = ID FROM @t
        END

        DELETE FROM @t
        
/*        DECLARE @OldPCCID int
        SELECT @OldPCCID = s.ProductionCardCustomizeID
        FROM manufacture.ProductionStorage s 
        WHERE s.TMCID = @TMCID AND s.ProductionTasksStatusID = @StatusID 
            AND s.StorageStructureSectorID = @SectorID 
            AND (s.ProductionCardCustomizeID = @PCCID OR s.ProductionCardCustomizeID IS NULL)
            AND s.isMajorTMC = 0
*/
        /*Next Step - Insert Position*/
        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
            StatusID, ProductionTasksDocsID, StatusFromID, ProductionCardCustomizeFromID, Comments)
        OUTPUT INSERTED.ID INTO @t
        SELECT @TMCID, @PCCID, @Amount, t.[Name], 1, 
            2, @DocID, @StatusID, @PCCFromID, @Comments
        FROM Tmc t
        WHERE t.ID = @TMCID
        
        --EXEC manufacture.sp_ProductionStorage_TMCID_Recalc @TMCID, @AmountMinus, @OldPCCID, @SectorID, @StatusID, 0
        --EXEC manufacture.sp_ProductionStorage_TMCID_Recalc @TMCID, @Amount,      @PCCID, @SectorID, 2, 0

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