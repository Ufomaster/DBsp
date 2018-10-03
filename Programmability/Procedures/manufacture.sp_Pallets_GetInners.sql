SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   03.10.2018$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.10.2018$*/
/*$Version:    1.00$   $Description: заполнение таблицы для работы в JobMobile$*/
create PROCEDURE [manufacture].[sp_Pallets_GetInners]
    @JobStageID int,
    @PalleteValue varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Query varchar (8000)

    SELECT @Query = 'INSERT INTO #Palletes(ID, Status, BoxValue)
    SELECT d.ID, d.Status, t.Value AS BoxValue
    FROM StorageData.PalletsDetails_' + CAST(@JobStageID AS varchar) + ' d
    INNER JOIN StorageData.Pallets_' + CAST(@JobStageID AS varchar) + ' p ON p.ID = d.PalletID AND p.Value = ''' + @PalleteValue + '''
    INNER JOIN StorageData.pTMC_' + CAST(js.TmcID AS varchar) + ' t ON t.ID = d.BoxID'
    FROM manufacture.JobStageChecks js
    INNER JOIN manufacture.JobStages j ON j.ID = js.JobStageID AND j.ID = @JobStageID
    WHERE js.isDeleted = 0 AND js.SortOrder = 1

    EXEC( @Query)
END;
GO