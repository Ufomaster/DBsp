SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   12.09.2012$
--$Modify:     Yuriy Oleynik$    $Modify date:   12.09.2012$
--$Version:    1.00$   $Decription: получаем дефолтовую настройку числовую$
CREATE FUNCTION [dbo].[fn_GetSystemSetNumValue] (@ID Int)
RETURNS Decimal(24,8)
AS
BEGIN
    RETURN (SELECT ss.NumericValue FROM SystemSettings ss WHERE ID = @ID)
END
GO