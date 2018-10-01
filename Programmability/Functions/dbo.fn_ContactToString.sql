SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$	$Create date:   09.12.2015$*/
/*$Modify:     Yuriy Oleynik$	$Modify date:   09.12.2015$*/
/*$Version:    1.00$   $Decription: дата в строку$*/
create FUNCTION [dbo].[fn_ContactToString] (@ID int)
    RETURNS Varchar(255)
AS
BEGIN
    RETURN(SELECT 
        c.[Name] + ISNULL(' ' + c.Position, '') + ISNULL(' ' + c.WorkPhone, '') + ISNULL(' ' + c.CellPhone, '')
    FROM CustomerContacts c
    WHERE c.ID = @ID)
END
GO