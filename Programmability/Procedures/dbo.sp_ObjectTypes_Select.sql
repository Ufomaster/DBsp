SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   08.10.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.05.2012$*/
/*$Version:    1.00$   $Decription: выборка дерева объектов в селекторе$*/
CREATE PROCEDURE [dbo].[sp_ObjectTypes_Select]
    @UserID Int, 
    @ViewTOR Bit, 
    @ViewIT Bit, 
    @ViewPROD Bit, 
    @View1C Bit
AS
BEGIN
    SET NOCOUNT ON
    CREATE TABLE #AttrFilter(ID Int)
    INSERT INTO #AttrFilter(ID)
    EXEC sp_ObjectTypes_Filter @UserID, @ViewTOR, @ViewIT, @ViewPROD, @View1C

    SELECT
        ot.ID,
        CAST(ot.NodeOrder AS Varchar) + '.' + CAST(ot.[Level] AS Varchar) + ' ' + ot.[Name] AS NameVisible,
        ot.[Name],
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
        ot.[Level],
        ot.BackColor,
        ot.FontBold,
        ot.FontItalic,
        ot.FontColor,
        ot.ParameterName
    FROM ObjectTypes ot 
    INNER JOIN #AttrFilter AS af ON af.ID = ot.ID
    LEFT JOIN ObjectTypesInfo oti ON oti.ObjectTypeID = ot.ID AND oti.UserID = @UserID
    WHERE ot.[Status] = 1 AND ISNULL(ot.IsHidden, 0) = 0
    ORDER BY ot.[Level], ot.ParentID, ot.NodeOrder

    DROP TABLE #AttrFilter
END
GO