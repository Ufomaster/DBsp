SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   16.10.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   27.12.2012$*/
/*$Version:    1.00$   $Decription: выборка счетов$*/
CREATE PROCEDURE [dbo].[sp_Invoice_Select]
    @FilterByTmc Int,
    @TmcID Int,
    @StartDate Datetime,
    @EndDate Datetime,
    @TypeView Int
AS
BEGIN
    SELECT 
        i.*,
        CASE WHEN NonRecieved.cnt > 0 THEN 1 ELSE 0 END AS HasNonRecieved,
        CASE WHEN NonPayed.cnt > 0 THEN 1 ELSE 0 END AS HasNonPayed,
        CASE 
            WHEN NonRecieved.cnt > 0 AND i.PlanRecieveDate < GETDATE() THEN 1
            WHEN ISNULL(NonRecieved.cnt, 0) = 0 AND ISNULL(NonPayed.cnt, 0) = 0 THEN 2
        ELSE 0
        END AS PaintStyle,
        TypeView.TOR,
        TypeView.IT        
    FROM Invoice i
    LEFT JOIN (
                SELECT
                    COUNT(det.ID) AS cnt,
                    det.InvoiceID
                FROM InvoiceDetail det 
                WHERE det.RecieveDate IS NULL
                GROUP BY det.InvoiceID) AS NonRecieved ON NonRecieved.InvoiceID = i.ID
    LEFT JOIN (
                SELECT
                    COUNT(det.ID) AS cnt,
                    det.InvoiceID
                FROM InvoiceDetail det 
                WHERE det.PayDate IS NULL
                GROUP BY det.InvoiceID) AS NonPayed ON NonPayed.InvoiceID = i.ID
    LEFT JOIN (
                SELECT det.InvoiceID,
                       CASE WHEN Count(ta_TOR.TMCID)>0 then 1 else 0 END as TOR,
                       CASE WHEN Count(ta_IT.TMCID)>0 then 1 else 0 END as IT
                FROM InvoiceDetail det
                	 LEFT JOIN TMC t on det.TmcID = t.ID
                     LEFT JOIN (SELECT TMCID FROM TMCAttributes WHERE AttributeID = 9 GROUP BY TMCID) ta_TOR ON ta_TOR.TMCID = t.ID /*TOR*/
    				 LEFT JOIN (SELECT TMCID FROM TMCAttributes WHERE AttributeID = 10 GROUP BY TMCID) ta_IT ON ta_IT.TMCID = t.ID /*IT*/
                GROUP BY det.InvoiceID) AS TypeView ON TypeView.InvoiceID = i.ID                
    WHERE (
           (@FilterByTmc = 1 AND i.ID IN (SELECT InvoiceID FROM InvoiceDetail WHERE TmcID = @TmcID)) 
            OR
           (@FilterByTmc = 0)
          )
          AND
          (i.[Date] BETWEEN ISNULL(@StartDate, i.[Date]) AND ISNULL(@EndDate, i.[Date]))
          AND 
          (
           (@TypeView = 0 AND (TypeView.TOR = 1))
           OR 
           (@TypeView = 1 AND (TypeView.IT = 1))
           OR
           (@TypeView = 2)          
          )          
END
GO