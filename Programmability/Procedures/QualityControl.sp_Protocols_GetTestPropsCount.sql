SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   25.12.2014$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   13.03.2015$*/
/*$Version:    1.00$   $Description: генерация детальной части при создании протокола$*/
CREATE PROCEDURE [QualityControl].[sp_Protocols_GetTestPropsCount]
    @TypeID Int,
    @TMCID int = NULL
AS
BEGIN
    SELECT COUNT(*)
    FROM QualityControl.ObjectTypeProps pd
    INNER JOIN Tmc t ON t.ID = @TMCID AND t.ObjectTypeID = pd.ObjectTypeID
    LEFT JOIN QualityControl.TMCProps p ON p.ObjectTypePropsID = pd.ID AND p.TMCID = @TMCID AND p.[Status] = 1
    WHERE --(pd.AssignedToQC = 1 OR (pd.AssignedToQC = 0 AND p.AssignedToQC = 1)) AND /*выбираем также оверлоад по полю "Использовать в КК"*/
        EXISTS(SELECT ID FROM QualityControl.TypesBlocks WHERE TmcValuesTest = 1 AND TypesID = @TypeID)
        /*условие отбора только тех что идут на тестирование*/
        AND ((pd.AssignedToTestAct = 1 AND ISNULL(p.AssignedToTestAct, 1) = 1) OR p.AssignedToTestAct = 1)
        AND pd.ID NOT IN (SELECT n.ObjectTypePropsID FROM QualityControl.TMCProps n WHERE n.TMCID = @TMCID AND (n.[Status] = 2 /*фильтруем удалённые*//* OR p.AssignedToQC = 0*/))
END
GO