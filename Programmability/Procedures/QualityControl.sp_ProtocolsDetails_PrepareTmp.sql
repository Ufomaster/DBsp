SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   19.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: Подготовка редактирования свойств протокола$*/
CREATE PROCEDURE [QualityControl].[sp_ProtocolsDetails_PrepareTmp]
    @ID Int
AS
BEGIN    
    INSERT INTO #ProtocolsDetails(_ID,Caption, ValueToCheck, FactValue, Checked, ModifyDate, SortOrder, ResultKind, DetailBlockID, BlockID, ImportanceID)
    SELECT
        ID, Caption, ValueToCheck, FactValue, Checked, ModifyDate, SortOrder, ResultKind, DetailBlockID, BlockID, ImportanceID
    FROM [QualityControl].ProtocolsDetails d
    WHERE d.ProtocolID = @ID
    ORDER BY d.SortOrder
END
GO