SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   10.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   10.12.2013$*/
/*$Version:    1.00$   $Description: печатная фомра актов - детали*/
create PROCEDURE [QualityControl].[sp_Acts_PF_DetailsSelect]
    @ActsID int
AS
BEGIN
    SELECT 
       d.*,
       e.FullName,
       e.DepartmentPositionName
    FROM QualityControl.ActsDetails d 
    INNER JOIN dbo.vw_Employees e ON e.ID = d.EmployeeID
    WHERE d.ActsID = @ActsID
END
GO