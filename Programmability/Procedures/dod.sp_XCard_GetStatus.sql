SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   23.06.2018$
--$Modify:     Poliatykin Oleksii$    $Modify date:   23.06.2018$
--$Version:    1.00$   $Decription: Получаем старус успешности операций для карты от устройств в таблице XCardsData_X 

create PROCEDURE [dod].[sp_XCard_GetStatus]
@JobsSettingsID int,
@UID varchar(14)
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TableName varchar(50)
           , @TableNameDetails varchar(50)
  SET @TableName = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)

  EXEC (' 
         select Status
             from dod.'+@TableName+' xc 
         where xc.UID = '''+@UID+'''
       ')
END
GO