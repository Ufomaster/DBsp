SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   01.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   13.05.2011$
--$Version:    1.00$   $Description: Выбор данных и полей объекта$
CREATE PROCEDURE [dbo].[sp_Tmc_SchemeValuesSelect]
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
    
    --выбор схемы свойств
    INSERT INTO @Scheme(ObjectTypeID, ID, FieldName, [Name], TypeID, ReferenceID, SortOrder)
    EXEC sp_ObjectTypes_SchemeSelect @ObjectTypeID
   
    --выбор значений свойств
    INSERT INTO @Vals(ObjectTypeID, ID, FieldName, [Value])
    EXEC sp_Tmc_ValueSelect @TMCID

    --выбор схемы и значений
    SELECT
        d.ObjectTypeID,
        d.ID,
        d.FieldName,
        d.[Value],
        s.ID AS sID, 
        s.FieldName AS sFieldName, 
        s.[Name] AS sName, 
        s.TypeID AS sTypeID, 
        s.ReferenceID AS sReferenceID
    FROM @Scheme s
    INNER JOIN @Vals d ON s.ObjectTypeID = d.ObjectTypeID AND s.ID = d.ID
    ORDER BY s.SortOrder
END
GO