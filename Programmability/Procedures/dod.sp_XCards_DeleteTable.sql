SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   21.06.2018$
--$Modify:     Poliatykin Oleksii$    $Modify date:   12.07.2018$
--$Version:    1.00$   $Decription: Удаляем таблицы XCardsData_X b XCardsData_XDetailes$
create PROCEDURE [dod].[sp_XCards_DeleteTable]
  @JobsSettingsID int
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TableName varchar(50)
           , @TableNameDetails varchar(50)
  SET @TableName = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)
  SET @TableNameDetails = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)+'Details'


   IF EXISTS(
          select * from information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'dod'
                AND t.TABLE_NAME = @TableNameDetails)
   BEGIN
    EXEC ('
              DROP TABLE [dod].['+@TableNameDetails+']
         ')   
   
   END;

   IF EXISTS(
          select * from information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'dod'
                AND t.TABLE_NAME = @TableName)
   BEGIN
    EXEC ('
              DROP TABLE [dod].['+@TableName+']
         ')   
   
   END;


END
GO