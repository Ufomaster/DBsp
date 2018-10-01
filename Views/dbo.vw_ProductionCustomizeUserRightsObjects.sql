SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   16.05.2012$
--$Modify:     Oleynik Yuriy$    $Modify date:   16.05.2012$
--$Version:    1.00$   $Description:$
CREATE VIEW [dbo].[vw_ProductionCustomizeUserRightsObjects]
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
    WHERE Vals.DelphiConst IS NOT NULL AND (Parent.ID = 210 OR Parent.ID = 211)
GO