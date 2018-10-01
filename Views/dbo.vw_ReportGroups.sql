SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   13.05.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   13.05.2011$
--$Version:    1.00$   $Description: $
CREATE VIEW [dbo].[vw_ReportGroups] AS
    SELECT 
        ID, 
        ParentID, 
        [Name]
    FROM ReportGroups
GO