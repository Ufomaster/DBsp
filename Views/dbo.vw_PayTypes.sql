SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   23.05.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   23.05.2012$*/
/*$Version:    1.00$   $Description: Вьюшка типов платежей*/
CREATE VIEW [dbo].[vw_PayTypes]
AS
    SELECT 0 AS ID, CAST('Наличный' AS Varchar(15)) AS [Name]
    UNION ALL
    SELECT 1, 'Безналичный'
GO