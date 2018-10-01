SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   19.11.2013$*/
/*$Version:    1.00$   $Description: Сохранение подписчиков типа протокола из временной таблицы$*/
CREATE PROCEDURE [QualityControl].[sp_Types_SaveEmployees]
    @TypeID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE td
        FROM QualityControl.TypesSigners td
        LEFT JOIN #TypesSigners t ON td.ID = t._ID
        WHERE t.ID IS NULL AND td.TypesID = @TypeID

        /*изменим изменённые*/
        UPDATE td
        SET td.DepartmentPositionID = t.DepartmentPositionID,
            td.EmailOnly = t.EmailOnly
        FROM QualityControl.TypesSigners td
        INNER JOIN #TypesSigners t ON t._ID = td.ID
        WHERE td.TypesID = @TypeID

        /*Добавим добавленные*/
        INSERT INTO QualityControl.TypesSigners(DepartmentPositionID, EmailOnly, TypesID)
        SELECT t.DepartmentPositionID, t.EmailOnly, @TypeID
        FROM #TypesSigners t
        LEFT JOIN QualityControl.TypesSigners td ON td.ID = t._ID AND td.TypesID = @TypeID
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