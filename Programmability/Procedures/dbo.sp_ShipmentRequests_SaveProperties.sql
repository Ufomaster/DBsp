SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   03.12.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   01.02.2016$*/
/*$Version:    1.00$   $Description: Сохранение свойств из временной таблицы$*/
CREATE PROCEDURE [dbo].[sp_ShipmentRequests_SaveProperties]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM ShipmentRequestsDetails d
        LEFT JOIN #ShipmentRequestsDetails t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.ShipmentRequestID = @ID

        /*изменим изменённые*/
        UPDATE td
        SET td.Amount = t.Amount,
            td.Comments = t.Comments,
            td.Height = t.Height,
            td.Length = t.Length,
            td.[Name] = t.[Name],
            td.PackCount = t.PackCount,
            td.PackTypeID = t.PackTypeID,
            td.PCCID = t.PCCID,
            td.UnitID = t.UnitID,
            td.[Weight] = t.[Weight],
            td.Width = t.Width,
            td.TZ = t.TZ,
            td.TMCID = t.TMCID
        FROM ShipmentRequestsDetails td
        INNER JOIN #ShipmentRequestsDetails t ON t._ID = td.ID
        WHERE td.ShipmentRequestID = @ID

        /*Добавим добавленные*/
        INSERT INTO ShipmentRequestsDetails(Amount, Comments, Height, Length, [Name], PackCount, 
            PackTypeID, PCCID, UnitID, [Weight], Width, ShipmentRequestID, TZ, TMCID)
        SELECT t.Amount, t.Comments, t.Height, t.Length, t.[Name], t.PackCount, 
            t.PackTypeID, t.PCCID, t.UnitID, t.[Weight], t.Width, @ID, t.TZ, t.TMCID
        FROM #ShipmentRequestsDetails t
        LEFT JOIN ShipmentRequestsDetails td ON td.ID = t._ID AND td.ShipmentRequestID = @ID
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