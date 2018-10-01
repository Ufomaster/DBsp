SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   08.10.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   13.01.2015$*/
/*$Version:    1.00$   $Decription: выборка тмц в селекторе$*/
CREATE PROCEDURE [dbo].[sp_Tmc_ListSelect]
    @UserID Int,
    @ObjectTypeID Int,
    @ViewTOR Bit = 0, 
    @ViewIT Bit = 0, 
    @ViewPROD Bit = 0, 
    @View1C Bit = 0,
    @ViewRashodniki Bit = 0,
    @ViewService Bit = 0,
    @ViewOS Bit = 0
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @FilterIT Int, @FilterTOR Int, @FilterProdKind Int, @Filter1C Int
    SELECT /*1 can view. 0 no view*/
        @FilterIT = CASE WHEN ISNULL(MAX(uro1.RightValue), 1) = 3 AND @ViewIT = 1 THEN 1 ELSE 0 END, 
        @FilterTOR = CASE WHEN ISNULL(MAX(uro2.RightValue), 1) = 3 AND @ViewTOR = 1 THEN 1 ELSE 0 END,
        @FilterProdKind = CASE WHEN ISNULL(MAX(uro3.RightValue), 1) = 3 AND @ViewPROD = 1 THEN 1 ELSE 0 END,
        @Filter1C = CASE WHEN ISNULL(MAX(uro4.RightValue), 1) = 3 AND @View1C = 1 THEN 1 ELSE 0 END
    FROM RoleUsers ru
    LEFT JOIN UserRightsObjectRights uro1 ON uro1.RoleID = ru.RoleID AND uro1.ObjectID = 105 /*urTmcFilterTypeIT*/
    LEFT JOIN UserRightsObjectRights uro2 ON uro2.RoleID = ru.RoleID AND uro2.ObjectID = 106 /*urTmcFilterTypeTOR*/
    LEFT JOIN UserRightsObjectRights uro3 ON uro3.RoleID = ru.RoleID AND uro3.ObjectID = 134 /*urTmcFilterTypeProdKind*/
    LEFT JOIN UserRightsObjectRights uro4 ON uro4.RoleID = ru.RoleID AND uro4.ObjectID = 237 /*urTmcFilterType1С*/
    WHERE ru.UserID = @UserID

    SELECT
        t.ID
    INTO #AttrFilter
    FROM Tmc t
    LEFT JOIN TmcAttributes acr_TOR  ON acr_TOR.TMCID = t.ID  AND acr_TOR.AttributeID = 9   AND @FilterTOR = 1 /*TOR*/
    LEFT JOIN TmcAttributes acr_IT   ON acr_IT.TMCID = t.ID   AND acr_IT.AttributeID = 10   AND @FilterIT = 1/*IT*/
    LEFT JOIN TmcAttributes acr_PROD ON acr_PROD.TMCID = t.ID AND acr_PROD.AttributeID = 11 AND @FilterProdKind = 1/*PROD*/
    LEFT JOIN TmcAttributes acr_1C   ON acr_1C.TMCID = t.ID   AND acr_1C.AttributeID = 13   AND @Filter1C = 1 /*1c*/
    LEFT JOIN TmcAttributes acr_Rash ON acr_Rash.TMCID = t.ID AND acr_Rash.AttributeID = 1 AND (@FilterTOR = 1 OR @FilterIT = 1 OR @Filter1C = 1)/*расходники*/
    LEFT JOIN TmcAttributes acr_OS   ON acr_OS.TMCID = t.ID   AND acr_OS.AttributeID = 2   AND (@FilterTOR = 1 OR @FilterIT = 1) /*ос*/
    LEFT JOIN TmcAttributes acr_Serv ON acr_Serv.TMCID = t.ID AND acr_Serv.AttributeID = 3 AND (@FilterTOR = 1 OR @FilterIT = 1 OR @Filter1C = 1) /*услуги*/        
    WHERE
        (acr_TOR.TMCID IS NOT NULL OR acr_IT.TMCID IS NOT NULL OR acr_PROD.TMCID IS NOT NULL OR acr_1C.TMCID IS NOT NULL) /* доступ*/
        AND
        (acr_Rash.TMCID IS NOT NULL OR acr_Serv.TMCID IS NOT NULL OR acr_OS.TMCID IS NOT NULL) /* видомость содержимого*/
    GROUP BY t.ID

    CREATE TABLE #ObjAttrFilter(ID Int)
    INSERT INTO #ObjAttrFilter(ID)
    EXEC sp_ObjectTypes_Filter @UserID, @ViewTOR, @ViewIT, @ViewPROD, @View1C
    
    SELECT a.ID
    INTO #ores
    FROM dbo.fn_ObjectTypesNode_Select(@ObjectTypeID) a
    INNER JOIN #ObjAttrFilter oaf ON oaf.ID = a.ID
    GROUP BY a.ID

    INSERT INTO #ores(ID)
    SELECT @ObjectTypeID

    SELECT DISTINCT
        t.ID,
        t.[Name],
        t.PartNumber,
        t.RegistrationDate,
        t.Code1C,
        t.DeadCount,
        ot.[Name] AS ObjectTypeIDName,
        u.[Name] AS UnitName,
        CASE WHEN CAST(ot.XMLSchema.value('(/PropertyList/Props/Name)[1]', 'varchar(max)') AS varchar(max)) = 'Краткое наименование' 
             THEN CAST(t.XMLData.value('(/TMC/Props/Value)[1]', 'varchar(max)') AS varchar(max))
        ELSE NULL
        END AS ShortName,
        t.ProdCardNumber
    FROM Tmc t
    INNER JOIN #AttrFilter af ON AF.ID = t.ID
    INNER JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID
    LEFT JOIN Units u ON u.ID = t.UnitID
    LEFT JOIN #ores r ON t.ObjectTypeID = r.ID
    LEFT JOIN TmcObjectLinks tol ON tol.TmcID = t.ID AND tol.ObjectID IN (SELECT ID FROM #ores)
    WHERE (tol.TmcID IS NOT NULL OR r.ID IS NOT NULL) AND (ISNULL(t.IsHidden, 0) = 0)
    ORDER BY t.[Name]

    DROP TABLE #ObjAttrFilter
    DROP TABLE #AttrFilter
    DROP TABLE #ores
END
GO