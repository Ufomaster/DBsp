SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    		$Create date:   11.11.2015$*/
/*$Modify:     Oleynik Yuiriy$          $Modify date:   27.01.2016$*/
/*$Version:    1.00$   $Description: удаление материалов из требование накладную$*/
CREATE PROCEDURE [sync].[sp_1CExpensesDetails_Delete]
    @ID varchar(8000)
AS
BEGIN
    DELETE FROM sync.[1CExpensesDetails]
    WHERE [ID] IN (SELECT ID FROM dbo.fn_StringToITable(@ID)) 
END
GO