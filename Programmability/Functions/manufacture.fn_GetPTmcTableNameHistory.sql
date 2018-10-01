SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   19.02.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   19.02.2014$*/
/*$Version:    1.00$   $Decription: получаем название таблицы истории$*/
create FUNCTION [manufacture].[fn_GetPTmcTableNameHistory] (@TmcID int)
RETURNS varchar(50)
AS
BEGIN
   RETURN ('StorageData.pTMC_'+Convert(varchar(13), @TmcID))+'H'
END
GO