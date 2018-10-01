SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   21.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   21.03.2011$
--$Version:    1.00$   $Decription: Сохраняем$
CREATE PROCEDURE [dbo].[sp_Solutions_EmployeeSave]
    @SolutionID Int
AS
BEGIN
    --удалим удалённые
    DELETE se
    FROM dbo.SolutionEmployees se
    LEFT JOIN #SolutionEmployees t ON t.SolutionID = se.SolutionID AND t.EmployeeID = se.EmployeeID
    WHERE t.SolutionID IS NULL AND se.SolutionID = @SolutionID

    --Добавим добавленные
    INSERT INTO dbo.SolutionEmployees(SolutionID, EmployeeID)
    SELECT @SolutionID, t.EmployeeID
    FROM #SolutionEmployees t
    LEFT JOIN SolutionEmployees se ON se.EmployeeID = t.EmployeeID
    WHERE t.ID IS NULL
    GROUP BY t.EmployeeID
END
GO