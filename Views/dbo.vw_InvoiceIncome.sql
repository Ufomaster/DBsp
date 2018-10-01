SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	 $Create date:   10.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   14.01.2013$
--$Version:    1.00$   $Description: Вьюшка с приходами по счетам$
CREATE VIEW [dbo].[vw_InvoiceIncome]
AS
    SELECT 
        d.TmcID,
        SUM(d.Price * d.Amount) AS Summ,
        d.RecieveDate,
        SUM(d.Amount) AS Amount,
        d.Price, 
        t.UnitID
    FROM InvoiceDetail d
    INNER JOIN Tmc t ON t.ID = d.TmcID
    WHERE d.RecieveDate IS NOT NULL
    GROUP BY d.TmcID, d.RecieveDate, d.Price, t.UnitID
GO