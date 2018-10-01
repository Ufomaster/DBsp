SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadisnkiy Anatoliy$	$Create date:   19.04.2012$*/
/*$Modify:     Oleynik Yuriy$   $Modify date:   07.08.2015$*/
/*$Version:    1.00$   $Description: Вьюшка типов сырья/производства*/
CREATE VIEW [dbo].[vw_ProductionPropertiesSourceType]
AS
    SELECT CAST(1 AS Int) AS ID, CAST('Давальницька сировина' AS Varchar(30)) AS [Name], CAST(0 AS Bit) AS IsDefault
	UNION ALL
    SELECT 2, 'Підрядник 1', 0
	UNION ALL
    SELECT 3, 'Закупівля у клієнта', 0
	UNION ALL
    SELECT 4, 'Спекл', 1
    UNION ALL
    SELECT 5, 'Закупівля у постачальника', 0
    UNION ALL
    SELECT 6, 'Підрядник 2', 0
    UNION ALL
    SELECT 7, 'Спекл_ТРАФАРЕТ', 0
    UNION ALL
    SELECT 8, 'Спекл_ЦИФРА', 0
GO