SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Sklyar Nataliia$    $Create date:   12.04.2017$*/
/*$Modify:     Sklyar Nataliia$    $Modify date:   12.04.2017$*/
/*$Version:    1.00$   $Description: Накладные-требования не прошедшие успешно выгрузку в 1С$*/

CREATE PROCEDURE [manufacture].[sp_Stat_1CExpenses]
   @SDate datetime,
   @EDate datetime
AS
BEGIN
    SET NOCOUNT ON  
    
    SELECT e.ID, ms.Name AS [Производство]
           , CASE WHEN e.[Status] = 0 THEN 'Черновик'
                  WHEN e.[Status] = 1 THEN 'Готов к загрузке в 1С'
                  WHEN e.[Status] = 2 THEN 'Загружен и не проведен'
                  WHEN e.[Status] = 4 THEN 'Помечен на удаление в 1С'
                  WHEN e.[Status] = 5 THEN 'Ошибка' 
            END as [Статус документа]
            ,dbo.fn_DateCropTime(e.[Date]) as [Дата выгрузки]
            ,ISNULL (e.DocNumber,'') as [№ док-та в 1С]
            ,ISNULL (e.ErrorMessage,'') as [Текст ошибки]
            ,ed.PCCNumber as [№ ЗЛ]
            ,t.[Name]
            ,ed.Qty as [Кол-во]
            ,CASE WHEN (ed.Skip = 0 OR ed.Skip IS NULL) THEN 'Не выгружать' ELSE NULL END as [Не выгружено в 1С]
    FROM sync.[1CExpensesDetails] ed 
    INNER JOIN [sync].[1CExpenses] e on e.id = ed.[1CExpensesID]
    LEFT JOIN manufacture.ManufactureStructure ms ON e.ManufactureID = ms.ID
    LEFT JOIN dbo.Tmc t on t.Code1C = ed.[TMCCode1С]
    WHERE (e.Date BETWEEN ISNULL(@SDate,e.Date) AND ISNULL(@EDate+1,e.Date)) AND e.[Status] <> 3
    ORDER BY e.id DESC
END
GO