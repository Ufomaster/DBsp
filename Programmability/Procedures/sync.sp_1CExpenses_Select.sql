SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    		$Create date:   10.11.2015$*/
/*$Modify:     Oleynik Yuiriy$          $Modify date:   19.12.2016$*/
/*$Version:    1.00$   $Description: требование накладная$*/
CREATE PROCEDURE [sync].[sp_1CExpenses_Select]
    @ManufactureID int,
    @Date datetime,
    @ViewAll bit = 0
AS
BEGIN
    SET NOCOUNT ON    
    SELECT e.*, ms.Name AS ManufactureName 
    FROM [sync].[1CExpenses] e
    LEFT JOIN manufacture.ManufactureStructure ms ON e.ManufactureID = ms.ID
    WHERE e.ManufactureID = @ManufactureID AND ((dbo.fn_DateCropTime(e.Date) = @Date AND @ViewAll = 0) OR (@ViewAll = 1))
END
GO