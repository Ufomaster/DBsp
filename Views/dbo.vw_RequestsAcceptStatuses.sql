SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   05.07.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   05.07.2011$
--$Version:    1.00$   $Description: Вьюшка с состояниями подтверждений$
CREATE VIEW [dbo].[vw_RequestsAcceptStatuses]
AS
    SELECT 0 AS ID, CAST('Не подтверждена' AS Varchar(50)) AS [Name]
    UNION ALL
    SELECT 1, 'Подтверждена'
GO