SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   05.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   03.04.2015$*/
/*$Version:    1.00$   $Description: Подготовка редактирования свойств акта*/
CREATE PROCEDURE [QualityControl].[sp_ActsDetails_PrepareTmp]
    @ID Int
AS
BEGIN    
    INSERT INTO #ActsDetails(_ID, XMLData, ParagraphCaption, EmployeeID, SortOrder, SignDate)    
    SELECT
        d.ID, d.XMLData, d.ParagraphCaption, d.EmployeeID, d.SortOrder, d.SignDate
    FROM [QualityControl].ActsDetails d
    WHERE d.ActsID = @ID
    ORDER BY d.SortOrder
END
GO