SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   05.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   05.12.2013$*/
/*$Version:    1.00$   $Description: Добавление детальной части в темп таблицу при создании акта*/
create PROCEDURE [QualityControl].[sp_ActsDetails_InsertTmpDetails]
    @ActTemplateID Int
AS
BEGIN
    INSERT INTO #ActsDetails(XMLData, ParagraphCaption, EmployeeID, SortOrder)
    EXEC QualityControl.sp_Acts_GenerateDetails @ActTemplateID
END
GO