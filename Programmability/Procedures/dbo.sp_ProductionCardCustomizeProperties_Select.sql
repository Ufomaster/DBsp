SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   29.12.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   26.04.2012$
--$Version:    1.00$   $Decription: Выбор технологии производства заказного листа$
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeProperties_Select]
    @ParentID Int,
    @Date Datetime,
    @ProductionCardCustomizeID Int = NULL,
    @Type Int = 0
AS
BEGIN
    DECLARE @HiveID Int, @DefaultSourceTypeID Int, @DefaultSourceTypeName Varchar(30)
    SELECT TOP 1 @HiveID = a.ID 
    FROM ProductionCardPropertiesHistory a
    WHERE a.StartDate <= @Date AND a.RootProductionCardPropertiesID = @Type
    ORDER BY a.StartDate DESC
    
    SELECT @DefaultSourceTypeID = st.ID, @DefaultSourceTypeName = st.[Name] FROM vw_ProductionPropertiesSourceType st WHERE st.IsDefault = 1

    SELECT
        p.ID,
        p.ParentID,
        ot.[Name],
        CASE 
            WHEN details.PropHistoryValueID IS NOT NULL THEN details.[Name]
        ELSE ValueDetails.HandMadeValue
        END AS [Value],
        details.PropHistoryValueID,
        ValueDetails.HandMadeValue,
        ValueDetails.HandMadeValueOwnerID,
        CASE WHEN DefVals.ID IS NOT NULL THEN 1 ELSE 0 END AS IsDefaultValue,
        DefVals.ID AS DefaultValueID,
        DefVals.NAME AS DefaultValueName,
        ot.NodeImageIndex,
        p.FixedEdit,
        p.[Required],
        ot.ParentID AS ParentObjectTypeID,
        ot.ID AS ObjectTypeID,        
        CASE 
            WHEN ValueDetails.SourceType IS NOT NULL THEN ValueDetails.SourceType 
        ELSE details.SourceType 
        END AS SourceType,        
        CASE 
            WHEN ValueDetails.SourceTypeName IS NOT NULL THEN ValueDetails.SourceTypeName 
        ELSE details.SourceTypeName 
        END AS SourceTypeName,        
        @DefaultSourceTypeID AS DefaultSourceTypeID,
        @DefaultSourceTypeName AS DefaultSourceTypeName
    FROM ProductionCardPropertiesHistoryDetails p -- тут версии опубликованных деревьев. для возврата в оригинал - верхняя табл
    LEFT JOIN ObjectTypes ot ON p.ObjectTypeID = ot.ID
    LEFT JOIN (SELECT pccp.PropHistoryValueID, pccpDet.ParentID, pccp.SourceType, ot.[Name], ppst.[NAME] AS SourceTypeName
               FROM ProductionCardCustomizeProperties pccp
               INNER JOIN ProductionCardPropertiesHistoryDetails pccpDet ON pccpDet.ID = pccp.PropHistoryValueID
               INNER JOIN ObjectTypes ot ON pccpDet.ObjectTypeID = ot.ID
               LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = pccp.SourceType
               WHERE pccp.ProductionCardCustomizeID = @ProductionCardCustomizeID) details ON details.ParentID = p.ID
    LEFT JOIN (SELECT pccp.HandMadeValue, pccp.HandMadeValueOwnerID, pccp.SourceType, ppst.[NAME] AS SourceTypeName
               FROM ProductionCardCustomizeProperties pccp
               LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = pccp.SourceType
               WHERE pccp.ProductionCardCustomizeID = @ProductionCardCustomizeID) ValueDetails ON ValueDetails.HandMadeValueOwnerID = p.ID
    LEFT JOIN (SELECT ValPccp.ID, ValPccp.ParentID, ot.[Name]
               FROM ProductionCardPropertiesHistoryDetails ValPccp
               INNER JOIN ObjectTypesAttributes ota ON ota.ObjectTypeID = ValPccp.ObjectTypeID AND ota.AttributeID = 6
               INNER JOIN ObjectTypes ot ON ot.ID = ValPccp.ObjectTypeID
               WHERE ValPccp.ProductionCardPropertiesHistoryID = @HiveID) DefVals ON DefVals.ParentID = p.ID
    WHERE (ISNULL(p.ParentID, -1) = CASE WHEN @ParentID IS NULL THEN -1 ELSE @ParentID END) 
        AND p.ProductionCardPropertiesHistoryID = @HiveID
    ORDER BY p.NodeOrder
END
GO