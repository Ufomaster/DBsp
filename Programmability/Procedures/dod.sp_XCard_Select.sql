SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   21.06.2018$
--$Modify:     YuriyOleynik$    $Modify date:   12.07.2018$
--$Version:    1.00$   $Decription: Получаем данные карты для ДОДа$
create PROCEDURE [dod].[sp_XCard_Select]
    @JobsSettingsID int,
    @UID varchar(14)
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TableName varchar(50), @TableNameDetails varchar(50)
  SET @TableName = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)
  SET @TableNameDetails = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)+'Details'

  EXEC (' 
         select * 
             from dod.'+@TableName+' xc 
         left join dod.'+@TableNameDetails+' xcd on xc.ID = xcd.XCardsDataID
         where xc.UID = '''+@UID+'''
         order by xcd.Sector 
       ')

END
GO