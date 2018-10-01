SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   10.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.05.2015$*/
/*$Version:    1.00$   $Description: печатная фомра актов - детали*/
CREATE PROCEDURE [QualityControl].[sp_Acts_PF_XMLDetailsSelect]
    @ActsDetailsID int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @XMLData xml, @FullName varchar(255), @DepartmentPositionName varchar(255), @ParagraphCaption varchar(max)

    SELECT 
       @ParagraphCaption = d.ParagraphCaption,
       @FullName = e.FullName,
       @DepartmentPositionName = ISNULL(' (' +e.DepartmentPositionName + ')', ''),
       @XMLData = d.XMLData
    FROM QualityControl.ActsDetails d 
    INNER JOIN dbo.vw_Employees e ON e.ID = d.EmployeeID
    WHERE d.ID = @ActsDetailsID


    DECLARE @Res TABLE (ID int IDENTITY(1,1), Value varchar(1000), FieldCaption varchar(1000), [Type] tinyint) 

    /*INSERT INTO @Res(Value, IsCaption)
    SELECT @ParagraphCaption, 1*/


    INSERT INTO @Res(Value, FieldCaption, [Type])   
    SELECT
        CASE 
           WHEN af.[Type] = 3 THEN 'ФИО ' + @FullName + @DepartmentPositionName + '              Дата ' + nref.value('(Value)[1]', 'varchar(1000)')
        ELSE
           nref.value('(Value)[1]', 'varchar(8000)')
        END,
        af.[Name],
        af.[Type]
    FROM @XMLData.nodes('/Data/Props') R(nref)
    LEFT JOIN QualityControl.ActFields af ON af.ID = nref.value('(ActFieldsID)[1]', 'varchar(255)')
    ORDER BY nref.value('(SortOrder)[1]', 'int')
                               
                          
    SELECT * FROM @Res
END
GO