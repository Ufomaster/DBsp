SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   19.11.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   19.11.2013$*/
/*$Version:    1.00$   $Decription: выборка допустимых статусов протокола*/
create PROCEDURE [QualityControl].[sp_ProtocolsStatuses_Select]
    @StatusID Int
AS
BEGIN
    SELECT
        a.ID,
        a.EditingRightConst,
        a.[Name],
        a.StatusEditingRightConst/*,
        a.CanEditDetails,
        a.CanEditTech*/
    FROM QualityControl.TypesStatuses a
    INNER JOIN QualityControl.TypesProcessMap pm ON (a.ID = pm.GoStatusID OR a.ID = pm.StatusID)
    WHERE 
        ( (pm.StatusID = @StatusID AND @StatusID <> -1)
          OR 
          (@StatusID = -1 AND a.IsFirst = 1) /*Первый Status (при созданиии НУЛЛ)*/
          OR 
          (@StatusID <> -1 AND a.ID = @StatusID) /*Собственный Статус, на редактирование, не зависимо от процесса*/
        )
    GROUP BY a.ID, a.EditingRightConst, a.[Name], a.StatusEditingRightConst/*, a.CanEditDetails, a.CanEditTech*/
END
GO