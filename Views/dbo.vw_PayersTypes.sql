SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   05.12.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   10.12.2015$*/
/*$Version:    1.00$   $Description: Вьюшка типов плательщиков*/
create VIEW [dbo].[vw_PayersTypes]
AS
    SELECT 0 AS ID, CAST('Отправитель' AS Varchar(15)) AS [Name]
    UNION ALL
    SELECT 1, 'Получатель'
    UNION ALL
    SELECT 2, 'Контрагент'
GO