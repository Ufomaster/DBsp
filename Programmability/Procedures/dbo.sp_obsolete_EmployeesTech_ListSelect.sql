SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   03.12.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   07.07.2015$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [dbo].[sp_obsolete_EmployeesTech_ListSelect]
AS
BEGIN
--obsolete
--удалить если нигде не вылезет ошибка
SELECT NULL, NULL
  --  SELECT e.ID, e.FullName
--    FROM vw_Employees e
--    INNER JOIN RequestTargetEmployees re ON re.EmployeeID = e.ID
END
GO