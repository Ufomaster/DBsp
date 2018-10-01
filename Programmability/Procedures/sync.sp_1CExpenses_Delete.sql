SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    		$Create date:   11.11.2015$*/
/*$Modify:     Oleynik Yuiriy$          $Modify date:   11.11.2015$*/
/*$Version:    1.00$   $Description: удаление материалов из требование накладную$*/
CREATE PROCEDURE [sync].[sp_1CExpenses_Delete]
    @1CExpensesID int
AS
BEGIN
    DELETE FROM sync.[1CExpenses]
    WHERE ID = @1CExpensesID
END
GO