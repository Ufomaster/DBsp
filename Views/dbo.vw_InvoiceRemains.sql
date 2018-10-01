SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   10.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   12.05.2011$
--$Version:    1.00$   $Description: Вьюшка с остатками$
CREATE VIEW [dbo].[vw_InvoiceRemains]
AS
    SELECT
        income.Total AS [Total],
        ISNULL(income.Total, 0) - ISNULL(retired.Total, 0) - ISNULL(inwork.Total, 0) AS Remains,
        income.TmcID,
        ISNULL(retired.Total, 0) + ISNULL(inwork.Total, 0) AS Retired,
        equiped.Total AS Commissioned,
        ISNULL(income.Total, 0) - ISNULL(retired.Total, 0) - ISNULL(inwork.Total, 0) - ISNULL(equiped.Total,0) AS Available
    FROM (SELECT
             TmcID,
             SUM(Amount) AS Total
          FROM vw_InvoiceIncome
          GROUP BY TmcID) AS income
    LEFT JOIN (SELECT SUM(1) AS Total, TmcID
               FROM Equipment 
               WHERE [Status] = 2
               GROUP BY TmcID) AS retired ON retired.TmcID = income.TmcID
    LEFT JOIN (SELECT SUM(1) AS Total, TmcID
               FROM Equipment
               WHERE [Status] <> 2
               GROUP BY TmcID) equiped ON equiped.TmcID = income.TmcID
    LEFT JOIN (SELECT SUM(st.Amount) AS Total, st.TmcID
               FROM SolutionTmc st
               GROUP BY st.TmcID) AS inwork ON inwork.TmcID = income.TmcID
GO