SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   09.08.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   09.08.2016$*/
/*$Version:    1.00$   $Decription: Запуск функции отката первода в брак $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncReturnFail]
    @PCCID int, 
    @TMCID int, 
    @Amount decimal(38,10),
    @DocID int, 
    @SectorID int, 
    @StatusID int,    
    @ProdTaskID int,
    @EmployeeID int,
    @isMajorTMC bit,
    @Comments varchar(8000)
AS
BEGIN
    DECLARE @Err Int, @AmountMinus decimal(38,10)
    DECLARE @t TABLE(ID int)

    SELECT @PCCID = CASE WHEN @PCCID = 0 THEN NULL ELSE @PCCID END, 
           @AmountMinus = -@Amount
    
    SET XACT_ABORT ON;    
    BEGIN TRAN
    BEGIN TRY    
        IF @DocID = 0 
        BEGIN
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
                StorageStructureSectorID, ProductionTasksOperTypeID)
            OUTPUT INSERTED.ID INTO @t
            SELECT @ProdTaskID, @EmployeeID, @SectorID, 8/*возврат из Брак*/
            SELECT @DocID = ID FROM @t
        END

        DELETE FROM @t

        /*Next Step - Insert Position*/

        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
            StatusID, ProductionTasksDocsID, isMajorTMC, StatusFromID, Comments, ProductionCardCustomizeFromID)
        OUTPUT INSERTED.ID INTO @t
        SELECT @TMCID, @PCCID, @Amount, t.[Name], 1,
            @StatusID, @DocID, @isMajorTMC, 3, @Comments, @PCCID
        FROM Tmc t
        WHERE t.ID = @TMCID
  
/*        EXEC manufacture.sp_ProductionStorage_TMCID_Recalc @TMCID, @AmountMinus, @PCCID, @SectorID, @StatusID, @isMajorTMC
        EXEC manufacture.sp_ProductionStorage_TMCID_Recalc @TMCID, @Amount,      @PCCID, @SectorID, 3, @isMajorTMC

        */
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