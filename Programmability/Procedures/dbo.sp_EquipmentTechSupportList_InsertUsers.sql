SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   09.12.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   09.12.2011$
--$Version:    1.00$   $Decription: Удаление ОС из списка контроля$
CREATE PROCEDURE [dbo].[sp_EquipmentTechSupportList_InsertUsers]
    @EquipmentID Int,
    @ArrayOfID Varchar(MAX)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int    
    SET XACT_ABORT ON

    BEGIN TRAN
    BEGIN TRY
        INSERT INTO EquipmentEmployee(EquipmentID, EmployeeID)
        SELECT @EquipmentID, a.ID
        FROM dbo.fn_StringToITable(@ArrayOfID) a 
        LEFT JOIN EquipmentEmployee ee ON ee.EmployeeID = a.ID AND ee.EquipmentID = @EquipmentID
        WHERE ee.EmployeeID IS NULL 

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO