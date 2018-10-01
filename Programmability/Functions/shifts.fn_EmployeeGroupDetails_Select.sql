SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   26.05.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   26.05.2014$*/
/*$Version:    1.00$   $Decription: Get operators list divided by separators $*/
create FUNCTION [shifts].[fn_EmployeeGroupDetails_Select] (@EmployeeGroupsFactID int)
RETURNS varchar(5000)
AS
BEGIN
    DECLARE @Employees varchar(5000)
    SET @Employees = ''

    SELECT @Employees = @Employees + IsNull(e.FullName, '') + ', '
    FROM shifts.EmployeeGroupsFactDetais fd
         LEFT JOIN Employees e on e.ID = fd.EmployeeID
    WHERE fd.EmployeeGroupsFactID = @EmployeeGroupsFactID
    GROUP BY e.FullName
    ORDER BY e.FullName
    
    IF @Employees = ''
       RETURN @Employees

    RETURN Substring(@Employees,1,LEN(@Employees)-1)    
END
GO