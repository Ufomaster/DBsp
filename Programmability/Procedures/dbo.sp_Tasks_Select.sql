SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   01.04.2015$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   08.11.2016$*/
/*$Version:    1.00$   $Description: Список задач*/
CREATE PROCEDURE [dbo].[sp_Tasks_Select]
    @StartDate datetime = NULL,
    @EndDate datetime = NULL,
    @ISeeAll bit,
    @SelectedStatuses varchar(100) = '',
    @SelectedTypes varchar(100) = ''
AS
BEGIN
    DECLARE @EmployeeID int
    
    SELECT @EmployeeID = EmployeeID FROM #CurrentUser
    
    SELECT 
        a.*,
        CASE 
            WHEN a.QCProtocolID IS NOT NULL THEN CAST(p.Number AS varchar) + ' ' + t.[Name] + ISNULL(' ЗЛ № ' + pc.Number, '')
        END AS Info,
        CASE WHEN a.QCActID IS NOT NULL     THEN CAST(ac.Number  AS varchar) --+ ' ' + te.[Name]
        END AS ActInfo,
        ISNULL('№ ' + a.DocNumber + ' ', '') + ISNULL('от ' + dbo.fn_DateToString(a.DocDate, 'ddmmyy'), '') AS DocDateNumber,
        s.ImageIndex,
        s.RowColorIndex,
        c.[Name] AS CustomerName
    FROM Tasks a
    --Для протокола берём № + тип + № ЗЛ, для акта № + имя шаблона
    LEFT JOIN QualityControl.Protocols p ON p.ID = a.QCProtocolID
    LEFT JOIN ProductionCardCustomize pc ON pc.ID = p.PCCID
    LEFT JOIN QualityControl.Acts ac ON ac.ID = a.QCActID    
    LEFT JOIN QualityControl.Protocols pOnActs ON pOnActs.ID = ac.ProtocolID
    LEFT JOIN ProductionOrdersProdCardCustomize ppo ON ppo.ProductionCardCustomizeID = pOnActs.PCCID AND ppo.SortOrder = 1
    LEFT JOIN ProductionOrders o ON o.ID = ppo.ProductionOrdersID
    LEFT JOIN Customers c ON c.ID = o.CustomerID    
    LEFT JOIN QualityControl.Types t ON t.ID = p.TypesID   
    LEFT JOIN QualityControl.ActTemplates te ON te.ID = ac.ActTemplatesID
    LEFT JOIN vw_TasksStatuses s ON s.ID = a.[Status]
    WHERE
        (a.CreateDate BETWEEN ISNULL(@StartDate, a.CreateDate) AND ISNULL(@EndDate, a.CreateDate))
        AND (a.AssignedToEmployeeID = @EmployeeID OR a.EmployeeAuthorID = @EmployeeID or a.ControlEmployeeID = @EmployeeID OR @ISeeAll = 1)
    ORDER BY a.CreateDate
END
GO