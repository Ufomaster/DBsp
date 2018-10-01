SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   21.02.2012$
--$Modify:     Zapadinskiy Anatoliy$    $Modify date:   21.02.2012$
--$Version:    1.00$   $Description: Выдача/возврат документа$
create PROCEDURE [unknown].[sp_Storage_ChangeStatus]
   @BarCode varchar(25),
   @TypeID tinyint,
   @StatusID tinyint
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE @DocumnetID int, @Err Int
    
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY            
        IF @TypeID = 0
        BEGIN             
            SELECT top 1 @DocumnetID = ID 
            FROM StorageDoc
            WHERE Number = @BarCode
        END
        ELSE
        BEGIN
            SELECT top 1 @DocumnetID = ID 
            FROM StorageDoc
            WHERE CustomerNumber = @BarCode    
        END
        
        IF @DocumnetID > 0
        BEGIN 
            IF EXISTS (SELECT * FROM StorageDoc WHERE ID = @DocumnetID AND StatusID = @StatusID)
                RAISERROR('Данный документ уже выдан/возвращен', 16, 1) 
                
            UPDATE StorageDoc 
            SET StatusID = @StatusID
            WHERE ID = @DocumnetID
        END   
        ELSE
            RAISERROR('Не существует указанного документа', 16, 1) 
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO