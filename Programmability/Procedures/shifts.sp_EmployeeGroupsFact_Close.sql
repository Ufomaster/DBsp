SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   01.04.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   01.04.2014$*/
/*$Version:    1.00$   $Decription: Закрытие бригады. Автоматическое$*/
CREATE PROCEDURE [shifts].[sp_EmployeeGroupsFact_Close]
    @EmployeeGroupFactID int
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE a
    SET a.EndDate = GetDate()
    FROM shifts.EmployeeGroupsFact a
    WHERE a.ID = @EmployeeGroupFactID
END
GO