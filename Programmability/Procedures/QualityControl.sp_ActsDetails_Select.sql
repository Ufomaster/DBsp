SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   07.04.2015$*/
/*$Version:    1.00$   $Description: Выборка решателей акта*/
CREATE PROCEDURE [QualityControl].[sp_ActsDetails_Select]
    @ID Int
AS
BEGIN
    DECLARE @ISeeAll bit, @EmployeeID int
    SELECT @ISeeAll = CASE WHEN a.StatusID = 5 THEN 1 ELSE a.AllSeeAll END --ignore settings allseeall if status="офрмлен".
    FROM QualityControl.Acts a 
    WHERE a.ID = @ID   
    
    SELECT @EmployeeID = EmployeeID FROM #CurrentUser
    
    SELECT
        d.ActsID,
        d.ID,
        d.EmployeeID,
        d.ParagraphCaption,
        d.SortOrder,
        d.XMLData,
        e.FullName,
        CASE WHEN d.SignDate IS NULL THEN 0 ELSE 1 END AS SignExists,
        d.SignDate
    FROM QualityControl.ActsDetails d
    INNER JOIN vw_Employees e ON e.ID = d.EmployeeID
    WHERE d.ActsID = @ID
        AND ((d.EmployeeID = @EmployeeID AND @ISeeAll = 0)
            OR
            (@ISeeAll = 1))
    ORDER BY d.SortOrder
END
GO