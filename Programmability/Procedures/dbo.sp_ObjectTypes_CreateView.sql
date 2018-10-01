SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$   $Create date:   01.03.2011$
--$Modify:     Yuriy Oleynik$   $Modify date:   13.05.2011$
--$Version:    1.00$   $Description: Генерация заголовка по схеме объекта$
CREATE PROCEDURE [dbo].[sp_ObjectTypes_CreateView]
    @TmcID Int
AS
BEGIN
    CREATE TABLE #tmp(ObjectType Int, ID Int, FieldName nVarchar(100), [Value] Nvarchar(MAX), 
        sID Int, [sFieldName] Varchar(100), sName Varchar(100), sTypeID Int, sReferenceID Int, sSortOrder Int)
    DECLARE @ViewScheme Nvarchar(MAX), @ObjectTypeID Int
    
    SELECT @ObjectTypeID = @ObjectTypeID
    FROM Tmc 
    WHERE ID = @TmcID
    
    INSERT INTO #tmp(ObjectType, ID, FieldName, [Value], sID, [sFieldName], sName, sTypeID, sReferenceID, sSortOrder)
    EXEC sp_Tmc_SchemeValuesSelect @TmcID
    
    SELECT @ViewScheme = ViewScheme
    FROM ObjectTypes
    WHERE ID = @ObjectTypeID
    
    SELECT @ViewScheme = REPLACE(@ViewScheme, '[' + NAME + ']', [Value])
    FROM #tmp
    DROP TABLE #tmp
    
    SELECT @ViewScheme = REPLACE(@ViewScheme, '[ObjectName]', [Name])
    FROM ObjectTypes 
    WHERE ID = @ObjectTypeID
        
    SELECT @TmcID, @ViewScheme 
END
GO