SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   21.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   21.03.2011$
--$Version:    1.00$   $Decription: Готовим данные на изменение$
CREATE PROCEDURE [dbo].[sp_Solutions_EmployeePrepare]
    @SolutionID Int
AS
BEGIN
    INSERT INTO #SolutionEmployees(ID, SolutionID, EmployeeID)
    SELECT e.ID, e.SolutionID, e.EmployeeID
    FROM dbo.SolutionEmployees e
    WHERE e.SolutionID = @SolutionID
END
GO