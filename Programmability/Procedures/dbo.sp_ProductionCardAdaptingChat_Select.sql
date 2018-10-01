SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   23.02.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.10.2012$*/
/*$Version:    1.00$   $Decription: Формирует текст для чата$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptingChat_Select]
    @MessageID Int
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @Res Varchar(MAX), @Cnt Int
    SELECT @Res = '', @Cnt = 0

	SELECT tab.body,
           tab.CreateDate,
           tab.FullName,
           --мешаем R, G и B к общепризнанному формату
           SUBSTRING(tab.textcolor, 5, 2) + SUBSTRING(tab.textcolor, 3, 2) + SUBSTRING(tab.textcolor, 1, 2) AS textcolor,          
           ROW_NUMBER() OVER (ORDER BY tab.CreateDate DESC) AS [Order]
    INTO #t           
    FROM
        (SELECT 
            ch.body,
            ch.CreateDate,
            -- преобразуем десятичное число в шестнадцатиричное + добавляем недостающие нули
            SUBSTRING('000000', 1, 6 - LEN(dbo.fn_ConvertToBase(se.TextColor, 16))) + 
              dbo.fn_ConvertToBase(se.TextColor, 16) AS TextColor,
            e.FullName
        FROM ProductionCardCustomizeAdaptingsMesChat ch
        INNER JOIN vw_Employees e ON e.ID = ch.SenderEmployeeID
        LEFT JOIN ProductionCardAdaptingEmployees se ON se.DepartmentPositionID = e.DepartmentPositionID
        WHERE ch.ProductionCardCustomizeAdaptingsMesID = @MessageID 
        ) AS tab        
    ORDER BY tab.CreateDate DESC    

    SELECT
        @Res = @Res + CAST('<font  color=gray>' AS Varchar(MAX)) + dbo.fn_DateToString(CreateDate, 'hh:nn:ss') + ' </font>' +
          CAST('<font' AS Varchar(MAX)) + 
          CASE 
              WHEN TextColor IS NULL THEN ''
--              WHEN [Order] = 1 THEN 
          ELSE ' color=''#' + TextColor + ''''
          END + 
/*          ' size=3>' + dbo.fn_DateToString(CreateDate, 'hh:nn:ss') +  ' (' + FullName + ')</font><br>' +
          '<font size=2>' + REPLACE(Body, Char(13)+Char(10), '<br>') + '</font><br><br>',*/
          '>' +   ' (' + FullName + ')</font><br>' +
          '<font>' + REPLACE(Body, Char(13)+Char(10), '<br>') + '</font><br><br>',
        @Cnt = @Cnt + 1
    FROM #t

    DROP TABLE #t

    SELECT @Res, @Cnt
END
GO