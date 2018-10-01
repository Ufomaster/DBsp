SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   01.08.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   11.04.2017$*/
/*$Version:    1.00$   $Decription: Выбор секторов для сменных заданий$*/
CREATE PROCEDURE [manufacture].[sp_StorageStructureSectors_Select]
    @UserID int
AS
BEGIN
    SET NOCOUNT ON
	
    SELECT sss.*
    FROM manufacture.StorageStructureSectors sss
         INNER JOIN dbo.UserSectors us on us.SectorID = sss.ID
    WHERE us.UserID = @UserID AND ISNULL(sss.IsDeleted, 0) = 0
    ORDER BY sss.[SortOrder]
END
GO