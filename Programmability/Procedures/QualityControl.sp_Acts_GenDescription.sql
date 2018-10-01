SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   06.12.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   09.03.2016$*/
/*$Version:    1.00$   $Decription: выборка допустимых статусов акта*/
CREATE PROCEDURE [QualityControl].[sp_Acts_GenDescription]
    @ProtocolID Int
AS
BEGIN
    DECLARE @Res varchar(max)

    --для критических НС ImportanceID = 1
    SELECT 
        @Res = ISNULL(@Res, '') +
        '<tr><td>' + d.[Caption] + '</td>' +  
        '<td>' + d.ValueToCheck + '</td>' + 
        '<td>' + d.FactValue + '</td></tr>'
    FROM (SELECT 
              ISNULL([Caption], '-') AS [Caption],
              ISNULL(ValueToCheck, '-') AS ValueToCheck,
              ISNULL(FactValue, '-') AS FactValue
          FROM QualityControl.ProtocolsDetails
          WHERE ProtocolID = @ProtocolID AND Checked = 0 AND ImportanceID = 1) AS d
                
    SELECT @Res = '<table border=1><tr><th>Наименование</th><th>Нормативное значение</th><th>Фактическое значение</th></tr>' + @Res + '</table>'
    SELECT @Res
END
GO