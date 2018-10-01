SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   05.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   07.05.2015$*/
/*$Version:    1.00$   $Description: генерация детальной части при создании акта*/
CREATE PROCEDURE [QualityControl].[sp_Acts_GenerateDetails]
    @ActTemplateID Int  
AS
BEGIN
/*SET @ActTemplateID = 2
SET @ProtocolID = 16
SET @ActID = 1*/
    DECLARE @XMLData xml, @ID int
    DECLARE @ActsDetails TABLE (XMLData xml, ParagraphCaption varchar(max), EmployeeID int, SortOrder tinyint) 
    DECLARE Cur CURSOR FOR SELECT a.ID
                           FROM QualityControl.ActTemplatesSigners a
                           INNER JOIN dbo.vw_Employees e ON e.DepartmentPositionID = a.DepartmentPositionID
                           WHERE a.ActTemplatesID = @ActTemplateID
                           ORDER BY a.SortOrder
    OPEN Cur
    FETCH NEXT FROM Cur INTO @ID
    WHILE @@FETCH_STATUS = 0 
    BEGIN    
        SELECT @XMLData = QualityControl.fn_ActGenerateXML(@ID)
         
        INSERT INTO @ActsDetails(XMLData, ParagraphCaption, EmployeeID, SortOrder)  
        SELECT @XMLData, a.ParagraphCaption, e.ID, a.SortOrder
        FROM QualityControl.ActTemplatesSigners a
        INNER JOIN dbo.vw_Employees e ON e.DepartmentPositionID = a.DepartmentPositionID
        WHERE a.ID = @ID

        FETCH NEXT FROM Cur INTO @ID
    END
    CLOSE Cur
    DEALLOCATE Cur
    
    SELECT * FROM @ActsDetails
    ORDER BY SortOrder

/*    SELECT    
        nref.value('(ID)[1]', 'int') AS ID, 
        nref.value('(ActFieldsID)[1]', 'varchar(255)') AS ActFieldsID,
        nref.value('(Value)[1]', 'varchar(1000)') AS [Value], 
        nref.value('(SortOrder)[1]', 'int') AS SortOrder 
    FROM @rXML.nodes('/Data/Props') R(nref)*/       

    /*SELECT p.[Caption], p.FactValue 
    FROM QualityControl.ProtocolsDetails p
    WHERE p.ProtocolID = @ProtocolID
    AND p.Checked = 0*/
END
GO