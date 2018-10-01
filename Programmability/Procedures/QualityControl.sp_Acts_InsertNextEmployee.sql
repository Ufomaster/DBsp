SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   10.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   10.12.2013$*/
/*$Version:    1.00$   $Description: генерация детальной части при создании акта*/
create PROCEDURE [QualityControl].[sp_Acts_InsertNextEmployee]
    @ActsID int,
    @ActTemplatesSignersID Int
AS
BEGIN
    DECLARE @XMLData xml, @ID int
    DECLARE @ActsDetails TABLE (XMLData xml, ParagraphCaption varchar(max), EmployeeID int, SortOrder tinyint) 
    DECLARE @t TABLE(ID int)

    SELECT @XMLData = QualityControl.fn_ActGenerateXML(@ActTemplatesSignersID)
         
    INSERT INTO QualityControl.ActsDetails(ActsID, XMLData, ParagraphCaption, EmployeeID, SortOrder)
    OUTPUT INSERTED.ID INTO @t
    SELECT @ActsID, @XMLData, a.ParagraphCaption, e.ID, a.SortOrder
    FROM QualityControl.ActTemplatesSigners a
    INNER JOIN dbo.vw_Employees e ON e.DepartmentPositionID = a.DepartmentPositionID
    WHERE a.ID = @ActTemplatesSignersID
    
    SELECT ID FROM @t
END
GO