SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	 $Create date:   02.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   02.03.2011$
--$Version:    1.00$   $Description: Вьюшка ссо справочниками
CREATE VIEW [dbo].[vw_Dictionaries]
AS
    SELECT
        t.ID,
        t.[Description],
        t.FilteringTables,
        t.MainField,
        t.[Name],
        t.VisibleFields
    FROM dbo.Tables t
GO