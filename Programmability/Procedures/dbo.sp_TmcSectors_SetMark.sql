SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   18.04.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   18.04.2017$*/
/*$Version:    1.00$   $Decription: Установка пометки - инсерт апдейт участка в группу тмц $*/
create PROCEDURE [dbo].[sp_TmcSectors_SetMark]
    @ArrayOfID varchar(8000),
    @Type tinyint,
    @TmcID int
AS
BEGIN
    IF @TmcID IS NULL 
        RETURN;
    IF NOT EXISTS(SELECT ID FROM TMCAttributes a WHERE a.TMCID = @TmcID AND a.AttributeID = 13)
        RETURN;
    IF @Type = 1 
    BEGIN
        INSERT INTO dbo.TMCSectors (TmcID, SectorID)
        SELECT @TmcID, a.ID
        FROM dbo.fn_StringToITable(@ArrayOfID) a
        LEFT JOIN TmcSectors s ON s.TMCID = @TMCID AND s.SectorID = a.ID
        WHERE a.ID <> -1 AND s.ID IS NULL
        
        IF EXISTS(SELECT * FROM dbo.fn_StringToITable(@ArrayOfID) WHERE ID = -1)
        BEGIN
            INSERT INTO dbo.TMCSectors (TMCID, SectorID)
            SELECT @TMCID, ss.ID
            FROM manufacture.StorageStructureSectors ss
            LEFT JOIN TMCSectors s ON s.TMCID = @TMCID AND ss.ID = s.SectorID
            WHERE ISNULL(ss.IsCS, 0) = 1 AND ISNULL(ss.IsDeleted, 0) = 0 AND s.ID IS NULL
        END
    END
    ELSE
    IF @Type = 0
    BEGIN
        DELETE o 
        FROM dbo.TMCSectors o
        INNER JOIN dbo.fn_StringToITable(@ArrayOfID) a ON a.ID <> -1 AND a.ID = o.SectorID
        WHERE o.TMCID = @TMCID
        
        IF EXISTS(SELECT * FROM dbo.fn_StringToITable(@ArrayOfID) WHERE ID = -1)
        BEGIN
            DELETE o 
            FROM dbo.TMCSectors o
            INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = o.SectorID
            WHERE o.TMCID = @TMCID AND ISNULL(ss.IsCS, 0) = 1 AND ISNULL(ss.IsDeleted, 0) = 0
        END
    END    
END
GO