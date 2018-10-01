SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   03.03.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   20.12.2016$*/
/*$Version:    1.00$   $Decription: Запуск функции отбраковать $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncFail]
    @PCCID int, 
    @TMCID int, 
    @Amount decimal(38,10),
    @DocID int, 
    @SectorID int, 
    @StatusID int,    
    @ProdTaskID int,
    @EmployeeID int,
    @isMajorTMC bit,
    @Comments varchar(8000),
    @PCCFromID int,
    @JobStageID int = NULL,
    @FailTypeID int = NULL
AS
BEGIN
    DECLARE @Err Int, @AmountMinus decimal(38,10)
    DECLARE @t TABLE(ID int)

    SELECT @PCCID = CASE WHEN @PCCID = 0 THEN NULL ELSE @PCCID END, 
           @AmountMinus = -@Amount
           
/*    IF EXISTS(SELECT ID 
              FROM manufacture.ProductionStorage  
              WHERE TMCID = @TMCID AND StorageStructureSectorID = @SectorID
              AND ProductionTasksStatusID = @StatusID AND ProductionCardCustomizeID = @PCCID AND Amount < @Amount)
        RAISERROR('Количество превышает допустимое ', 16, 1)*/
    
    SET XACT_ABORT ON;    
    BEGIN TRAN
    BEGIN TRY    
        IF @DocID = 0 
        BEGIN
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID],
                StorageStructureSectorID, ProductionTasksOperTypeID)
            OUTPUT INSERTED.ID INTO @t
            SELECT @ProdTaskID, @EmployeeID, @SectorID, 6/*Брак*/
            SELECT @DocID = ID FROM @t
        END
        
        DELETE FROM @t
        
        /*Next Step - Insert Position*/

        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
            StatusID, ProductionTasksDocsID, isMajorTMC, StatusFromID, Comments, ProductionCardCustomizeFromID,
            FailTypeID)
        OUTPUT INSERTED.ID INTO @t
        SELECT @TMCID, @PCCID, @Amount, t.[Name], 1,
            3, @DocID, @isMajorTMC, @StatusID, @Comments, @PCCFromID, @FailTypeID
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