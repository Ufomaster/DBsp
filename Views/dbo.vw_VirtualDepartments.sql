SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	 $Create date:   10.01.2014$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   10.01.2014$*/
/*$Version:    1.00$   $Description: Выборка виртуальных департаментов$*/
create VIEW [dbo].[vw_VirtualDepartments]
AS
    SELECT 
        o.ID, 
        o.[Name],
        o.NodeOrder,
        ISNULL(ISNULL(a9.AttributeID, a10.AttributeID), a16.AttributeID) AS TechAttributID
    FROM ObjectTypes o
    INNER JOIN ObjectTypesAttributes a ON a.ObjectTypeID = o.ID AND a.AttributeID = 17
    LEFT JOIN ObjectTypesAttributes a9 ON a9.ObjectTypeID = o.ID AND a9.AttributeID = 9
    LEFT JOIN ObjectTypesAttributes a10 ON a10.ObjectTypeID = o.ID AND a10.AttributeID = 10
    LEFT JOIN ObjectTypesAttributes a16 ON a16.ObjectTypeID = o.ID AND a16.AttributeID = 16
    WHERE o.[Type] = 1
GO