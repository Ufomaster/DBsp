SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   13.04.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   18.04.2017$*/
/*$Version:    1.00$   $Decription: Установка пометки - инсерт апдейт участка в группу тмц $*/
CREATE PROCEDURE [dbo].[sp_ObjectTypeSectors_SetMark]
    @ArrayOfID varchar(8000),
    @Type tinyint,
    @ObjectTypeID int
AS
BEGIN
    IF NOT EXISTS(SELECT ID FROM ObjectTypesAttributes a WHERE a.ObjectTypeID = @ObjectTypeID AND a.AttributeID = 13)
        RETURN;
    IF @Type = 1 
    BEGIN
        INSERT INTO dbo.ObjectTypesSectors (ObjectTypeID, SectorID)
        SELECT @ObjectTypeID, a.ID
        FROM dbo.fn_StringToITable(@ArrayOfID) a
        LEFT JOIN ObjectTypesSectors s ON s.ObjectTypeID = @ObjectTypeID AND s.SectorID = a.ID
        WHERE a.ID <> -1 AND s.ID IS NULL
        
        IF EXISTS(SELECT * FROM dbo.fn_StringToITable(@ArrayOfID) WHERE ID = -1)
        BEGIN
            INSERT INTO dbo.ObjectTypesSectors (ObjectTypeID, SectorID)
            SELECT @ObjectTypeID, ss.ID
            FROM manufacture.StorageStructureSectors ss
            LEFT JOIN ObjectTypesSectors s ON s.ObjectTypeID = @ObjectTypeID AND ss.ID = s.SectorID
            WHERE ISNULL(ss.IsCS, 0) = 1 AND ISNULL(ss.IsDeleted, 0) = 0 AND s.ID IS NULL
        END
    END
    ELSE
    IF @Type = 0
    BEGIN
        DELETE o 
        FROM dbo.ObjectTypesSectors o
        INNER JOIN dbo.fn_StringToITable(@ArrayOfID) a ON a.ID <> -1 AND a.ID = o.SectorID
        WHERE o.ObjectTypeID = @ObjectTypeID
        
        IF EXISTS(SELECT * FROM dbo.fn_StringToITable(@ArrayOfID) WHERE ID = -1)
        BEGIN
            DELETE o 
            FROM dbo.ObjectTypesSectors o
            INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = o.SectorID
            WHERE o.ObjectTypeID = @ObjectTypeID AND ISNULL(ss.IsCS, 0) = 1 AND ISNULL(ss.IsDeleted, 0) = 0
        END
    END    
END
GO