SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   21.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   27.02.2012$
--$Version:    1.00$   $Decription: Готовим данные на изменение$
CREATE PROCEDURE [dbo].[sp_Solutions_TmcPrepare]
    @SolutionID Int
AS
BEGIN
    INSERT INTO #SolutionTmc(ID, SolutionID, TmcID, Amount, Price, [Name], [PartNumber])
    SELECT e.ID, e.SolutionID, e.TmcID, e.Amount, e.Price, t.[Name], t.PartNumber
    FROM dbo.SolutionTmc e
    LEFT JOIN Tmc t ON t.ID = e.TmcID
    WHERE e.SolutionID = @SolutionID
END
GO