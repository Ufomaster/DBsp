SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   06.12.2013$*/
/*$Modify:     Poliatykin Oleksii$    $Modify date:   01.08.2017$*/
/*$Version:    1.00$   $Decription: выборка допустимых статусов акта*/
CREATE PROCEDURE [QualityControl].[sp_ActsStatuses_Select]
    @StatusID Int
AS
BEGIN
    SELECT
        a.ID,
        a.EditingRightConst,
        a.[Name],
        a.StatusEditingRightConst,
        a.EnableMassSigning
    FROM QualityControl.ActStatuses a
    INNER JOIN QualityControl.ActTemplatesProcessMap pm ON (a.ID = pm.GoStatusID OR a.ID = pm.StatusID)
    WHERE 
        ( (pm.StatusID = @StatusID AND @StatusID <> -1)
          OR 
          (@StatusID = -1 AND a.IsFirst = 1) /*Первый Status (при созданиии НУЛЛ)*/
          OR 
          (@StatusID <> -1 AND a.ID = @StatusID) /*Собственный Статус, на редактирование, не зависимо от процесса*/
        )
    GROUP BY a.ID, a.EditingRightConst, a.[Name], a.StatusEditingRightConst, a.EnableMassSigning
END
GO