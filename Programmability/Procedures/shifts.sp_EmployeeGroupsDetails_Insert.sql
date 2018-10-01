SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   20.03.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   20.03.2014$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [shifts].[sp_EmployeeGroupsDetails_Insert]
    @EmployeeGroupID int,  
    @ArrayOfEmployeeID varchar(8000) 
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @T table (ID int)

    INSERT INTO shifts.EmployeeGroupsDetails(EmployeeGroupID, EmployeeID) 
    OUTPUT INSERTED.ID INTO @T 
    SELECT @EmployeeGroupID, i.ID
    FROM dbo.fn_StringToITable(@ArrayOfEmployeeID) i
    LEFT JOIN shifts.EmployeeGroupsDetails eg ON i.ID = eg.EmployeeID AND eg.EmployeeGroupID = @EmployeeGroupID
    WHERE eg.EmployeeID IS NULL
    
    SELECT TOP 1 ID FROM @T
END
GO