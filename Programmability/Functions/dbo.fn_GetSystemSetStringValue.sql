SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   12.09.2012$
--$Modify:     Yuriy Oleynik$    $Modify date:   12.09.2012$
--$Version:    1.00$   $Decription: получаем дефолтовую настройку строковую
CREATE FUNCTION [dbo].[fn_GetSystemSetStringValue] (@ID Int)
RETURNS Varchar(255)
AS
BEGIN
    RETURN (SELECT ss.StringValue FROM SystemSettings ss WHERE ID = @ID)
END
GO