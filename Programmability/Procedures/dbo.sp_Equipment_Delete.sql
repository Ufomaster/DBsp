SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   08.08.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   08.08.2011$
--$Version:    1.00$   $Decription: Удаление ОС$
CREATE PROCEDURE [dbo].[sp_Equipment_Delete]
    @EmployeeID Int, 
    @EquipmentID Int, 
    @OpType Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int    
    SET XACT_ABORT ON
    
    IF EXISTS(SELECT * FROM dbo.Requests r WHERE r.EquipmentID = @EquipmentID)
        RAISERROR ('Удаление основного средства запрещено, так как оно используется в заявках', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM dbo.SolutionEquipment se WHERE se.EquipmentID = @EquipmentID)
        RAISERROR ('Удаление основного средства запрещено, так как по нему существуют работы', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM dbo.SolutionsPlanned sp WHERE sp.EquipmentID = @EquipmentID)
        RAISERROR ('Удаление основного средства запрещено, так как по нему существуют плановые работы', 16, 1)
    
    BEGIN TRAN
    BEGIN TRY
        --        'DELETE FROM EmployeeEquipment WHERE EquipmentID = ' + IntToStr(FBN['ID']) + ' ' +
        
        EXEC sp_EquipmentHistory_Insert @EmployeeID, @EquipmentID, @OpType
        
        DELETE FROM EquipmentMove WHERE EquipmentID = @EquipmentID
        
        DELETE FROM Equipment WHERE ID = @EquipmentID
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        DELETE eh FROM EquipmentHistory eh 
        WHERE eh.EquipmentID = @EquipmentID AND eh.OperationType = 2
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO