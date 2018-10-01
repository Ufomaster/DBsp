SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Poliatykin Oleksii$    $Create date:   29.12.2017$*/
/*$Modify:     Poliatykin Oleksiik$   $Modify date:   02.01.2018$*/
/*$Version:    1.00$   $Decription: Пересоздает группу тмц если изменился состав рабочих мест в группе$*/
create PROCEDURE [dbo].[sp_ObjectTypes_TMC_SectorsLink_Fix]
AS
BEGIN
    DECLARE @ObjectTypeID INT
    DECLARE Cur_col CURSOR STATIC LOCAL FOR SELECT ots.ObjectTypeID
                                            FROM (SELECT ots.ObjectTypeID        
                                                  FROM ObjectTypesSectors ots
                                                  JOIN manufacture.StorageStructureSectors sss ON sss.ID = ots.SectorID
                                                  WHERE ISNULL(sss.IsCS, 0) = 1
                                                  GROUP BY ots.ObjectTypeID
                                                 ) a        
                                            INNER JOIN ObjectTypesSectors ots ON ots.ObjectTypeID = a.ObjectTypeID
                                            GROUP BY ots.ObjectTypeID
                                            HAVING COUNT(ots.ObjectTypeID) <> (
                                                SELECT
                                                    COUNT(*) AS c
                                                FROM manufacture.StorageStructureSectors
                                                WHERE ISNULL(IsCS, 0) = 1)
    OPEN Cur_col
    FETCH NEXT FROM Cur_col INTO @ObjectTypeID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DELETE FROM ObjectTypesSectors WHERE ObjectTypeID = @ObjectTypeID        
        EXEC sp_ObjectTypeSectors_SetMark '-1', 1, @ObjectTypeID
        FETCH NEXT FROM Cur_col INTO @ObjectTypeID
    END
    CLOSE Cur_col
    DEALLOCATE Cur_col
END
GO