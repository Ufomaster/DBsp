SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [manufacture].[vw_1CTechCards]
AS
    SELECT tc.ID, p.Name AS [ParentName], tc.Name
    FROM manufacture.TechnologicalCards tc 
    LEFT JOIN manufacture.TechnologicalCards p ON p.ID = tc.ParentID AND p.IsDeleted = 0
    WHERE tc.IsFolder = 0 AND tc.IsDeleted = 0 AND tc.StateID = 2
GO