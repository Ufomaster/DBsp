SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Zapadinskiy Anatoliy$    $Create date:   26.01.2012$
--$Modify:     Oleynik Yuiriy$          $Modify date:   19.07.2016$
--$Version:    1.00$   $Description: Выборка связки материала со значением справочника$
CREATE PROCEDURE [dbo].[sp_ObjectTypesMaterials_Select]
    @ObjectTypeID Int, --праймари кей таблицы ObjectTypes, -1 = показать все.
    @Type Int --тип возвращаемых значений 0 - текущие, 1 - история
AS
BEGIN
    SELECT DISTINCT
        otm.ID,
        otm.TmcID,
        otValParent.[Name] + ' - ' + otVal.[Name] AS ObjectTypeName,
        t.[Name] AS MaterialName,
        otm.BeginDate,
        otm.EndDate,
        otm.ObjectTypeID,
        CASE 
            WHEN (otm.EndDate IS NULL AND otm.BeginDate IS NULL) THEN 0
            WHEN (ActiveMaterials.TmcID IS NOT NULL) THEN 1
        ELSE 2
        END AS StatusID,
        CASE 
            WHEN (otm.EndDate IS NULL AND otm.BeginDate IS NULL) THEN 'В разработке'
            WHEN (ActiveMaterials.TmcID IS NOT NULL) THEN 'Действующий'
            ELSE 'Удалён'
        END AS StatusName,
        t.IsHidden,
        otm.GroupName
    FROM ObjectTypesMaterials otm
    LEFT JOIN ConsumptionRates rates ON rates.ObjectTypesMaterialID = otm.ID
    LEFT JOIN ConsumptionRatesDetails c ON c.ConsumptionRateID = rates.ID
    INNER JOIN Tmc t ON t.ID = otm.TmcID
    INNER JOIN ObjectTypes otVal ON otVal.ID = otm.ObjectTypeID
    INNER JOIN ObjectTypes otValParent ON otValParent.ID = otVal.ParentID
    LEFT JOIN (SELECT otm.TmcID, MAX(otm.BeginDate) AS BeginDate, otm.ObjectTypeID, otm.GroupName
               FROM ObjectTypesMaterials AS otm
               WHERE otm.EndDate IS NULL
               GROUP BY otm.TmcID, otm.GroupName, otm.ObjectTypeID) AS ActiveMaterials ON ActiveMaterials.TmcID = otm.TmcID 
         AND ISNULL(ActiveMaterials.GroupName, '') = ISNULL(otm.GroupName, '')
         AND ActiveMaterials.BeginDate = otm.BeginDate AND ActiveMaterials.ObjectTypeID = otm.ObjectTypeID
    WHERE (otm.ObjectTypeID = CASE WHEN @ObjectTypeID <> -1 THEN @ObjectTypeID ELSE otm.ObjectTypeID END 
           OR
             c.ObjectTypeID = CASE WHEN @ObjectTypeID <> -1 THEN @ObjectTypeID ELSE c.ObjectTypeID END)
        AND ((@Type = 0 AND (ActiveMaterials.TmcID IS NOT NULL OR (otm.BeginDate IS NULL AND ActiveMaterials.TmcID IS NULL))) OR @Type = 1)
    ORDER BY MaterialName, otm.BeginDate
END
GO