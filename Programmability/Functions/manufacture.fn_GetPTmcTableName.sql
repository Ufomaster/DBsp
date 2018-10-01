SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   18.02.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   18.02.2014$*/
/*$Version:    1.00$   $Decription: выбор ноды дерева по парент ID$*/
create FUNCTION [manufacture].[fn_GetPTmcTableName] (@TmcID int)
RETURNS varchar(50)
AS
BEGIN
   RETURN ('StorageData.pTMC_'+Convert(varchar(13), @TmcID))
END
GO