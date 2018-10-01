SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   03.10.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   04.04.2017$*/
/*$Version:    1.00$   $Description: Выбор ТМЦ$*/
CREATE PROCEDURE [dbo].[sp_Tmc_Select]
    @ObjectTypeID Int,
    @UserID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @FilterIT bit, @FilterTOR bit, @FilterProdKind bit, @Filter1c bit

    SELECT /*1 can view. 0 no view*/
        @FilterIT = CASE WHEN ISNULL(MAX(uro1.RightValue), 1) = 3 THEN 1 ELSE 0 END, 
        @FilterTOR = CASE WHEN ISNULL(MAX(uro2.RightValue), 1) = 3 THEN 1 ELSE 0 END,
        @FilterProdKind = CASE WHEN ISNULL(MAX(uro3.RightValue), 1) = 3 THEN 1 ELSE 0 END,
        @Filter1c = CASE WHEN ISNULL(MAX(uro4.RightValue), 1) = 3 THEN 1 ELSE 0 END
    FROM RoleUsers ru
    LEFT JOIN UserRightsObjectRights uro1 ON uro1.RoleID = ru.RoleID AND uro1.ObjectID = 105 /*urTmcFilterTypeIT*/
    LEFT JOIN UserRightsObjectRights uro2 ON uro2.RoleID = ru.RoleID AND uro2.ObjectID = 106 /*urTmcFilterTypeTOR*/
    LEFT JOIN UserRightsObjectRights uro3 ON uro3.RoleID = ru.RoleID AND uro3.ObjectID = 134 /*urTmcFilterTypeProdKind*/
    LEFT JOIN UserRightsObjectRights uro4 ON uro4.RoleID = ru.RoleID AND uro4.ObjectID = 237/*urTmcFilterType1С*/
    WHERE ru.UserID = @UserID

    SELECT ID
    INTO #tmp
    FROM dbo.fn_ObjectTypesNode_Select(@ObjectTypeID)
    UNION 
    SELECT @ObjectTypeID
/*    UNION 
    SELECT ol.ObjectID
    FROM TmcObjectLinks ol
    WHERE ol.TmcID IN (SELECT TmcID FROM TmcObjectLinks WHERE ObjectID IN (SELECT ID FROM dbo.fn_ObjectTypesNode_Select(@ObjectTypeID)))
    GROUP BY ol.ObjectID*/
    
    SELECT
        income.TmcID,
        ISNULL(income.Total, 0) - ISNULL(equiped.Total, 0) - ISNULL(inwork.Total, 0) AS Available
    INTO #iremains
    FROM (SELECT
             TmcID,
             SUM(Amount) AS Total
          FROM vw_InvoiceIncome
          GROUP BY TmcID) AS income
    LEFT JOIN (SELECT COUNT(ID) AS Total, TmcID
               FROM Equipment 
               GROUP BY TmcID) AS equiped ON equiped.TmcID = income.TmcID
               
    LEFT JOIN (SELECT SUM(st.Amount) AS Total, st.TmcID
               FROM SolutionTmc st
               GROUP BY st.TmcID) AS inwork ON inwork.TmcID = income.TmcID

    SELECT TMCID
    INTO #attrtmc
    FROM TMCAttributes WHERE AttributeID = 9 AND @FilterTOR = 1
    UNION
    SELECT TMCID
    FROM TMCAttributes WHERE AttributeID = 10 AND @FilterIT = 1
    UNION
    SELECT TMCID
    FROM TMCAttributes WHERE AttributeID = 11 AND @FilterProdKind = 1
    UNION
    SELECT TMCID
    FROM TMCAttributes WHERE AttributeID = 13 AND @Filter1c = 1
/*    UNION 
    SELECT t.ID
    FROM Tmc t
    LEFT JOIN TMCAttributes ta ON ta.TMCID = t.ID AND ta.AttributeID IN (9,10,11,13)
    WHERE ta.ID IS NULL*/ --для безатрибутных записей.
    
/*    select * from #attrtmc
    PRINT DATEDIFF(ms, @sd, GETDATE())*/
    
    SELECT --DISTINCT
        id.Amount AS WaitForAmount,
        t.ID,
        t.[Name],
        t.ObjectTypeID,
        t.RegistrationDate,
        ColorIndex =
        CASE 
            --WHEN ol.ObjectID IS NULL THEN 3 -- DataBase Error TMC
            WHEN id.Amount IS NOT NULL THEN 4 --violetflag
            WHEN t.DeadCount > 0 AND ISNULL(ir.Available, 0) >= t.DeadCount THEN 0 --GREEN
            WHEN t.DeadCount > 0 AND ISNULL(ir.Available, 0) <= t.DeadCount AND id.Amount IS NULL THEN 1     --RED       
            WHEN t.DeadCount = 0 THEN 2 --No Color
        ELSE 0 --NoColor
        END,
        t.DeadCount,
        t.UnitID,
        ir.Available,
        t.PartNumber,
        t.Code1C,
        t.UserCode1C,
        u.[Name] AS UnitName,
        CASE WHEN t.Code1C IS NOT NULL THEN 1 ELSE 0 END AS is1CSync,
        t.IsHidden,
        t.ProdCardNumber
    FROM Tmc t
    --INNER JOIN #tmp otl ON otl.ID = t.ObjectTypeID
    LEFT JOIN dbo.ObjectTypes ot ON t.ObjectTypeID = ot.ID
    --INNER JOIN dbo.TmcObjectLinks ol ON ol.TmcID = t.ID
    ----INNER JOIN #tmp otl ON otl.ID = ol.ObjectID
    LEFT JOIN Units u ON u.ID = t.UnitID
    LEFT JOIN #iremains ir ON t.ID  = ir.TmcID
    LEFT JOIN #attrtmc atmc ON atmc.TMCID = t.ID
    LEFT JOIN (SELECT SUM(Amount) AS Amount, TmcID FROM InvoiceDetail WHERE RecieveDate IS NULL GROUP BY TmcID) AS id ON id.TmcID = t.ID
    WHERE (t.ObjectTypeID IN (SELECT ID FROM #tmp)) OR
          (t.ID IN (SELECT TmcID FROM TmcObjectLinks WHERE ObjectID IN (SELECT ID FROM #tmp)))

    DROP TABLE #attrtmc
    DROP TABLE #tmp
    DROP TABLE #iremains
END
GO