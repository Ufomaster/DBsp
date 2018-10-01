SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   18.05.2012$*/
/*$Modify:     Oleynik Yuriy$   $Modify date:   18.05.2012$*/
/*$Version:    1.00$   $Description: Вьюшка узлов подвязки технологии в заказной лист*/
CREATE VIEW [dbo].[vw_ProductionTechHiveNodes]
AS
    SELECT 
        pp.ID,
        parent.ParentName,
        ot.[Name]
    FROM ProductionCardProperties pp
    INNER JOIN (SELECT p.ID, ot.NAME AS ParentName FROM ProductionCardProperties p
                LEFT JOIN ObjectTypes ot ON ot.ID = p.ObjectTypeID
                WHERE p.ParentID IN (SELECT ID FROM ProductionCardProperties WHERE ParentID IS NULL)) parent ON parent.ID = pp.ParentID
    LEFT JOIN ObjectTypes ot ON ot.ID = pp.ObjectTypeID
GO