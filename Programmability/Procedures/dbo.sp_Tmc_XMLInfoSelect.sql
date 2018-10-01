SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   08.10.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   08.10.2012$*/
/*$Version:    1.00$   $Decription: выборка XML тмц$*/
CREATE PROCEDURE [dbo].[sp_Tmc_XMLInfoSelect]
    @TMCID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ObjectTypeID Int
    SELECT @ObjectTypeID = ObjectTypeID
    FROM Tmc
    WHERE ID = @TMCID
    
    DECLARE @Scheme TABLE(ObjectTypeID Int, ID Int, FieldName Varchar(100), [Name] Varchar(100), TypeID Int, ReferenceID Int, SortOrder Int)
    DECLARE @Vals TABLE (ObjectTypeID Int, ID Int, FieldName Varchar(100), [Value] Varchar(8000))
    
    /*выбор схемы свойств*/
    INSERT INTO @Scheme(ObjectTypeID, ID, FieldName, [Name], TypeID, ReferenceID, SortOrder)
    EXEC sp_ObjectTypes_SchemeSelect @ObjectTypeID
   
    /*выбор значений свойств*/
    INSERT INTO @Vals(ObjectTypeID, ID, FieldName, [Value])
    EXEC sp_Tmc_ValueSelect @TMCID

    SELECT
        d.ObjectTypeID,
        d.ID,
        d.FieldName,
        d.[Value],
        s.ID AS sID, 
        s.FieldName AS sFieldName, 
        s.[Name] AS sName, 
        s.TypeID AS sTypeID, 
        s.ReferenceID AS sReferenceID,
        t.[Description] AS RefDescr,
        t.[Name] AS RefTableName,
        t.MainField AS RefName
    INTO #Result
    FROM @Scheme s
    INNER JOIN @Vals d ON s.ObjectTypeID = d.ObjectTypeID AND s.ID = d.ID
    LEFT JOIN dbo.Tables t ON t.ID = s.ReferenceID
    ORDER BY s.SortOrder
    
/*    DECLARE @Query Varchar(max), @RefJoinsQuery Varchar(max), @RefValue Varchar(max)*/
    DECLARE @Query Varchar(MAX), @ID Int

    DECLARE Cur CURSOR FOR SELECT ID FROM #Result WHERE sTypeID = 6
    OPEN Cur
    FETCH NEXT FROM Cur INTO @ID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Query = ''

        SELECT @Query =         
'
UPDATE a 
    SET a.[Value] = (SELECT ' + a.RefName+' FROM ' + a.RefTableName + ' WHERE ID = CAST(ISNULL(a.[Value], -1) AS int))
FROM #Result a WHERE a.ID = ' + CAST(@ID AS Varchar)
        FROM #Result a
        WHERE a.ID = @ID
        
        EXEC(@Query)
        /*SELECT @Query*/
            
        FETCH NEXT FROM Cur INTO @ID
    END
    CLOSE Cur
    DEALLOCATE Cur
    
    SELECT 
        ID,
        sName AS [Name],
        CASE 
            WHEN [Value] = 'True' THEN 'Да'
            WHEN [Value] = 'False' THEN 'Нет'
        ELSE [Value]
        END AS [Value]
    FROM #Result
    
    DROP TABLE #Result
END
GO