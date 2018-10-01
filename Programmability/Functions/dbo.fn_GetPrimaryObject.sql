SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Anatoliy Zapadinskiy$    $Create date:   26.12.2012$
--$Modify:     Anatoliy Zapadinskiy$    $Modify date:   26.12.2012$
--$Version:    1.00$   $Decription: возвращает основное средство для выбранного узла ObjectTypes$
create FUNCTION [dbo].[fn_GetPrimaryObject] (@ObjectTypeID int)
    RETURNS Int
AS
BEGIN   
	DECLARE @res int;        
	IF @ObjectTypeID is null
    BEGIN
    	SET @res = NULL
    END    
    Else     
    BEGIN
        
        WITH ResultTable (ID, ParentID, NodeLevel, NodeOrder, Sort)
        AS
        (
            /* Anchor member definition*/
            SELECT
                ot.ID
                , ot.ParentID
                , ot.[Level]
                , ot.NodeOrder
                , CONVERT(Varchar(300), RIGHT('00' + CAST(ot.NodeOrder AS Varchar(2)), 2)) as Sort
            FROM ObjectTypes ot
            WHERE ot.ID = @ObjectTypeID
            UNION ALL
            /* Recursive member definition*/
            SELECT
                ot.ID
                , ot.ParentID
                , ot.[Level]
                , ot.NodeOrder
                ,CONVERT(Varchar(300), d.Sort + '|' + RIGHT('00' + CAST(ot.NodeOrder AS Varchar(2)), 2))
            FROM ObjectTypes AS ot
            INNER JOIN ResultTable AS d ON ot.ID = d.ParentID
        )


        SELECT top 1 
               @res = rt.ID
        FROM ResultTable as rt
             LEFT JOIN ObjectTypesAttributes as ota on (rt.ID = ota.ObjectTypeID) AND ota.AttributeID = 2           
        WHERE ota.ID is not null
        ORDER BY rt.Sort
    END    
    
    RETURN @res
END
GO