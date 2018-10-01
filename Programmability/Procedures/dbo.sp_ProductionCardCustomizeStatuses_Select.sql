SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   22.03.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.01.2017$*/
/*$Version:    1.00$   $Decription: выборка допустимых статусов ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeStatuses_Select]
    @StatusID Int,
    @Type Int
AS
BEGIN
    SELECT
        a.ID,
        a.EditingRightConst,
        a.[Name],
        a.StatusEditingRightConst,
        a.CanEditDetails,
        a.CanEditTech,
        a.CanEditReleaseDates
    FROM ProductionCardStatuses a
    INNER JOIN ProductionCardProcessMap pm ON (a.ID = pm.GoStatusID OR a.ID = pm.StatusID)
    INNER JOIN ProductionCardTypes pct ON pct.ID = pm.[Type] AND pct.ID = @Type
    WHERE 
        ( (pm.StatusID = @StatusID AND @StatusID <> -1 AND a.isReplaceStatus = 0) --not first and not end Status
          OR 
          (@StatusID = -1 AND a.ID = pct.StartStatusID) --Первый Status (при созданиии НУЛЛ)
          OR 
          (@StatusID <> -1 AND a.ID = @StatusID) --Собственный Статус, на редактирование, не зависимо от процесса
        )
    GROUP BY a.ID, a.EditingRightConst, a.[Name], a.StatusEditingRightConst, a.CanEditDetails, a.CanEditTech, a.CanEditReleaseDates
END
GO