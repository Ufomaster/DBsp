SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   19.01.2015$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   11.02.2016$*/
/*$Version:    1.00$   $Description: Просмотр данных полей решений$*/
CREATE PROCEDURE [QualityControl].[sp_Acts_Preview]
    @ActID int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @XMLData xml, @XML varchar(max)
    DECLARE @ParagraphCaption Varchar(8000), @DepartmentPositionName Varchar(8000), @FullName Varchar(8000), 
        @FieldsData varchar(max), @HTML varchar(max)
    

    /*CAST('<ParaCap>' AS varchar(max)) + a.ParagraphCaption + '    ' + e.FullName + '</ParaCap>'*/
    
    CREATE TABLE #tmp(ID int, ActFieldsID int, Value varchar(8000), SortOrder int)
    
    CREATE TABLE #Res(FullName varchar(255), ParaCaption varchar(255), FieldsData  Varchar(8000))
    
    DECLARE Cur CURSOR LOCAL FOR SELECT CAST(a.XMLData AS varchar(max)), ISNULL(a.ParagraphCaption, ''), /*ISNULL(e.DepartmentPositionName, '')*/'', ISNULL(e.FullName, '')
                           FROM QualityControl.ActsDetails a
                           INNER JOIN vw_Employees e ON e.ID = a.EmployeeID
                           WHERE a.ActsID = @ActID
                           ORDER BY a.SortOrder
    OPEN Cur
    FETCH NEXT FROM Cur INTO @XML, @ParagraphCaption, @DepartmentPositionName, @FullName
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DELETE FROM #tmp
        SELECT @XMLData = CAST(@XML AS XML)
        
        INSERT INTO #tmp(ID, ActFieldsID, [Value], SortOrder)
        SELECT
                nref.value('(ID)[1]', 'int') AS ID, 
                nref.value('(ActFieldsID)[1]', 'varchar(255)') AS ActFieldsID,
                nref.value('(Value)[1]', 'varchar(8000)') AS [Value], 
                nref.value('(SortOrder)[1]', 'int') AS SortOrder
        FROM @XMLData.nodes('/Data/Props') R(nref)
        ORDER BY SortOrder
        
        SELECT @FieldsData = ISNULL(@FieldsData, '<br>') + '<font><b>' + ISNULL(f.[Name], '') + '</b></font><br>' + ISNULL(a.[Value], '') + '<br><br>'
        FROM #tmp a
        INNER JOIN QualityControl.ActFields f ON f.ID = a.ActFieldsID
        WHERE  ISNULL(a.Value, '') <> ''
        ORDER BY a.SortOrder
        
        INSERT INTO #Res(FullName, ParaCaption, FieldsData)
        SELECT  @DepartmentPositionName + '   ' + @FullName, @ParagraphCaption, @FieldsData
        SELECT @FieldsData = NULL
        
        FETCH NEXT FROM Cur INTO @XML, @ParagraphCaption, @DepartmentPositionName, @FullName
    END
    CLOSE Cur
    DEALLOCATE Cur

    DROP TABLE #tmp
    SET @HTML = ''
    SELECT @HTML = @HTML + '<br><font size=4 color=blue>' + ISNULL(FullName, '') + '<br>' + ISNULL(ParaCaption, '') + '<br></font>' + ISNULL(FieldsData, '')
    FROM #Res
    
    SELECT @HTML = '<html><body>' + REPLACE(@HTML, CHAR(13)+CHAR(10), '<br>')  + '</body></html>'
    
    SELECT @HTML
    
    DROP TABLE #Res
END
GO