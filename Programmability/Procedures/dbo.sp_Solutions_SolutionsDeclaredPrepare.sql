SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   11.08.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   11.08.2011$
--$Version:    1.00$   $Decription: Готовим данные на изменение$
CREATE PROCEDURE [dbo].[sp_Solutions_SolutionsDeclaredPrepare]
    @SolutionID Int
AS
BEGIN
    INSERT INTO #SolutionsDetail(ID, SolutionID, SolutionsDeclaredID)
    SELECT e.ID, e.SolutionID, e.SolutionsDeclaredID
    FROM dbo.SolutionsDetail e
    WHERE e.SolutionID = @SolutionID
END
GO