SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   23.02.2011$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.04.2017$*/
/*$Version:    1.00$   $Description: Выборка дерева типов объектов$*/
CREATE PROCEDURE [dbo].[sp_TmcTree_Select]
    @UserID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @FilterIT Int, @FilterTOR Int, @FilterProdKind Int, @Filter1C Int
    SELECT /*1 can view. 0 no view*/
        @FilterIT =       CASE WHEN ISNULL(MAX(uro1.RightValue), 1) = 3 THEN 1 ELSE 0 END, 
        @FilterTOR =      CASE WHEN ISNULL(MAX(uro2.RightValue), 1) = 3 THEN 1 ELSE 0 END,
        @FilterProdKind = CASE WHEN ISNULL(MAX(uro3.RightValue), 1) = 3 THEN 1 ELSE 0 END,
        @Filter1C =       CASE WHEN ISNULL(MAX(uro4.RightValue), 1) = 3 THEN 1 ELSE 0 END
    FROM RoleUsers ru
    LEFT JOIN UserRightsObjectRights uro1 ON uro1.RoleID = ru.RoleID AND uro1.ObjectID = 105 /*urTmcFilterTypeIT*/
    LEFT JOIN UserRightsObjectRights uro2 ON uro2.RoleID = ru.RoleID AND uro2.ObjectID = 106 /*urTmcFilterTypeTOR*/
    LEFT JOIN UserRightsObjectRights uro3 ON uro3.RoleID = ru.RoleID AND uro3.ObjectID = 134 /*urTmcFilterTypeProdKind*/
    LEFT JOIN UserRightsObjectRights uro4 ON uro4.RoleID = ru.RoleID AND uro4.ObjectID = 237 /*urTmcFilterType1С*/
    WHERE ru.UserID = @UserID

    SELECT
         ot.ID,
         CAST(ot.NodeOrder AS Varchar) + '.' + CAST(ot.[Level] AS Varchar) + ' ' +
         ot.[Name] + 
             CASE 
                 WHEN Materials.ObjectTypeID IS NOT NULL THEN '[М]'
                 WHEN MaterialsDet.ObjectTypeID IS NOT NULL THEN '[м]'
             ELSE ''
             END
             +
             CASE
                 WHEN ota_HandInput.ObjectTypeID IS NOT NULL THEN '[*]'
             ELSE ''
             END
             +             
             CASE
                 WHEN ota_SpecUse.ObjectTypeID IS NOT NULL THEN '[C]'
             ELSE ''
             END
             +
             CASE
                 WHEN ot.ParameterName IS NOT NULL THEN '[P]'
             ELSE ''
             END             
         AS NameVisible,
         ot.[Name],
         ot.[Name] + 
             CASE 
                 WHEN Materials.ObjectTypeID IS NOT NULL THEN ' [М]'
                 WHEN MaterialsDet.ObjectTypeID IS NOT NULL THEN ' [м]'
             ELSE ''
             END
             +
             CASE
                 WHEN ota_HandInput.ObjectTypeID IS NOT NULL THEN '[*]'
             ELSE ''
             END
             +             
             CASE
                 WHEN ota_SpecUse.ObjectTypeID IS NOT NULL THEN '[C]'
             ELSE ''
             END
             +
             CASE
                 WHEN ot.ParameterName IS NOT NULL THEN '[P]'
             ELSE ''
             END                          
         AS NameVisible2,
         CASE
             WHEN ot.[Status] = 0 THEN 57
             WHEN ot.[Status] = 2 THEN 59
             WHEN ot.NodeImageIndex IS NULL THEN ot.[Type]
         ELSE ot.NodeImageIndex
         END AS NodeImageIndexVisible,
         ot.NodeImageIndex,
         ot.NodeOrder,
         ISNULL(oti.NodeState, 0) AS NodeState,
         ot.ParentID,
         ot.[Status],
         ot.[Type],
         ot.XMLSchema,
         ot.[Level],
         ot.ViewScheme,
         CASE WHEN acr_TOR.ID IS NULL THEN 0 ELSE 1 END AS CanViewTOR,
         CASE WHEN acr_IT.ID IS NULL THEN 0 ELSE 1 END AS CanViewIT,
         CASE WHEN acr_PROD.ID IS NULL THEN 0 ELSE 1 END AS CanViewProd,
        ot.BackColor,
        ot.FontBold,
        ot.FontItalic,
        ot.FontColor,
        ot.IsHidden,
        ot.UserCode1C,
        UPPER(ot.Code1C) AS Code1C,
        ot.ParameterName,
        ot.isStandart
    FROM ObjectTypes ot
    LEFT JOIN ObjectTypesInfo oti ON oti.ObjectTypeID = ot.ID AND oti.UserID = @UserID
    LEFT JOIN ObjectTypesAttributes acr_TOR ON acr_TOR.ObjectTypeID = ot.ID AND acr_TOR.AttributeID = 9 /*TOR*/
    LEFT JOIN ObjectTypesAttributes acr_IT ON acr_IT.ObjectTypeID = ot.ID AND acr_IT.AttributeID = 10 /*IT*/
    LEFT JOIN ObjectTypesAttributes acr_PROD ON acr_PROD.ObjectTypeID = ot.ID AND acr_PROD.AttributeID = 11 /*PROD*/
    LEFT JOIN ObjectTypesAttributes acr_1C ON acr_1C.ObjectTypeID = ot.ID AND acr_1C.AttributeID = 13 /*1CD*/
    LEFT JOIN ObjectTypesAttributes ota_HandInput ON ota_HandInput.ObjectTypeID = ot.ID AND ota_HandInput.AttributeID = 7 /*Hand value input*/
    LEFT JOIN ObjectTypesAttributes ota_SpecUse ON ota_SpecUse.ObjectTypeID = ot.ID AND ota_SpecUse.AttributeID = 12 /*исп в спецификации*/    
    LEFT JOIN (SELECT otm.ObjectTypeID 
               FROM ObjectTypesMaterials otm 
               WHERE otm.EndDate IS NULL AND otm.BeginDate IS NOT NULL
               GROUP BY otm.ObjectTypeID) Materials ON Materials.ObjectTypeID = ot.ID
    LEFT JOIN (SELECT crd.ObjectTypeID 
               FROM dbo.ConsumptionRatesDetails crd
               INNER JOIN dbo.ConsumptionRates cr ON cr.ID = crd.ConsumptionRateID
               INNER JOIN ObjectTypesMaterials otm1 ON otm1.ID = cr.ObjectTypesMaterialID
               WHERE otm1.EndDate IS NULL AND otm1.BeginDate IS NOT NULL
               GROUP BY crd.ObjectTypeID) MaterialsDet ON MaterialsDet.ObjectTypeID = ot.ID
    WHERE (@Filter1C = 1 AND acr_1C.ID IS NOT NULL) OR
          (@FilterTOR = 1 AND acr_TOR.ID IS NOT NULL) OR
          (@FilterIT = 1 AND acr_IT.ID IS NOT NULL) OR
          (@FilterProdKind = 1 AND acr_PROD.ID IS NOT NULL) OR 
          (acr_TOR.ID IS NULL AND acr_IT.ID IS NULL AND acr_PROD.ID IS NULL AND acr_1C.ID IS NULL) /* не заданы атрибуты видимости*/
    ORDER BY ot.[Level], ot.ParentID, ot.NodeOrder
END
GO