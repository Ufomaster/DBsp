SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   18.02.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   18.02.2014$*/
/*$Version:    1.00$   $Decription: получаем наименование группирующей таблицы$*/
create FUNCTION [manufacture].[fn_GetGroupTableName] (@JobStageID int)
RETURNS varchar(50)
AS
BEGIN
   RETURN ('StorageData.G_'+Convert(varchar(13), @JobStageID))
END
GO