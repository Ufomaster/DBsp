SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	 $Create date:   03.11.2017$
--$Modify:     Oleynik Yuriy$    $Modify date:   03.11.2017$
--$Version:    1.00$   $Description: Вьюшка с данными для СКД - составлял Толик, назначение точно не известно
create VIEW [sync].[vw_SKDManufactureShifts]
AS
    SELECT 'ЦЗ' AS [ManufactureName], 1 AS Shift, 8 AS ShiftTimeFrom, 20 AS ShiftTimeTo, 0 AS Offset, 45 AS TimeForBreak, 60 AS TimeForDinnerPlan, 1 AS [Type] UNION 
    SELECT 'ЦЗ', 2, 8, 20, -12, 45, 60, 2 UNION
    SELECT 'ЦЗ', 12, 8, 20, -24, 45, 60, 3 UNION
    SELECT 'ЦЗ', 17, 8, 20, 12, 45, 60, 0 UNION
    SELECT 'ЦОД', 3, 8, 20, 0, 30, 60, 1 UNION 
    SELECT 'ЦОД', 4, 8, 20, -12, 30, 60, 2 UNION 
    SELECT 'ЦОД', 13, 8, 20, -24, 30, 60, 3 UNION 
    SELECT 'ЦОД', 18, 8, 20, 12, 30, 60, 0 UNION 
    SELECT 'ЦПК', 5, 7, 19, 0, 45, 60, 1 UNION 
    SELECT 'ЦПК', 6, 7, 19, -12, 45, 60, 2 UNION 
    SELECT 'ЦПК', 14, 7, 19, -24, 45, 60, 3 UNION 
    SELECT 'ЦПК', 19, 7, 19, 12, 45, 60, 0 UNION 
    SELECT 'ЦКК', 7, 8, 20, 0, 45, 60, 1 UNION 
    SELECT 'ЦКК', 8, 8, 20, -12, 45, 60, 2 UNION 
    SELECT 'ЦКК', 15, 8, 20, -24, 45, 60, 3 UNION 
    SELECT 'ЦКК', 20, 8, 20, 12, 45, 60, 0 UNION 
    SELECT 'ЦПЛГФ', 9, 8, 20, 0, 45, 60, 1 UNION 
    SELECT 'ЦПЛГФ', 11, 8, 20, -12, 45, 60, 2 UNION 
    SELECT 'ЦПЛГФ', 16, 8, 20, -24, 45, 60, 3 UNION 
    SELECT 'ЦПЛГФ', 21, 8, 20, 12, 45, 60, 0 UNION 
    SELECT null, 10, 3, 21, 0, 0, 60, 1
GO