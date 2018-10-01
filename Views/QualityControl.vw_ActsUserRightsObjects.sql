SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   04.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   04.12.2013$*/
/*$Version:    1.00$   $Description:$*/
create VIEW [QualityControl].[vw_ActsUserRightsObjects]
AS
    SELECT
        vals.ParentID,
        Vals.ID,
        Parent.[Name] AS ParentName,
        Vals.[Name],
        Vals.DelphiConst,
        Vals.Comment
    FROM UserRightsObjects Vals
    LEFT JOIN UserRightsObjects Parent ON Parent.ID = Vals.ParentID
    WHERE Vals.DelphiConst IS NOT NULL AND (Parent.ID = 339 OR Parent.ID = 341)
GO