SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   11.08.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   11.08.2011$
--$Version:    1.00$   $Decription: Сохраняем$
CREATE PROCEDURE [dbo].[sp_Solutions_SolutionsDeclaredSave]
    @SolutionID Int
AS
BEGIN
    --удалим удалённые
    DELETE se
    FROM dbo.SolutionsDetail se
    LEFT JOIN #SolutionsDetail t ON t.SolutionID = se.SolutionID AND t.SolutionsDeclaredID = se.SolutionsDeclaredID
    WHERE t.SolutionID IS NULL AND se.SolutionID = @SolutionID

    --Добавим добавленные
    INSERT INTO dbo.SolutionsDetail(SolutionID, SolutionsDeclaredID)
    SELECT @SolutionID, t.SolutionsDeclaredID
    FROM #SolutionsDetail t
    LEFT JOIN SolutionsDetail se ON se.SolutionsDeclaredID = t.SolutionsDeclaredID AND se.SolutionID = @SolutionID
    WHERE t.ID IS NULL AND se.SolutionsDeclaredID IS NULL
    GROUP BY t.SolutionsDeclaredID
END
GO