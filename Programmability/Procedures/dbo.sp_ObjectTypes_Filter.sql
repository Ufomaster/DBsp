SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   08.10.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   08.10.2012$*/
/*$Version:    1.00$   $Decription: выборка ID объектов по фильтру$*/
CREATE PROCEDURE [dbo].[sp_ObjectTypes_Filter]
    @UserID Int, 
    @ViewTOR Bit, 
    @ViewIT Bit, 
    @ViewPROD Bit, 
    @View1C Bit
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @FilterIT Int, @FilterTOR Int, @FilterProdKind Int
    SELECT /*1 can view. 0 no view*/
        @FilterIT = CASE WHEN ISNULL(MAX(uro1.RightValue), 1) = 3 AND @ViewIT = 1 THEN 1 ELSE 0 END, 
        @FilterTOR = CASE WHEN ISNULL(MAX(uro2.RightValue), 1) = 3 AND @ViewTOR = 1 THEN 1 ELSE 0 END,
        @FilterProdKind = CASE WHEN ISNULL(MAX(uro3.RightValue), 1) = 3 AND @ViewPROD = 1 THEN 1 ELSE 0 END
    FROM RoleUsers ru
    LEFT JOIN UserRightsObjectRights uro1 ON uro1.RoleID = ru.RoleID AND uro1.ObjectID = 105 /*urTmcFilterTypeIT*/
    LEFT JOIN UserRightsObjectRights uro2 ON uro2.RoleID = ru.RoleID AND uro2.ObjectID = 106 /*urTmcFilterTypeTOR*/
    LEFT JOIN UserRightsObjectRights uro3 ON uro3.RoleID = ru.RoleID AND uro3.ObjectID = 134 /*urTmcFilterTypeProdKind*/
    WHERE ru.UserID = @UserID

    SELECT
        ot.ID
    FROM ObjectTypes ot
    LEFT JOIN ObjectTypesAttributes acr_TOR ON acr_TOR.ObjectTypeID = ot.ID AND acr_TOR.AttributeID = 9 AND @FilterTOR = 1 /*TOR*/
    LEFT JOIN ObjectTypesAttributes acr_IT ON acr_IT.ObjectTypeID = ot.ID AND acr_IT.AttributeID = 10 AND @FilterIT = 1/*IT*/
    LEFT JOIN ObjectTypesAttributes acr_PROD ON acr_PROD.ObjectTypeID = ot.ID AND acr_PROD.AttributeID = 11 AND @FilterProdKind = 1/*PROD*/
    LEFT JOIN ObjectTypesAttributes acr_1C ON acr_1C.ObjectTypeID = ot.ID AND acr_1C.AttributeID = 13 AND @View1C = 1 /*1c*/
    WHERE (acr_TOR.ObjectTypeID IS NOT NULL OR acr_IT.ObjectTypeID IS NOT NULL OR acr_PROD.ObjectTypeID IS NOT NULL OR acr_1C.ObjectTypeID IS NOT NULL)
    GROUP BY ot.ID
END
GO