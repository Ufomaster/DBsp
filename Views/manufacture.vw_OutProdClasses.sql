SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Skliar Nataliia$    $Create date:   03.04.2017$*/
/*$Modify:     Skliar Nataliia$    $Modify date:   03.04.2017$*/
/*$Version:    1.00$   $Description:$*/

create VIEW [manufacture].[vw_OutProdClasses]

AS
    SELECT 0 AS ID, 'Входящая ГП с передающего участка' AS Name
    UNION ALL
    SELECT 1, 'Создание пакета из ТЛ'
    UNION ALL
    SELECT 2, 'Автопоиск ГП из ЗЛ'
    UNION ALL
    SELECT 3, 'Создание тиражных листов'
    UNION ALL
    SELECT 4, 'Вырубка карт'
GO