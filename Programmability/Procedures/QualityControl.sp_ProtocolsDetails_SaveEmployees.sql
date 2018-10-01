SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   25.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   19.12.2013$*/
/*$Version:    1.00$   $Description: Сохранение подписантов протокола из временной таблицы$*/
CREATE PROCEDURE [QualityControl].[sp_ProtocolsDetails_SaveEmployees]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM QualityControl.ProtocolsSigners d
        LEFT JOIN #ProtocolsSigners t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.ProtocolID = @ID

        /*изменим изменённые*/
        UPDATE td
        SET td.EmailOnly = t.EmailOnly,
            td.EmployeeID = t.EmployeeID
        FROM QualityControl.ProtocolsSigners td
        INNER JOIN #ProtocolsSigners t ON t._ID = td.ID
        WHERE td.ProtocolID = @ID

        /*Добавим добавленные*/
        INSERT INTO QualityControl.ProtocolsSigners(EmailOnly, EmployeeID, ProtocolID)
        SELECT t.EmailOnly, t.EmployeeID, @ID
        FROM #ProtocolsSigners t
        LEFT JOIN QualityControl.ProtocolsSigners td ON td.ID = t._ID AND td.ProtocolID = @ID
        WHERE td.ID IS NULL
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO