SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   21.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   29.09.2011$
--$Version:    1.00$   $Decription: Сохраняем$
CREATE PROCEDURE [dbo].[sp_Solutions_TmcSave]
    @SolutionID Int
AS
BEGIN
    --удалим удалённые
    DELETE se
    FROM dbo.SolutionTmc se
    LEFT JOIN #SolutionTmc t ON t.TmcID = se.TmcID AND t.Price = se.Price
    WHERE t.TmcID IS NULL AND se.SolutionID = @SolutionID

    --изменим изменённые
    UPDATE se
    SET se.Amount = t.Amount, se.TmcID = t.TmcID, se.Price = t.Price
    FROM dbo.SolutionTmc se
    INNER JOIN #SolutionTmc t ON t.ID = se.ID AND t.SolutionID = se.SolutionID
    WHERE se.SolutionID = @SolutionID

    --Добавим добавленные
    INSERT INTO dbo.SolutionTmc(SolutionID, TmcID, Amount, Price)
    SELECT @SolutionID, t.TmcID, SUM(t.Amount), t.Price
    FROM #SolutionTmc t
    LEFT JOIN SolutionTmc se ON se.TmcID = t.TmcID AND se.SolutionID = @SolutionID AND t.Price = se.Price
    WHERE se.ID IS NULL AND t.Amount > 0
    GROUP BY t.TmcID, t.Price
END
GO