SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   11.06.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   20.09.2016$*/
/*$Version:    1.00$   $Decription: Выбор конструктора технологии производства заказного листа$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_SelectTest]
    @ParentID Int
AS
BEGIN
    SELECT
        p.ID,
        p.ParentID,
        
        ot.[Name] + 
        CASE
            WHEN otaFE.ObjectTypeID IS NOT NULL THEN '[*]'
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
        END AS Name        
        ,
        NULL AS PropHistoryValueID,
        NULL AS HandMadeValue,
        NULL AS HandMadeValueOwnerID,
        
        CASE WHEN DefVals.ID IS NOT NULL THEN 1 ELSE 0 END AS IsDefaultValue,
        DefVals.ID AS DefaultValueID,
        DefVals.NAME AS DefaultValueName,
        
        ot.NodeImageIndex,
        CASE WHEN otaFE.ID IS NULL THEN 1 ELSE 0 END AS FixedEdit,
        CASE WHEN otaR.ID IS NULL THEN 1 ELSE 0 END AS [Required],
        ot.ParentID AS ParentObjectTypeID,
        ot.ID AS ObjectTypeID
    FROM ProductionCardProperties p
    LEFT JOIN ObjectTypes ot ON p.ObjectTypeID = ot.ID
    LEFT JOIN ObjectTypesAttributes otaFE ON otaFE.ObjectTypeID = ot.ID AND otaFE.AttributeID = 7
    LEFT JOIN ObjectTypesAttributes otaR ON otaR.ObjectTypeID = ot.ID AND otaR.AttributeID = 8
    LEFT JOIN ObjectTypesAttributes ota_SpecUse ON ota_SpecUse.ObjectTypeID = ot.ID AND ota_SpecUse.AttributeID = 12 /*исп в спецификации*/       
/*    LEFT JOIN (SELECT pccp.PropHistoryValueID, pccpDet.ParentID, pccp.SourceType, ot.[Name], ppst.[NAME] AS SourceTypeName
               FROM ProductionCardCustomizeProperties pccp
               INNER JOIN ProductionCardPropertiesHistoryDetails pccpDet ON pccpDet.ID = pccp.PropHistoryValueID
               INNER JOIN ObjectTypes ot ON pccpDet.ObjectTypeID = ot.ID
               LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = pccp.SourceType
               WHERE pccp.ProductionCardCustomizeID = @ProductionCardCustomizeID) details ON details.ParentID = p.ID
    LEFT JOIN (SELECT pccp.HandMadeValue, pccp.HandMadeValueOwnerID, pccp.SourceType, ppst.[NAME] AS SourceTypeName
               FROM ProductionCardCustomizeProperties pccp
               LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = pccp.SourceType
               WHERE pccp.ProductionCardCustomizeID = @ProductionCardCustomizeID) ValueDetails ON ValueDetails.HandMadeValueOwnerID = p.ID*/
    LEFT JOIN (SELECT ValPccp.ID, ValPccp.ParentID, ot.[Name]
               FROM ProductionCardProperties ValPccp
               INNER JOIN ObjectTypesAttributes ota ON ota.ObjectTypeID = ValPccp.ObjectTypeID AND ota.AttributeID = 6
               INNER JOIN ObjectTypes ot ON ot.ID = ValPccp.ObjectTypeID) DefVals ON DefVals.ParentID = p.ID
    WHERE p.ParentID = @ParentID
    ORDER BY p.NodeOrder
END
GO