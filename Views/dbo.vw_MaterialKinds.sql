SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   08.08.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   08.08.2012$*/
/*$Version:    1.00$   $Description: Вьюшка с видами материалов$*/
CREATE VIEW [dbo].[vw_MaterialKinds]
AS
    SELECT 0 AS ID, CAST('Матеріал' AS Varchar(50)) AS [Name]
    UNION ALL
    SELECT 1, 'Напівфабрикат'
    UNION ALL
    SELECT 2, 'Прийняті до переробки'
GO