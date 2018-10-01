SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   13.01.2011$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   24.12.2012$*/
/*$Version:    1.00$   $Description: Публикация дерева$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_DeleteHistory]
    @ID Int
AS
BEGIN
    ALTER INDEX [IDX_ProductionCardPropertiesHistoryDetails_ObjectTypeID]
      ON [dbo].[ProductionCardPropertiesHistoryDetails]
    DISABLE
        
    ALTER INDEX [IDX_ProductionCardPropertiesHistoryDetails_ParentID]
      ON [dbo].[ProductionCardPropertiesHistoryDetails]
    DISABLE
          
    ALTER INDEX [IDX_ProductionCardPropertiesHistoryDetails_ProductionCardPropertiesHistoryID]
      ON [dbo].[ProductionCardPropertiesHistoryDetails]
    DISABLE
        
    SET NOCOUNT ON
    DECLARE @Err Int    
       
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        DELETE FROM ProductionCardPropertiesHistoryDetails
        WHERE ProductionCardPropertiesHistoryID = @ID
        
        DELETE FROM ProductionCardPropertiesHistory
        WHERE ID = @ID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
    
    ALTER INDEX [IDX_ProductionCardPropertiesHistoryDetails_ObjectTypeID]
      ON [dbo].[ProductionCardPropertiesHistoryDetails]
    REBUILD
        
    ALTER INDEX [IDX_ProductionCardPropertiesHistoryDetails_ParentID]
      ON [dbo].[ProductionCardPropertiesHistoryDetails]
    REBUILD
          
    ALTER INDEX [IDX_ProductionCardPropertiesHistoryDetails_ProductionCardPropertiesHistoryID]
      ON [dbo].[ProductionCardPropertiesHistoryDetails]
    REBUILD
END
GO