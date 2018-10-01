SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   13.10.2014$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   13.10.2014$*/
/*$Version:    1.00$   $Description: Удаление характеристики группы$*/
create PROCEDURE [QualityControl].[sp_ObjectTypeProps_Delete]
    @ID int  
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int
    
    DECLARE @ObjectTypeID Int, @Order Int
    
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT
            @Order = p.SortOrder,
            @ObjectTypeID = p.ObjectTypeID
        FROM QualityControl.ObjectTypeProps p
        WHERE p.ID = @ID

        DELETE 
        FROM QualityControl.ObjectTypeProps 
        WHERE ID = @ID

        UPDATE QualityControl.ObjectTypeProps
        SET SortOrder = SortOrder - 1
        WHERE ObjectTypeID = @ObjectTypeID AND SortOrder > @Order
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO