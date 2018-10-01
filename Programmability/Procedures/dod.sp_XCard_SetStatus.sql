SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   23.06.2018$
--$Modify:     Poliatykin Oleksii$    $Modify date:   23.06.2018$
--$Version:    1.00$   $Decription: Устанавливаем старус успешности операций для карты от устройств в таблице XCardsData_X 

create PROCEDURE [dod].[sp_XCard_SetStatus]
@JobsSettingsID int,
@UID varchar(14),
@Status int
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TableName varchar(50)
           , @TableNameDetails varchar(50)
  SET @TableName = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)

  EXEC (' UPDATE dod.'+@TableName+' set  status = '+@Status+' where UID = '''+@UID+'''

       ')
END
GO